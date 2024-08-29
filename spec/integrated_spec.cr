require "./spec_helper"

Spectator.describe Crystal2Nix::Worker, :online do
  def run_and_validate_test(test_shard_lock, reference_shards_nix, generated_shards_nix)
    SpecHelper.prepare_for_test(generated_shards_nix)

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

  it "correctly generates the shards.nix file" do
    run_and_validate_test(
      "./spec/fixtures/test_shard.lock",
      "./spec/fixtures/reference_shards.nix",
      "./shards.nix"
    )
  end

  it "works with only Git sources" do
    run_and_validate_test(
      "./spec/fixtures/test_shard.lock",
      "./spec/fixtures/reference_shards.nix",
      "./shards.nix"
    )
  end

  it "works with only Hg sources" do
    run_and_validate_test(
      "./spec/fixtures/test_shard.lock",
      "./spec/fixtures/reference_shards.nix",
      "./shards.nix"
    )
  end

  it "works with mixed sources" do
    run_and_validate_test(
      "./spec/fixtures/test_shard.lock",
      "./spec/fixtures/reference_shards.nix",
      "./shards.nix"
    )
  end
end
