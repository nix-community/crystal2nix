require "../src/crystal2nix"
require "spectator"

module SpecHelper
    def self.verify_shards_nix_content(expected_content : Hash(String, Hash(String, String)))
      content = File.read("shards.nix")
      expected_content.each do |name, details|
        content.should contain("\"name\": \"#{name}\"")
        content.should contain("\"version\": \"#{details["version"]}\"")
        content.should contain("\"github\": \"#{details["repository"].gsub("https://github.com/", "").gsub(".git", "")}\"")
      end
    end
  
    def self.create_shard_lock(dependencies : Hash(String, Hash(String, String)))
      content = { "dependencies" => dependencies }.to_json
      File.write("shard.lock", content)
    end
  
    def self.run_crystal2nix
      system("crystal2nix --lock-file=shard.lock > shards.nix")
    end
  end
  