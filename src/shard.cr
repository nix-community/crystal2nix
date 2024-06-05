module Crystal2Nix
    class Shard
      getter url : String
      getter rev : String?
      getter type : Symbol
  
      def self.from_yaml(yaml : String)
        data = YAML.parse(yaml).as_h
        url = data["git"]? || data["http"]?
        rev = data["version"]?
        type = data.has_key?("git") ? :git : :http
        new(url, rev, type)
      end
  
      def initialize(@url : String, @rev : String? = nil, @type : Symbol = :git)
      end
    end
  end
  