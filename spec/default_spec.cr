require "spec"

describe "ShardsNix File" do
  it "should not be empty" do
    file_path = "shards.nix"

    # Check if the file exists
    File.exists?(file_path).should be_true

    # Read the file content
    file_content = File.read(file_path).strip

    # Ensure the file is not empty
    file_content.empty?.should be_false
  end
end
