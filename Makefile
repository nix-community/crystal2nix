# Define variables
CRYSTAL=crystal
SPEC=crystal spec

# Default target
.PHONY: test
test: offline-test online-test

# Offline tests
.PHONY: offline-test
offline-test:
	@echo "Running offline tests..."
	# Here we can set an environment variable to simulate offline mode
	NO_NETWORK=true $(SPEC)

# Online tests
.PHONY: online-test
online-test:
	@echo "Running online tests..."
	$(SPEC)

# Clean target (if necessary)
.PHONY: clean
clean:
	@echo "Cleaning up..."
	# Add any clean up commands here

# You can add more targets as needed
