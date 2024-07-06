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
end
