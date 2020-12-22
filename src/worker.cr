module Crystal2Nix
  SHARDS_NIX = "shards.nix"

  class Worker
    def initialize(@lock_file : String)
      @errors = [] of String
    end

    def log_message(msg)
      STDERR.puts msg
      @errors << msg
    end

    def run
      temp_file_path = File.tempfile("shards").path

      File.open temp_file_path, "w+" do |file|
        file.puts %({)
        ShardLock.from_yaml(File.read(@lock_file)).shards.each do |key, value|
          begin
            repo = Repo.new value
          rescue ex : Exception
            log_message "Error processing repository '#{key}': #{ex.message}. Please check the repository details and try again."
            next
          end

          sha256 = ""

          case repo.type
          when :git
            args = [
              "--url", repo.url,
              "--rev", repo.rev,
            ]
            begin
              Process.run("nix-prefetch-git", args: args) do |process|
                process.error.each_line { |e| STDERR.puts e }
                json_output = process.output.gets_to_end
                sha256 = GitPrefetchJSON.from_json(json_output).sha256
              end
            rescue ex : Exception
              log_message "Error running nix-prefetch-git for '#{key}': #{ex.message}.
                Try running the command manually to troubleshoot:
                nix-prefetch-git #{args.join " "}
                Ensure that the git repository is accessible and try again."
              next
            end

          when :hg
            args = [
              repo.url,
              repo.rev,
            ]
            begin
              Process.run("nix-prefetch-hg", args: args) do |process|
                process.error.each_line { |e| STDERR.puts e }
                output = process.output.gets_to_end
                sha256 = output.strip.split("\n").first
              end
            rescue ex : Exception
              log_message "Error running nix-prefetch-hg for '#{key}': #{ex.message}.
                      Try running the command manually to troubleshoot:
                      nix-prefetch-hg #{args.join " "}
                      Ensure that the Mercurial repository is accessible and try again."
              next
            end

          else
            log_message "Unsupported repository type for '#{key}': #{repo.type}. Currently supported types are: git, hg."
            break
          end

          file.puts %(  #{key} = {)
          file.puts %(    url = "#{repo.url}";)
          file.puts %(    rev = "#{repo.rev}";)
          file.puts %(    sha256 = "#{sha256}";)
          file.puts %(  };)
        end
        file.puts %(})
      end

      if @errors.any?
        File.delete(temp_file_path)
        STDERR.puts "\nSummary of errors encountered:"
        @errors.each { |error| STDERR.puts "  - #{error}" }
        STDERR.puts "\nProcess not completed due to the above errors. Please review and resolve them before re-running."
        exit 1
      end

      File.rename(temp_file_path, SHARDS_NIX)
      puts "Processing completed successfully."
    end
  end
end
