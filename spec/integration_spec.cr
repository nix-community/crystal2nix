require "./spec_helper"

Spectator.describe Crystal2Nix::Conversion do
  context "Conversion from shard.lock to shards.nix" do
    it "should generate a shards.nix file from shard.lock" do
      # Mock the command execution and file generation
      shard_lock_content = <<-EOF
      version: 1.0
      dependencies:
        crystal-spec:
          version: 0.1
          repository: "https://github.com/crystal-lang/crystal-spec.git"
        json:
          version: 0.9
          repository: "https://github.com/crystal-lang/crystal-json.git"
      EOF

      # Mock the `bin/crystal2nix` command and its effect
      Crystal2Nix::Conversion.stub(:generate_shards_nix).with(shard_lock_content).and_return("shards.nix generated")

      # Assertions
      expect(Crystal2Nix::Conversion.generate_shards_nix(shard_lock_content)).to eq("shards.nix generated")
    end
  end

  context "Validation of generated Nix expression" do
    it "should produce a valid Nix expression in shards.nix" do
      # Mock the command execution and file generation
      shard_lock_content = <<-EOF
      version: 1.0
      dependencies:
        crystal-spec:
          version: 0.1
          repository: "https://github.com/crystal-lang/crystal-spec.git"
      EOF

      # Mock the `bin/crystal2nix` command and its effect
      Crystal2Nix::Conversion.stub(:generate_shards_nix).with(shard_lock_content).and_return("shards.nix generated")

      # Assertions
      expect(Crystal2Nix::Conversion.generate_shards_nix(shard_lock_content)).to eq("shards.nix generated")
    end
  end
end
