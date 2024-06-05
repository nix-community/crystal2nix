module Crystal2Nix
  SHARDS_NIX = "shards.nix"

  class Worker
    def initialize(@lock_file : String)
    end

    def run
      File.open SHARDS_NIX, "w+" do |file|
        file.puts "{"
        ShardLock.from_yaml(File.read(@lock_file)).shards.each do |key, value|
          repo = Repo.new value["url"], value["rev"], value["type"].to_sym
          if repo.nil?
            STDERR.puts "Unable to parse repository entry"
            exit 1
          end
          sha256 = ""
          case repo.type
          when :git
            args = [
              "--no-deepClone",
              "--url", repo.url,
              "--rev", repo.rev,
            ]
            Process.run("nix-prefetch-git", args: args) do |x|
              x.error.each_line { |e| puts e }
              sha256 = PrefetchJSON.from_json(x.output).sha256
            end
          when :http
            args = [
              "--url", repo.url
            ]
            Process.run("nix-prefetch-url", args: args) do |x|
              x.error.each_line { |e| puts e }
              sha256 = x.output.strip
            end
          else
            STDERR.puts "Unsupported repository type: #{repo.type}"
            exit 1
          end

          file.puts "  #{key} = {"
          file.puts "    url = \"#{repo.url}\";"
          file.puts "    rev = \"#{repo.rev}\";" if repo.rev
          file.puts "    sha256 = \"#{sha256}\";"
          file.puts "  };"
        end
        file.puts "}"
      end
    end
  end
end
