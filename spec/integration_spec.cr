require "../src/crystal2nix"
require "spec"

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

describe "Conversion from shard.lock to shards.nix" do
  before_each do
    ENV["NO_NETWORK"] = "true"
  end

  it "should generate a shards.nix file from shard.lock" do
    # Create a temporary shard.lock file with test dependencies in YAML format
    shard_lock_content = <<-YAML
    version: 1.0
    dependencies:
      crystal-spec:
        version: 0.1
        repository: "https://github.com/crystal-lang/crystal-spec.git"
      json:
        version: 0.9
        repository: "https://github.com/crystal-lang/crystal-json.git"
    YAML

    temp_filename = create_tempfile(shard_lock_content)

    # Run crystal2nix to generate shards.nix
    `bin/crystal2nix #{temp_filename}`

    # Assertions
    File.exists?("shards.nix").should be_true

    # Clean up the temporary file
    delete_tempfile(temp_filename)
  end
end

describe "Validation of generated Nix expression" do
  before_each do
    ENV["NO_NETWORK"] = "true"
  end

  it "should produce a valid Nix expression in shards.nix" do
    # Create a temporary shard.lock file with test dependencies in YAML format
    shard_lock_content = <<-YAML
    version: 1.0
    dependencies:
      crystal-spec:
        version: 0.1
        repository: "https://github.com/crystal-lang/crystal-spec.git"
    YAML

    temp_filename = create_tempfile(shard_lock_content)

    # Run crystal2nix to generate shards.nix
    `bin/crystal2nix #{temp_filename}`

    # Assertions
    File.exists?("shards.nix").should be_true

    # Clean up the temporary file
    delete_tempfile(temp_filename)
  end
end
