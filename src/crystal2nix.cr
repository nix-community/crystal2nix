require "json_mapping"
require "option_parser"
require "uri"
require "yaml_mapping"
require "version_from_shard"

require "./data"
require "./repo"
require "./worker"

module Crystal2Nix
  VersionFromShard.declare
end
