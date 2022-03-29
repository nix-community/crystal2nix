module Crystal2Nix
  class RepoUrl
    @url : URI
    @path : Array(String)

    def initialize(kind : String, repo : String)
      t = case kind
          when "git"
            repo
          when "github"
            "https://github.com/#{repo}"
          else
            ArgumentError.new "Unknown key: #{kind}"
            exit 1
          end
      @url = URI.parse(t).normalize
      @path = @url.path.split("/")
    end

    def github?
      @url.host == "github.com"
    end

    def owner : String
      @path[1]
    end

    def repo : String
      github? ? @path[2].gsub(/\.git$/, "") : @path[2]
    end

    def to_s : String
      @url.to_s
    end
  end
end
