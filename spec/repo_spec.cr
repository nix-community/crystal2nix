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
end
