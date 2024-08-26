require "./spec_helper"

Spectator.describe Crystal2Nix::Worker, :online do
  it "correctly generates the shards.nix file" do
    test_shard_lock = "./spec/fixtures/test_shard.lock"
    reference_shards_nix = "./spec/fixtures/reference_shards.nix"
    generated_shards_nix = "./shards.nix"
    SpecHelper.setup_temp_directory("spec/tmp")
    SpecHelper.cleanup_file(generated_shards_nix)

    begin
      Crystal2Nix::Worker.new(test_shard_lock).run

      if !SpecHelper.file_exists?(generated_shards_nix)
        SpecHelper.write_file(generated_shards_nix, "Generated content")
        puts "Dummy file created at #{generated_shards_nix}"
      end

      generated_content = SpecHelper.read_file(generated_shards_nix)
      reference_content = SpecHelper.read_file(reference_shards_nix)

      puts "Generated content:\n#{generated_content}"
      puts "Reference content:\n#{reference_content}"

      expect(generated_content.strip).to eq(reference_content.strip)
    ensure
      SpecHelper.cleanup_file(generated_shards_nix)
    end
  end
end
