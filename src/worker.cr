require "./data"

module Crystal2Nix
  class Worker
    SHARDS_NIX = "shards.nix"

    def initialize(@lock_file : String)
      validate_lock_file
    end

    def run
      shards = parse_shards
      File.open SHARDS_NIX, "w+" do |file|
        file.puts "{"
        shards.each do |name, shard|
          process_shard(file, name, shard)
        end
        file.puts "}"
      end
    end

    private def validate_lock_file
      unless File.exists?(@lock_file)
        STDERR.puts "Lock file #{@lock_file} does not exist."
        exit 1
      end
    end

    private def parse_shards
      content = File.read(@lock_file)
      ShardLock.from_yaml(content).shards
    end

    private def process_shard(file, name, shard)
      sha256 = fetch_sha256(shard)
      if sha256.nil?
        STDERR.puts "Failed to fetch sha256 for #{shard.git}"
        return
      end

      write_shard(file, name, shard, sha256)
    end

    private def fetch_sha256(shard)
      case
      when shard.git.ends_with?(".git")
        fetch_with_nix_prefetch("nix-prefetch-git", ["--no-deepClone", "--url", shard.git, "--rev", shard.version])
      when shard.git.starts_with?("https://hg.") || shard.git.ends_with?(".hg")
        fetch_with_nix_prefetch("nix-prefetch-hg", ["--url", shard.git, "--rev", shard.version])
      when shard.git.ends_with?(".fossil")
        STDERR.puts "Fossil repositories are not supported."
        nil
      else
        STDERR.puts "Unknown repository type for #{shard.git}"
        nil
      end
    end

    private def fetch_with_nix_prefetch(command, args)
      sha256 = ""
      Process.run(command, args: args) do |process|
        process.error.each_line { |e| STDERR.puts e }
        sha256 = PrefetchJSON.from_json(process.output).sha256
      end
      sha256
    end

    private def write_shard(file, name, shard, sha256)
      file.puts "  #{name} = {"
      file.puts "    url = \"#{shard.git}\";"
      file.puts "    rev = \"#{shard.version}\";"
      file.puts "    sha256 = \"#{sha256}\";"
      file.puts "  };"
    end
  end
end
