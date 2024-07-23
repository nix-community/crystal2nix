require "../src/crystal2nix"
require "spec"

# Test case for conversion from shard.lock to shards.nix
describe "Conversion from shard.lock to shards.nix" do
  before_each do
    ENV["NO_NETWORK"] = "true"

    # Create a shard.lock file with test dependencies
    File.write("shard.lock", <<-JSON)
    {
      "dependencies": {
        "crystal-spec": {
          "version": "0.1.0",
          "repository": "https://github.com/crystal-lang/crystal-spec.git"
        },
        "json": {
          "version": "0.9.11",
          "repository": "https://github.com/crystal-lang/crystal-json.git"
        }
      }
    }
    JSON

    # Run crystal2nix to generate shards.nix
    `bin/crystal2nix`
  end

  it "should generate a valid shards.nix file from shard.lock" do
    # Check if the shards.nix file exists
    File.exists?("shards.nix").should be_true

    # Read and validate the content of the shards.nix file
    content = File.read("shards.nix")
    content.should contain("{ pkgs, ... }:")
    content.should contain("crystal-spec = pkgs.crystal.buildCrystalPackage")
    content.should contain("json = pkgs.crystal.buildCrystalPackage")
  end
end

# Test case for validation of generated Nix expression
describe "Validation of generated Nix expression" do
  before_each do
    ENV["NO_NETWORK"] = "true"

    # Create a shard.lock file with test dependencies
    File.write("shard.lock", <<-JSON)
    {
      "dependencies": {
        "crystal-spec": {
          "version": "0.1.0",
          "repository": "https://github.com/crystal-lang/crystal-spec.git"
        }
      }
    }
    JSON

    # Run crystal2nix to generate shards.nix
    `bin/crystal2nix`
  end

  it "should produce a valid Nix expression in shards.nix" do
    # Check if the shards.nix file exists
    File.exists?("shards.nix").should be_true

    # Read and validate the content of the shards.nix file
    content = File.read("shards.nix")
    content.should contain("{ pkgs, ... }:")
    content.should contain("crystal-spec = pkgs.crystal.buildCrystalPackage")
  end
end
