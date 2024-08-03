require "spec"

describe "Temporary Directory Handling" do
  it "creates a temporary directory and file, and verifies their existence" do
    # Create a temporary directory
    tempdir = File.tempname("tempdir")
    Dir.mkdir(tempdir)

    # Verify that the directory was created
    File.exists?(tempdir).should be_true

    # Create a temporary file inside the directory
    temp_file = "#{tempdir}/tempfile.txt"
    File.write(temp_file, "Test content")

    # Verify that the file was created
    File.exists?(temp_file).should be_true

    # Verify file content
    content = File.read(temp_file)
    content.should eq("Test content")



    # Verify that the file was deleted
    File.exists?(temp_file).should be_true
  end
end
