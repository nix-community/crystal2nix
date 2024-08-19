require "process"

# Ensure correct usage
if ARGV.size != 2
  puts "Usage: crystal run test_hg.cr <url> <revision>"
  exit(1)
end

url = ARGV[0]
revision = ARGV[1]

# Construct the nix-prefetch-hg command
command = "nix-prefetch-hg"
args = ["--no-deepClone", "--url", url, "--rev", revision]

begin
  # Run the command and capture the output
  Process.run(command, args: args, output: :pipe, error: :pipe) do |process|
    puts process.output.gets_to_end
  end
rescue ex
  puts "An error occurred: #{ex.message}"
  exit(1)
end
