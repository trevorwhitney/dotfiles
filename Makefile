# Parse flake inputs dynamically from the lock file so this target never goes stale.
FLAKE_INPUTS := $(shell nix flake metadata --json 2>/dev/null | jq -r '.locks.nodes.root.inputs | keys[]')

.PHONY: update
update:
	@echo "Updating flake inputs one at a time..."
	@for input in $(FLAKE_INPUTS); do \
		echo "=> nix flake update $$input"; \
		nix flake update $$input || echo "WARNING: failed to update $$input"; \
	done
	@echo "Done."
