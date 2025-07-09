BINARY = bin/crystal2nix

default: build

$(BINARY): build

.PHONY: build
build: version.json
	@shards build

.PHONY: nix
nix: build
	@nix build .#crystal2nix

.PHONY: check
check: $(BINARY)
	@crystal spec

.PHONY: clean
clean:
	@rm -f $(BINARY)

.PHONY: run
run: $(BINARY)
	$(BINARY)

version.json: shard.yml
	@echo "{ \"version\": \"$$(shards version)\" }" > $@

shard.lock: shard.yml
	@shards install

shards.nix: shard.lock
	@$(BINARY)
