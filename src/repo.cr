module Crystal2Nix
  class Repo
    @url : URI
    getter rev : String

    def initialize(entry : Shard)
      @url = URI.parse(entry.git).normalize
      @rev = if entry.version =~ /^(?<version>.+)\+git\.commit\.(?<rev>.+)$/
               $~["rev"]
             else
               "v#{entry.version}"
             end
    end

    def url : String
      @url.to_s
    end
  end
end