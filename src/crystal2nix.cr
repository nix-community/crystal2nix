require "json_mapping"
require "uri"
require "yaml_mapping"

module Crystal2Nix
  class PrefetchJSON
    JSON.mapping(sha256: String)
  end

  class ShardLock
    YAML.mapping(
      version: Float32,
      shards: Hash(String, Hash(String, String))
    )
  end

  class RepoUrl
    @url : URI
    @path : Array(String)

    def initialize(kind : String, repo : String)
      t = case kind
          when "git"
            repo
          when "github"
            "https://github.com/#{repo}"
          else
            ArgumentError.new "Unknown key: #{kind}"
            exit 1
          end
      @url = URI.parse(t).normalize
      @path = @url.path.split("/")
    end

    def github?
      @url.host == "github.com"
    end

    def owner : String
      @path[1]
    end

    def repo : String
      github? ? @path[2].gsub(/\.git$/, "") : @path[2]
    end

    def to_s : String
      @url.to_s
    end
  end

  class Cli
    SHARD_LOCK     = "shard.lock"
    SHARDS_NIX     = "shards.nix"
    SUPPORTED_KEYS = %w[git github]

    @lock_file : String

    def initialize
      @lock_file = ARGV.fetch(1, SHARD_LOCK)
      unless File.exists? @lock_file
        STDERR.puts "ERROR: #{@lock_file} not found"
        exit 1
      end
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
                  "v#{value["version"]}"
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

Crystal2Nix::Cli.new.run
