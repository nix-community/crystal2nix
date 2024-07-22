require "./spec_helper"

Spectator.describe Crystal2Nix::Repo do
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

  context "without version" do
    let(:without_version) {
      <<-EOF
      git: https://github.com/crystal-lang/json_mapping.cr.git
      EOF
    }

    it "should raise an error when version is missing" do
      expect_raises(Exception) do
        Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(without_version))
      end
    end
  end

  context "invalid git url" do
    let(:invalid_git_url) {
      <<-EOF
      git: ftp://github.com/crystal-lang/json_mapping.cr.git
      version: 0.1.1
      EOF
    }

    it "should raise an error for invalid git URL" do
      expect_raises(Exception) do
        Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(invalid_git_url))
      end
    end
  end

  context "non-git url" do
    let(:non_git_url) {
      <<-EOF
      git: https://example.com/somefile.zip
      version: 0.1.1
      EOF
    }

    it "should raise an error for non-git URL" do
      expect_raises(Exception) do
        Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(non_git_url))
      end
    end
  end

  context "semver with pre-release" do
    let(:with_pre_release) {
      <<-EOF
      git: https://github.com/crystal-lang/crystal.git
      version: 1.0.0-beta1
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_pre_release))
    }

    it "should handle semver with pre-release correctly" do
      expect(repo.rev).to eq("v1.0.0-beta1")
    end
  end

  context "semver with build metadata" do
    let(:with_build_metadata) {
      <<-EOF
      git: https://github.com/crystal-lang/crystal.git
      version: 1.0.0+20130313144700
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_build_metadata))
    }

    it "should handle semver with build metadata correctly" do
      expect(repo.rev).to eq("v1.0.0+20130313144700")
    end
  end

  context "git commit in version" do
    let(:with_commit_version) {
      <<-EOF
      git: https://github.com/crystal-lang/crystal.git
      version: 1.0.0+git.commit.abcdef1234567890
      EOF
    }

    let(:repo) {
      Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(with_commit_version))
    }

    it "should handle git commit in version correctly" do
      expect(repo.rev).to eq("abcdef1234567890")
    end
  end

  context "malformed yaml" do
    let(:malformed_yaml) {
      <<-EOF
      git: https://github.com/crystal-lang/crystal.git
      version 1.0.0
      EOF
    }

    it "should raise an error for malformed YAML" do
      expect_raises(YAML::ParseException) do
        Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(malformed_yaml))
      end
    end
  end

  context "valid non-git URL" do
    let(:valid_non_git_url) {
      <<-EOF
      git: https://github.com/crystal-lang/json_mapping.cr.git
      EOF
    }

    it "should raise an error when version is missing" do
      expect_raises(Exception) do
        Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(valid_non_git_url))
      end
    end
  end

  context "empty shard" do
    let(:empty_shard) {
      <<-EOF
      git:
      version:
      EOF
    }

    it "should raise an error for empty shard fields" do
      expect_raises(Exception) do
        Crystal2Nix::Repo.new(Crystal2Nix::Shard.from_yaml(empty_shard))
      end
    end
  end
end
