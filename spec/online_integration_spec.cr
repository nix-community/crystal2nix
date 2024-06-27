require "./spec_helper"
require "../src/crystal2nix"

Spectator.describe Crystal2Nix::Worker, "online" do
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

    it "shards.nix file contains correct content" do
      lock_file = "test_lock_file.lock"
      File.write(lock_file, <<-YAML)
version: 1.0
shards:
  example_shard:
    git: https://github.com/example/example.git
    version: v1.0.0
YAML

      expected_nix_content = <<-NIX
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "example_shard";
  src = pkgs.fetchFromGitHub {
    owner = "example";
    repo = "example";
    rev = "v1.0.0";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
}
NIX

      worker = Crystal2Nix::Worker.new(lock_file)
      worker.run

      actual_nix_content = File.read(Crystal2Nix::Worker::SHARDS_NIX)
      expect(actual_nix_content).to eq expected_nix_content

      # Clean up the temporary files
      File.delete(lock_file)
      File.delete(Crystal2Nix::Worker::SHARDS_NIX)
    end

    it "handles multiple shards and creates correct shards.nix file" do
      lock_file = "test_lock_file.lock"
      File.write(lock_file, <<-YAML)
version: 1.0
shards:
  example_shard:
    git: https://github.com/example/example.git
    version: v1.0.0
  another_shard:
    git: https://github.com/another/example.git
    version: v2.0.0
YAML

      expected_nix_content = <<-NIX
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "example_shard";
  src = pkgs.fetchFromGitHub {
    owner = "example";
    repo = "example";
    rev = "v1.0.0";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
}

pkgs.stdenv.mkDerivation {
  name = "another_shard";
  src = pkgs.fetchFromGitHub {
    owner = "another";
    repo = "example";
    rev = "v2.0.0";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
}
NIX

      worker = Crystal2Nix::Worker.new(lock_file)
      worker.run

      actual_nix_content = File.read(Crystal2Nix::Worker::SHARDS_NIX)
      expect(actual_nix_content).to eq expected_nix_content

      # Clean up the temporary files
      File.delete(lock_file)
      File.delete(Crystal2Nix::Worker::SHARDS_NIX)
    end
  end
end
