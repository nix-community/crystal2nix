BINARY=bin/crystal2nix

default: build

$(BINARY): build

.PHONY: build
build: clean
	@shards build

.PHONY: check
check: $(BINARY)
	@crystal spec

.PHONY: clean
clean:
	@rm -f $(BINARY)

.PHONY: run
run: $(BINARY)
	$(BINARY)
