module Crystal2Nix
  class PrefetchJSON
    JSON.mapping(sha256: String)
  end

  class ShardLock
    YAML.mapping(
      version: Float32,
      shards: Hash(String, Hash(String, String))
    )
  end
end
