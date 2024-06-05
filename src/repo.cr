module Crystal2Nix
  class Repo
    property url : String
    property rev : String?
    property type : Symbol

    def initialize(url : String, rev : String? = nil, type : Symbol = :git)
      @url = url
      @rev = rev
      @type = type
    end
  end
end
