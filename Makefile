BINARY=bin/crystal2nix

default: build

$(BINARY): build

.PHONY: build
build: clean
	@shards build

.PHONY: all-tests
all-tests: $(BINARY)
	@crystal spec spec/

.PHONY: check
check: $(BINARY)
	@crystal spec --tag ~online

.PHONY: test-offline
test-offline: $(BINARY)
	@crystal spec --tag offline

.PHONY: test-online
test-online: $(BINARY)
	@crystal spec --tag online

.PHONY: clean
clean:
	@rm -f $(BINARY)

.PHONY: run
run: $(BINARY)
	$(BINARY)
