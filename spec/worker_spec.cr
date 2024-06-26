require "./spec_helper"
require "../src/crystal2nix"

Spectator.describe Crystal2Nix::Worker do
  describe "#initialize" do
    it "raises an error if lock file does not exist" do
      expect {
        Crystal2Nix::Worker.new("nonexistent_lock_file.lock")
      }.to raise_error(Exception)
    end
  end

  describe "#run" do
    it "creates shards.nix file" do
      lock_file = "test_lock_file.lock"
      File.write(lock_file, <<-YAML)
version: 1.0
shards:
  example_shard:
    git: https://github.com/example/example.git
    version: v1.0.0
YAML

      worker = Crystal2Nix::Worker.new(lock_file)
      worker.run

      expect(File.exists?(Crystal2Nix::Worker::SHARDS_NIX)).to be_true

      # Clean up the temporary files
      File.delete(lock_file)
      File.delete(Crystal2Nix::Worker::SHARDS_NIX)
    end
  end
end
