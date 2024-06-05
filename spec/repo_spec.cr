require "./spec_helper"

Spectator.describe Crystal2Nix::Repo do
  context "commit" do
    let(:with_commit) {
      <<-EOF
      git: https://github.com/cadmiumcr/transliterator.git
      version: 0.1.0+git.commit.46c4c14594057dbcfaf27e7e7c8c164d3f0ce3f1
      EOF
    }

    let(:shard) {
      Crystal2Nix::Shard.from_yaml(with_commit)
    }

    let(:repo) {
      Crystal2Nix::Repo.new(shard.url, shard.rev, shard.type)
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

    let(:shard) {
      Crystal2Nix::Shard.from_yaml(with_version)
    }

    let(:repo) {
      Crystal2Nix::Repo.new(shard.url, shard.rev, shard.type)
    }

    it "should prefix version references with a v" do
      expect(repo.rev).to eq("v0.1.1")
    end
  end

  context "http url" do
    let(:with_http_url) {
      <<-EOF
      http: https://example.com/archive.tar.gz
      EOF
    }

    let(:shard) {
      Crystal2Nix::Shard.from_yaml(with_http_url)
    }

    let(:repo) {
      Crystal2Nix::Repo.new(shard.url, shard.rev, shard.type)
    }

    it "should have the correct url" do
      expect(repo.url).to eq("https://example.com/archive.tar.gz")
    end
  end

  context "git without revision" do
    let(:without_revision) {
      <<-EOF
      git: https://github.com/example/repo.git
      EOF
    }

    let(:shard) {
      Crystal2Nix::Shard.from_yaml(without_revision)
    }

    let(:repo) {
      Crystal2Nix::Repo.new(shard.url, shard.rev, shard.type)
    }

    it "should have the correct url" do
      expect(repo.url).to eq("https://github.com/example/repo.git")
    end
  end
end
