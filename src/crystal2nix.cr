# This module defines the Crystal2Nix project, which converts Crystal project dependencies 
# into Nix expressions for use with the Nix package manager. The project leverages various 
# dependencies such as JSON, YAML, URI parsing, and a custom version management module. 
# The main functionality is organized into separate components like data handling, 
# repository management, and worker processes.
require "json"
require "yaml"
require "option_parser"
require "uri"
require "version_from_shard"

require "./data"
require "./repo"
require "./worker"

module Crystal2Nix
  VersionFromShard.declare
end
