# Define variables
CRYSTAL=crystal
SPEC=$(CRYSTAL) spec

default: check

.PHONY: build
build: @shards build

# Default target
.PHONY: check
check: offline-check online-check

# Offline tests
.PHONY: offline-check
offline-check:
	@echo "Running offline tests..."
	NO_NETWORK=true $(SPEC)

# Online tests
.PHONY: online-check
online-check:
	@echo "Running online tests..."
	$(SPEC)

# Clean target
.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -f shard.lock shards.nix

# You can add more targets as needed
