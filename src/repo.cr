module Crystal2Nix
  class Repo
    @url : URI
    getter rev : String
    getter type : Symbol

    def initialize(entry : Shard)
      git_url = entry.git.try(&.not_nil!) # Safely access entry.git
      hg_url = entry.hg.try(&.not_nil!)   # Safely access entry.hg
      fossil_url = entry.fossil.try(&.not_nil!) # Safely access entry.fossil


      if git_url
        @url = URI.parse(git_url)
        @type = :git
      elsif hg_url
        @url = URI.parse(hg_url)
        @type = :hg
      elsif fossil_url
        @url = URI.parse(fossil_url)
        @type = :fossil
      else
        raise "Unknown repository type"
      end

      @rev = if entry.version =~ /(?<version>.+)\+(git|hg|fossil)\.commit\.(?<rev>.+)/
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
