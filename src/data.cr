module Crystal2Nix
  class PrefetchJSON
    include JSON::Serializable

    property sha256 : String
  end

  class ShardLock
    include YAML::Serializable

    property version : Float32
    property shards : Hash(String, Shard)
  end

  class Shard
    include YAML::Serializable

    property git : String
    property version : String
  end
end
