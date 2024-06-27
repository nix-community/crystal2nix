# spec/offline_integration_spec.cr

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
    it "handles an empty lock file and creates an empty shards.nix file" do
      lock_file = "empty_lock_file.lock"
      File.write(lock_file, <<-YAML)
version: 1.0
shards: {}
YAML

      worker = Crystal2Nix::Worker.new(lock_file)
      worker.run

      expect(File.exists?(Crystal2Nix::Worker::SHARDS_NIX)).to be_true
      expect(File.read(Crystal2Nix::Worker::SHARDS_NIX)).to eq ""

      # Clean up the temporary files
      File.delete(lock_file)
      File.delete(Crystal2Nix::Worker::SHARDS_NIX)
    end
  end
end
