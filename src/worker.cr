module Crystal2Nix
  SHARDS_NIX = "shards.nix"

  class Worker
    def initialize(@lock_file : String)
    end

    def run
      File.open SHARDS_NIX, "w+" do |file|
        file.puts %({)
        ShardLock.from_yaml(File.read(@lock_file)).shards.each do |key, value|
          repo = Repo.new value
          if repo.nil?
            STDERR.puts "Unable to parse repository entry"
            exit 1
          end

          hash = ""

          case repo.type
          when :git
            args = [
              "--url", repo.url,
              "--rev", repo.rev,
            ]
            Process.run("nix-prefetch-git", args: args) do |process|
              process.error.each_line { |e| STDERR.puts e }
              hash = PrefetchJSON.from_json(process.output.gets_to_end).sha256
            end

          when :hg
            args = [
              repo.url,
              repo.rev,
            ]
            Process.run("nix-prefetch-hg", args: args) do |process|
              process.error.each_line { |e| STDERR.puts e }
              output = process.output.gets_to_end
              hash = output.strip.split("\n").first
              if hash.nil? || hash.empty?
                STDERR.puts "Failed to fetch hash for hg repository: #{repo.url}"
                hash = "hash not found"
              end
            end

          else
            STDERR.puts "Unknown repository type: #{repo.type}"
            hash = "hash not found"
          end

          file.puts %(  #{key} = {)
          file.puts %(    url = "#{repo.url}";)
          file.puts %(    rev = "#{repo.rev}";)
          file.puts %(    hash = "#{hash}";)
          file.puts %(  };)
        end
        file.puts %(})
      end
    end
  end
end
