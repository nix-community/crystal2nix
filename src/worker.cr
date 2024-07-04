module Crystal2Nix
  SHARDS_NIX = "shards.nix"

  class Worker
    def initialize(@lock_file : String)
    end

    def run
      File.open SHARDS_NIX, "w+" do |file|
        file.puts %({)
        ShardLock.from_yaml(File.read(@lock_file)).shards.each do |key, shard|
          repo = Repo.new(shard.url, shard.rev)
          if repo.nil?
            STDERR.puts "Unable to parse repository entry"
            exit 1
          end
          sha256 = ""
          case
          when repo.url.ends_with?(".git")
            args = [
              "--no-deepClone",
              "--url", repo.url,
              "--rev", repo.rev,
            ]
            Process.run("nix-prefetch-git", args: args) do |x|
              x.error.each_line { |e| puts e }
              sha256 = PrefetchJSON.from_json(x.output).sha256
            end
          when repo.url.starts_with?("https://hg.") || repo.url.ends_with?(".hg")
            args = [
              "--url", repo.url,
              "--rev", repo.rev,
            ]
            Process.run("nix-prefetch-hg", args: args) do |x|
              x.error.each_line { |e| puts e }
              sha256 = PrefetchJSON.from_json(x.output).sha256
            end
          when repo.url.ends_with?(".fossil")
            STDERR.puts "Fossil repositories are not supported."
            next
          else
            STDERR.puts "Unknown repository type for #{repo.url}"
            next
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