# Define variables
CRYSTAL=crystal
SPEC=$(CRYSTAL) spec

default: build

.PHONY: build
build:
    @shards build

# Default target
.PHONY: check
check: build
    ./bin/crystal2nix

# Clean target
.PHONY: clean
clean:
    @echo "Cleaning up..."
    rm -f shard.lock shards.nix

# You can add more targets as needed
