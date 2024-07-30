BINARY=bin/crystal2nix

default: build

$(BINARY): build

.PHONY: build
build: clean
	@shards build

.PHONY: check
check: $(BINARY)
	@crystal spec spec/default_spec.cr

.PHONY: test
test: $(BINARY)
	@crystal spec spec/

.PHONY: clean
clean:
	@rm -f $(BINARY)

.PHONY: run
run: $(BINARY)
	$(BINARY)
