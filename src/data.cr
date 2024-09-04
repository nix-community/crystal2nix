module Crystal2Nix
  class GitPrefetchJSON
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

    property git : String?
    property hg : String?
    property version : String
  end
end
