require "./spec_helper"

Spectator.describe Repo do
  context "commit" do
    let(:with_commit) {
      <<-EOF
      git: https://github.com/cadmiumcr/transliterator.git
      version: 0.1.0+git.commit.46c4c14594057dbcfaf27e7e7c8c164d3f0ce3f1
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_commit))
    }

    it "should have the commit as revision" do
      expect(repo.rev).to eq("46c4c14594057dbcfaf27e7e7c8c164d3f0ce3f1")
    end
  end

  context "explicit version" do
    let(:with_version) {
      <<-EOF
      git: https://github.com/crystal-lang/json_mapping.cr.git
      version: 0.1.1
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_version))
    }

    it "should prefix version references with a v" do
      expect(repo.rev).to eq("v0.1.1")
    end
  end

  context "no version or commit" do
    let(:no_version_or_commit) {
      <<-EOF
      git: https://github.com/example/repo.git
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(no_version_or_commit))
    }

    it "should have nil as revision" do
      expect(repo.rev).to be_nil
    end
  end

  context "with tag" do
    let(:with_tag) {
      <<-EOF
      git: https://github.com/example/repo.git
      version: refs/tags/v1.0.0
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_tag))
    }

    it "should have the tag as revision" do
      expect(repo.rev).to eq("refs/tags/v1.0.0")
    end
  end

  context "only URL" do
    let(:only_url) {
      <<-EOF
      git: https://github.com/example/repo.git
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(only_url))
    }

    it "should have nil as revision" do
      expect(repo.rev).to be_nil
    end
  end

  context "different commit" do
    let(:different_commit) {
      <<-EOF
      git: https://github.com/example/repo.git
      version: 0.1.0+git.commit.1234567890abcdef1234567890abcdef12345678
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(different_commit))
    }

    it "should have the correct commit as revision" do
      expect(repo.rev).to eq("1234567890abcdef1234567890abcdef12345678")
    end
  end

  context "version with prefix" do
    let(:version_with_prefix) {
      <<-EOF
      git: https://github.com/example/repo.git
      version: v2.0.0
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(version_with_prefix))
    }

    it "should have the version as revision with the same prefix" do
      expect(repo.rev).to eq("v2.0.0")
    end
  end
end
