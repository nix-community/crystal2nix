BINARY=bin/crystal2nix

default: build

$(BINARY): build

.PHONY: build
build: clean
	@shards build

.PHONY: check
check: $(BINARY)
	@crystal spec spec/repo_spec.cr
	@crystal spec spec/repo_mercurial_spec.cr

.PHONY: all-tests
all-tests: $(BINARY)
	@crystal spec spec/

.PHONY: clean
clean:
	@rm -f $(BINARY)

.PHONY: run
run: $(BINARY)
	$(BINARY)
