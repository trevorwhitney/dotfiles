# Parse flake inputs dynamically from the lock file so this target never goes stale.
FLAKE_INPUTS := $(shell nix flake metadata --json 2>/dev/null | jq -r '.locks.nodes.root.inputs | keys[]')

# Discovered from the package definitions so this list never goes stale.
GO_PKGS := $(patsubst nix/packages/%/default.nix,%,$(shell grep -l 'vendorHash = "sha256-' nix/packages/*/default.nix))

.PHONY: update
update: update-inputs
	@$(MAKE) --no-print-directory vendor-hashes

.PHONY: update-inputs
update-inputs:
	@echo "Updating flake inputs one at a time..."
	@for input in $(FLAKE_INPUTS); do \
		echo "=> nix flake update $$input"; \
		nix flake update $$input || echo "WARNING: failed to update $$input"; \
	done

# A package whose src tracks a flake input gets new Go dependencies whenever that
# input moves, which invalidates the vendorHash pinned in its definition.
.PHONY: vendor-hashes
vendor-hashes:
	@echo "Checking Go vendor hashes..."
	@for pkg in $(GO_PKGS); do \
		out=$$(nix build ".#$$pkg.goModules" --no-link 2>&1) && continue; \
		got=$$(printf '%s\n' "$$out" | sed -n 's,^[[:space:]]*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*,\1,p' | tail -1); \
		if [ -z "$$got" ]; then \
			echo "ERROR: $$pkg failed to build:" >&2; \
			printf '%s\n' "$$out" >&2; \
			exit 1; \
		fi; \
		echo "=> $$pkg vendorHash -> $$got"; \
		f=nix/packages/$$pkg/default.nix; tmp=$$(mktemp); \
		sed "s|vendorHash = \".*\"|vendorHash = \"$$got\"|" "$$f" > "$$tmp" && mv "$$tmp" "$$f"; \
	done
	@echo "Done."
