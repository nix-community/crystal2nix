# Makefile for Crystal2Nix project

# Variables
CRYSTAL_BIN = crystal
SPEC = spec
SPEC_FILES = $(wildcard $(SPEC)/*.cr)
SHARD_LOCK = test_lock_file.lock
EMPTY_LOCK = empty_lock_file.lock
SHARDS_NIX = src/crystal2nix/shards.nix

# Targets
.PHONY: test offline-test online-test clean

test: offline-test online-test

offline-test: $(SPEC_FILES) $(SHARD_LOCK) $(EMPTY_LOCK)
	$(CRYSTAL_BIN) spec --offline

online-test: $(SPEC_FILES) $(SHARD_LOCK)
	$(CRYSTAL_BIN) spec

clean:
	rm -f $(SHARD_LOCK)
	rm -f $(EMPTY_LOCK)
	rm -f $(SHARDS_NIX)
