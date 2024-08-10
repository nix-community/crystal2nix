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
          sha256 = ""

          if repo.type == :git
            args = [
              "--no-deepClone",
              "--url", repo.url,
              "--rev", repo.rev,
            ]
            Process.run("nix-prefetch-git", args: args) do |x|
              x.error.each_line { |e| puts e }
              sha256 = PrefetchJSON.from_json(x.output.gets_to_end).sha256
            end
          elsif repo.type == :hg
            # Correct invocation for nix-prefetch-hg
            args = [
              repo.url,
              repo.rev,
            ]
            Process.run("nix-prefetch-hg", args: args) do |x|
              x.error.each_line { |e| puts e }

              # Check if the output is empty or an error
              output = x.output.gets_to_end.strip
              if output.empty?
                STDERR.puts "Failed to fetch hash with nix-prefetch"
                exit 1
              else
                sha256 = output
              end
            end
          end

          file.puts %(  #{key} = {)
          file.puts %(    url = "#{repo.url}";)
          file.puts %(    rev = "#{repo.rev}";)
          file.puts %(    sha256 = "#{sha256}";)
          file.puts %(  };)
        end
        file.puts %(})
      end
    end
  end
end

