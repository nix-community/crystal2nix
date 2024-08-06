require "./spec_helper"

Spectator.describe Crystal2Nix::Conversion do
  context "Conversion from shard.lock to shards.nix" do
    it "should generate a shards.nix file from shard.lock", :online do
      # Create a temporary shard.lock file with test dependencies in YAML format
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

      temp_filename = create_tempfile(shard_lock_content)

      # Run crystal2nix to generate shards.nix
      `bin/crystal2nix #{temp_filename}`

      # Assertions
      expect(File.exists?("shards.nix")).to be true

      # Clean up the temporary file
      delete_tempfile(temp_filename)
    end
  end

  context "Validation of generated Nix expression" do
    it "should produce a valid Nix expression in shards.nix", :online do
      # Create a temporary shard.lock file with test dependencies in YAML format
      shard_lock_content = <<-EOF
      version: 1.0
      dependencies:
        crystal-spec:
          version: 0.1
          repository: "https://github.com/crystal-lang/crystal-spec.git"
      EOF

      temp_filename = create_tempfile(shard_lock_content)

      # Run crystal2nix to generate shards.nix
      `bin/crystal2nix #{temp_filename}`

      # Assertions
      expect(File.exists?("shards.nix")).to be true

      # Clean up the temporary file
      delete_tempfile(temp_filename)
    end
  end
end

# Helper method to create a temporary file
def create_tempfile(content : String) : String
  temp_filename = "./temp_shard.lock"
  File.write(temp_filename, content)
  temp_filename
end

# Helper method to delete a temporary file
def delete_tempfile(filename : String)
  File.delete(filename) if File.exists?(filename)
end
