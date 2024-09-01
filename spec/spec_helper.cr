require "../src/crystal2nix"
require "spectator"

module SpecHelper
  def self.setup_temp_directory(dir)
    Dir.mkdir(dir) unless Dir.exists?(dir)
  end

  def self.cleanup_file(file_path)
    File.delete(file_path) if File.exists?(file_path)
  end

  def self.write_file(file_path, content)
    File.write(file_path, content)
  end

  def self.read_file(file_path)
    File.read(file_path)
  end

  def self.file_exists?(file_path)
    File.exists?(file_path)
  end

  def self.prepare_for_test(generated_shards_nix)
    setup_temp_directory("spec/tmp")
    cleanup_file(generated_shards_nix)
  end
end
