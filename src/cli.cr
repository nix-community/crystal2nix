module Crystal2Nix
  class Cli
    def initialize
      @lock_file = "shard.lock"

      OptionParser.parse do |parser|
        parser.banner = "Usage: crystal2nix [arguments]"
        parser.on("-l NAME", "--lock-file=NAME", "Lock file name") do |name|
          @lock_file = name
        end
        parser.on("-h", "--help", "Show help") do
          puts parser
          exit
        end
        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          STDERR.puts parser
          exit(1)
        end

        unless File.exists? @lock_file
          STDERR.puts "ERROR: #{@lock_file} not found"
          exit 1
        end
      end
    end

    def run
      Worker.new(@lock_file).run
    end
  end
end
