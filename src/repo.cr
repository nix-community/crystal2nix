module Crystal2Nix
  class Repo
    @url : URI
    getter rev : String
    getter type : Symbol

    def initialize(entry : Shard)
      git_url = entry.git.try(&.not_nil!)
      hg_url = entry.hg.try(&.not_nil!)

      if git_url
        @url = URI.parse(git_url)
        @type = :git
      elsif hg_url
        @url = URI.parse(hg_url)
        @type = :hg
      else
        raise "Unknown repository type"
      end

      @rev = if entry.version =~ /(?<version>.+)\+(git|hg)\.commit\.(?<rev>.+)/
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
