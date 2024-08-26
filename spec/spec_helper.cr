require "../src/crystal2nix"
require "spectator"

module SpecHelper
  # Ensures the temporary directory exists
  def self.setup_temp_directory(dir : String)
    Dir.mkdir(dir) unless Dir.exists?(dir)
  end

  # Removes a file if it exists
  def self.cleanup_file(file_path : String)
    File.delete(file_path) if File.exists?(file_path)
  end

  # Writes content to a file
  def self.write_file(file_path : String, content : String)
    File.write(file_path, content)
  end

  # Reads content from a file
  def self.read_file(file_path : String) : String
    File.read(file_path)
  end

  # Checks if a file exists
  def self.file_exists?(file_path : String) : Bool
    File.exists?(file_path)
  end
end
