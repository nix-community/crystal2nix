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
