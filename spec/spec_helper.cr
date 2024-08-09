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
