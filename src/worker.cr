module Crystal2Nix
  SHARDS_NIX = "shards.nix"

  class Worker
    def initialize(@lock_file : String)
    end

    def run
      File.open SHARDS_NIX, "w+" do |file|
        file.puts %({)
        ShardLock.from_yaml(File.read(@lock_file)).shards.each do |key, value|
          begin
            repo = Repo.new value
          rescue ex : Exception
            STDERR.puts "Error processing repository #{key}: #{ex.message}"
            next
          end

          sha256 = ""

          case repo.type
          when :git
            args = [
              "--url", repo.url,
              "--rev", repo.rev,
            ]
            begin
              Process.run("nix-prefetch-git", args: args) do |process|
                process.error.each_line { |e| STDERR.puts e }
                json_output = process.output.gets_to_end
                sha256 = GitPrefetchJSON.from_json(json_output).sha256
              end
            rescue ex : Exception
              STDERR.puts "Error running nix-prefetch-git: #{ex.message}"
              next
            end

          when :hg
            args = [
              repo.url,
              repo.rev,
            ]
            begin
              Process.run("nix-prefetch-hg", args: args) do |process|
                process.error.each_line { |e| STDERR.puts e }
                output = process.output.gets_to_end
                sha256 = output.strip.split("\n").first
              end
            rescue ex : Exception
              STDERR.puts "Error running nix-prefetch-hg: #{ex.message}"
              next
            end

          else
            STDERR.puts "Unsupported repository type for #{key}: #{repo.type}"
            STDERR.puts "Currently supported types are: git, hg"
            next
          end

          # Write to the file
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
