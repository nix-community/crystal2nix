require "../src/crystal2nix"
require "spectator"

# Helper method to create a temporary file
def create_tempfile(content : String) : String
  temp_filename = "./temp_shard.lock"
  File.write(temp_filename, content)
  temp_filename
end

# Helper method to delete a temporary file
def delete_tempfile(filename : String)
  File.delete(filename) if File.exists?(filename)
end

describe Crystal2Nix::Worker do
  before_each do
    @tempfile = create_tempfile(%(
      dependencies:
        hello:
          hg: https://www.mercurial-scm.org/repo/hello
          version: 0.8
    ))
  end

  after_each do
    delete_tempfile(@tempfile)
  end

  it "fetches the correct sha256 for an hg repository" do
    # Stub the Process.run method to return a mocked output
    Process.stub(:run) do |cmd, *args|
      # Mock the process output as if nix-prefetch-hg ran successfully
      process_output = "mocked_sha256"
      output_io = IO::Memory.new(process_output)

      Process.new(Process::Status.new("", "", 0), output_io, output_io)
    end

    # Test the actual method
    worker = Crystal2Nix::Worker.new(@tempfile)
    worker.run

    # Check the resulting shards.nix file content
    shard_nix_content = File.read(Crystal2Nix::SHARDS_NIX)
    shard_nix_content.should include("sha256 = \"mocked_sha256\";")
  end
end
