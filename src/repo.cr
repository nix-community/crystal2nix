module Crystal2Nix
  class Repo
    @url : URI
    getter rev : String
    getter type : Symbol

    def initialize(entry : Shard)
      if entry.git.not_nil!
        @url = URI.parse(entry.git.not_nil!)
        @type = :git
      elsif entry.hg.not_nil!
        @url = URI.parse(entry.hg.not_nil!)
        @type = :hg
      else
        raise "Unknown repository type"
      end

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
