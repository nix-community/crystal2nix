require "./spec_helper"

Spectator.describe Crystal2Nix::Repo do
  context "commit" do
    let(:with_commit) {
      <<-EOF
      hg:  https://selenic.com/repo/hello
      version: 0.1.0+hg.commit.a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_commit))
    }

    it "should have the commit as revision", :offline do
      expect(repo.rev).to eq("a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0")
    end
  end

  context "explicit version" do
    let(:with_version) {
      <<-EOF
      hg:  https://selenic.com/repo/hello
      version: 2.0.0
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_version))
    }

    it "should prefix version references with a v", :offline do
      expect(repo.rev).to eq("v2.0.0")
    end
  end

  context "semver with pre-release" do
    let(:with_pre_release) {
      <<-EOF
      hg:  https://selenic.com/repo/hello
      version: 1.2.3-beta.1
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_pre_release))
    }

    it "should handle semver with pre-release correctly", :offline do
      expect(repo.rev).to eq("v1.2.3-beta.1")
    end
  end

  context "semver with build metadata" do
    let(:with_build_metadata) {
      <<-EOF
      hg:  https://selenic.com/repo/hello
      version: 1.0.0+build.12345
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_build_metadata))
    }

    it "should handle semver with build metadata correctly", :offline do
      expect(repo.rev).to eq("v1.0.0+build.12345")
    end
  end

  context "hg commit in version" do
    let(:with_commit_version) {
      <<-EOF
      hg:  https://selenic.com/repo/hello
      version: 1.0.0+hg.commit.abcdef1234567890abcdef1234567890abcdef12
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_commit_version))
    }

    it "should handle hg commit in version correctly", :offline do
      expect(repo.rev).to eq("abcdef1234567890abcdef1234567890abcdef12")
    end
  end

  context "malformed yaml" do
    let(:malformed_yaml) {
      <<-EOF
      hg:  https://selenic.com/repo/hello
      version 1.0.0
      EOF
    }

    it "should raise an error for malformed YAML", :offline do
      expect_raises(YAML::ParseException) do
        Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(malformed_yaml))
      end
    end
  end
end
