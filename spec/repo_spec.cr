require "spec"
require "../src/crystal2nix"

describe Crystal2Nix::Repo do
  it "creates a new repo with a URL and default values" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.git")
    repo.url.should eq("https://example.com/repo.git")
    repo.rev.should be_nil
    repo.type.should eq(:git)
  end

  it "creates a new repo with a URL, rev, and type" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.git", "master", :git)
    repo.url.should eq("https://example.com/repo.git")
    repo.rev.should eq("master")
    repo.type.should eq(:git)
  end

  it "creates a new repo with a URL and rev only" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.git", "develop")
    repo.url.should eq("https://example.com/repo.git")
    repo.rev.should eq("develop")
    repo.type.should eq(:git)  # Default type is :git
  end

  it "creates a new repo with a URL and type only" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.git", nil, :svn)
    repo.url.should eq("https://example.com/repo.git")
    repo.rev.should be_nil
    repo.type.should eq(:svn)
  end
  it "stores the provided URL correctly" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.git")
    repo.url.should eq("https://example.com/repo.git")
  end
  it "initializes with a Git URL and sets the type to Git" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.git")
    repo.url.should eq("https://example.com/repo.git")
    repo.type.should eq(:git)
  end
  it "initializes with a Git URL and sets the type to Git" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.git")
    repo.url.should eq("https://example.com/repo.git")
    repo.type.should eq(:git)
  end

  it "initializes with a Fossil URL and sets the type to Fossil" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.fossil", nil, :fossil)
    repo.url.should eq("https://example.com/repo.fossil")
    repo.rev.should be_nil
    repo.type.should eq(:fossil)
  end
  it "initializes with a Mercurial URL and sets the type to hg" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.hg", nil, :hg)
    repo.url.should eq("https://example.com/repo.hg")
    repo.rev.should be_nil
    repo.type.should eq(:hg)
  end
  it "initializes with a URL, revision, and type for Mercurial" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.hg", "default", :hg)
    repo.url.should eq("https://example.com/repo.hg")
    repo.rev.should eq("default")
    repo.type.should eq(:hg)
  end
  it "initializes with a URL and revision only, default type should be git" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.hg", "default")
    repo.url.should eq("https://example.com/repo.hg")
    repo.rev.should eq("default")
    repo.type.should eq(:git)  # Default type is :git
  end
  it "initializes with a URL only, default type should be git" do
    repo = Crystal2Nix::Repo.new("https://example.com/repo.hg")
    repo.url.should eq("https://example.com/repo.hg")
    repo.rev.should be_nil
    repo.type.should eq(:git)  # Default type is :git
  end

end
