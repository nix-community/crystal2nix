require "spec"
require "./spec_helper"

describe "Crystal2Nix Integration Tests" do
  before_each do
    ENV["NO_NETWORK"] = "true"
  end

  describe "Conversion from shard.lock to shards.nix" do
    before_each do
      SpecHelper.create_shard_lock({
        "crystal-spec" => { "version" => "0.1.0", "repository" => "https://github.com/crystal-lang/crystal-spec.git" },
        "json" => { "version" => "0.9.11", "repository" => "https://github.com/crystal-lang/crystal-json.git" }
      })
      SpecHelper.run_crystal2nix
    end

    it "generates a shards.nix file from shard.lock" do
      File.exists?("shards.nix").should be_true
      SpecHelper.verify_shards_nix_content({
        "crystal-spec" => { "version" => "0.1.0", "repository" => "https://github.com/crystal-lang/crystal-spec.git" },
        "json" => { "version" => "0.9.11", "repository" => "https://github.com/crystal-lang/crystal-json.git" }
      })
    end
  end

  describe "Verification of Generated Nix Expression" do
    before_each do
      SpecHelper.create_shard_lock({
        "crystal-spec" => { "version" => "0.1.0", "repository" => "https://github.com/crystal-lang/crystal-spec.git" }
      })
      SpecHelper.run_crystal2nix
    end

    it "produces a valid Nix expression in shards.nix" do
      File.exists?("shards.nix").should be_true
      SpecHelper.verify_shards_nix_content({
        "crystal-spec" => { "version" => "0.1.0", "repository" => "https://github.com/crystal-lang/crystal-spec.git" }
      })
      content = File.read("shards.nix")
      content.should contain("{ pkgs, ... }:")
      content.should contain("crystal-spec = pkgs.crystal.buildCrystalPackage")
    end
  end

  describe "Conversion from shard.lock to shards.nix with multiple dependencies" do
    before_each do
      SpecHelper.create_shard_lock({
        "crystal-spec" => { "version" => "0.1.0", "repository" => "https://github.com/crystal-lang/crystal-spec.git" },
        "json" => { "version" => "0.9.11", "repository" => "https://github.com/crystal-lang/crystal-json.git" },
        "http" => { "version" => "0.8.0", "repository" => "https://github.com/crystal-lang/crystal-http.git" }
      })
      SpecHelper.run_crystal2nix
    end

    it "generates a valid shards.nix file from shard.lock with multiple dependencies" do
      File.exists?("shards.nix").should be_true
      SpecHelper.verify_shards_nix_content({
        "crystal-spec" => { "version" => "0.1.0", "repository" => "https://github.com/crystal-lang/crystal-spec.git" },
        "json" => { "version" => "0.9.11", "repository" => "https://github.com/crystal-lang/crystal-json.git" },
        "http" => { "version" => "0.8.0", "repository" => "https://github.com/crystal-lang/crystal-http.git" }
      })
    end
  end
end
