module Crystal2Nix
  SHARDS_NIX     = "shards.nix"
  SUPPORTED_KEYS = %w[git github]

  class Worker
    def initialize(@lock_file : String)
    end

    def run
      File.open SHARDS_NIX, "w+" do |file|
        file.puts %({)
        ShardLock.from_yaml(File.read(@lock_file)).shards.each do |key, value|
          url = nil
          SUPPORTED_KEYS.each do |k|
            url = RepoUrl.new(k, value[k]) if value.has_key?(k)
          end
          if url.nil?
            STDERR.puts "Unable to parse repository entry"
            exit 1
          end
          rev = if value["version"]?
                  if value["version"] =~ /^(?<version>.+)\+git\.commit\.(?<rev>.+)$/
                    $~["rev"]
                  else
                    "v#{value["version"]}"
                  end
                else
                  value["commit"]
                end
          sha256 = ""
          args = ["--url", url.to_s, "--rev", rev]
          Process.run("nix-prefetch-git", args: args) do |x|
            x.error.each_line { |e| puts e }
            sha256 = PrefetchJSON.from_json(x.output).sha256
          end

          file.puts %(  #{key} = {)
          file.puts %(    owner = "#{url.owner}";)
          file.puts %(    repo = "#{url.repo}";)
          file.puts %(    rev = "#{rev}";)
          file.puts %(    sha256 = "#{sha256}";)
          file.puts %(  };)
        end
        file.puts %(})
      end
    end
  end
end
