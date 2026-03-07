# AGENTS.md

## Project Overview

NixOS/nix-darwin dotfiles repo managing system configuration across macOS (aarch64-darwin) and Linux (x86_64-linux). Uses Nix flakes, Home Manager, nix-darwin, and a legacy shell-based "units" system for non-Nix installs. Secrets are managed with agenix.

## Repository Structure

```
flake.nix              # Entry point: inputs, packages, hosts, shells, overlays
nix/
  hosts/               # Per-machine configs (e.g. fiction/ for macOS via nix-darwin)
  home-manager/        # Home Manager entry + per-host configs + reusable modules
  modules/             # NixOS-level modules
  packages/            # Custom Nix derivations (Go modules, shell apps, etc.)
  secrets/             # agenix .age files and declarations
  shells/              # devShell definitions (per-project Nix shells)
units/                 # Legacy non-Nix install scripts (bash/zsh)
envs/                  # direnv .envrc templates for specific projects
workmux/               # workmux task configurations
```

## Build / Check / Test Commands

No traditional build/test pipeline. Validation is through Nix evaluation.

```bash
nix flake check                                    # Primary validation
nix build .#darwinConfigurations.fiction.system     # Build macOS host
nix build .#<package-name>                         # Build a single package
nix develop .#<shell-name>                         # Enter a dev shell
darwin-rebuild switch --flake .#fiction             # Apply macOS config
home-manager switch --flake .#<config-name>        # Apply HM config
```

### Environment Setup

Uses direnv + nix-direnv. Run `direnv allow` or `direnv reload` after modifying `.envrc`.

### Unit System (Legacy)

```bash
./install <host>              # Full install for a host
./install-unit <unit-name>    # Install a single unit
./update-unit <unit-name>     # Update a single unit
./create-unit <name>          # Scaffold a new unit
```

## Nix Code Style

### Formatting

- **2-space indentation**, no tabs.
- No enforced formatter. Style is consistent with `nixpkgs-fmt`.
- Opening braces on the same line as context. Closing braces on their own line.
- One list item per line, indented 2 spaces under the opening bracket.
- `let` and `in` each on their own line; bindings indented 2 spaces under `let`.

### Function Arguments

Multi-line argument sets use **comma-leading** style (dominant pattern):

```nix
{ config
, pkgs
, lib
, ...
}:
```

Short argument lists go on one line: `{ lib, buildGoModule, fetchFromGitHub }:`

Note: `flake.nix` outputs and some host configs use trailing-comma style. Follow whichever style the file already uses.

### Naming Conventions

| What | Style | Example |
|------|-------|---------|
| Nix variables | camelCase | `goPkg`, `nodeJsPkg`, `golangciLintPkg` |
| Package suffix | `Pkg` | `delvePkg`, `goplsPkg` |
| Config bindings | `cfg` | `cfg = config.programs.git;` |
| Nix file names | kebab-case | `claude-code.nix`, `deployment-tools.nix` |
| `pname` values | kebab-case | `"golang-perf"`, `"change-background"` |
| Directory names | kebab-case | `oh-my-zsh-custom/`, `protoc-gen-gogoslick/` |

### Home Manager Module Pattern

Every HM module separates `options` and `config` into distinct attrset keys, with a `cfg` binding:
`let cfg = config.programs.<name>; in { options = { ... }; config = { ... }; }`

- Use `lib.mkIf`, `lib.mkMerge`, `lib.optionalString` for conditional config.
- Use `lib.mkEnableOption` and `lib.mkPackageOption` where appropriate.

### Package Derivation Patterns

- **Go modules** (most common): `buildGoModule rec { pname, version, src, vendorHash, meta }`
- **Shell applications**: `pkgs.writeShellApplication { name, runtimeInputs, text }`
- **Simple copies**: `runCommand "name" { src = ./src; } "cp -r $src $out"`

### Other Nix Conventions

- `inherit` for passing named attributes: `inherit pkgs goPkg;`
- `with pkgs;` in package lists: `packages = with pkgs; [ ... ];`
- String interpolation: `"${variable}"`. Multi-line strings: `'' ... ''`.
- Shell escaping in Nix strings: `''$` for literal `$`.
- Comments: `#` above the code they describe. Section headers inline (`# Golang`).
- Custom packages registered via `base.callPackage ./nix/packages/<name> { }`.
- Unstable packages selectively pulled: `inherit (unstablePackages) go gopls;`.

## Shell Script Style

### General

- Shebang: `#!/usr/bin/env bash` for bash, `#!/usr/bin/env zsh` for zsh scripts.
- `set -e` at the top of every script (exit on error).
- Variable names: **snake_case** (`current_dir`, `unit_name`, `deps_file`).
- Prefer **2-space indentation** (dominant). `lib.sh` historically uses 4 spaces.
- Command substitution: `$(command)` style, never backticks.

### Quoting and Variables

- Double-quote variables in bash scripts: `"${HOME}"`, `"$host_path"`.
- Use braces for clarity in interpolation: `"${version}"`, `"${ID}"`.
- Zsh unit scripts are less strict about quoting (legacy; prefer quoting in new code).

### Conditionals and Functions

- `[[ ... ]]` in bash scripts; `test ...` in zsh scripts.
- Guard pattern: `test -d $unit_dir || { msg "..."; exit 1; }`
- POSIX style in `lib.sh`: `create_link() { ... }`
- Keyword style in unit scripts: `function msg { ... }`

### Unit Structure

Each unit is a directory under `units/` with `deps`, `readme.md`, `install.sh`,
`verify-install.sh` (idempotency guard, returns 0 if installed), and optional `update.sh`.

## Error Handling

- Shell: `set -e` globally. `exit 1` for fatal errors. `pushd ... || exit 1` for cd.
- Nix: Use `lib.mkIf` guards, `assert` for preconditions. No try/catch equivalent.
- Unit guard pattern: `verify-install.sh` returns 0 to skip reinstallation.

## Agent Behavior Notes

- This repo uses **direnv + nix-direnv**. Run `direnv allow` or `direnv reload` after modifying `.envrc` or when entering a directory with one.
- Prefer CLI tools over MCP equivalents: use `gh` over GitHub MCP, `grafana-assistant` over Grafana MCP.
- GPG commit signing uses 1Password SSH agent. If signing fails, check `SSH_AUTH_SOCK`.
- No sycophantic praise. Treat the user as a professional colleague.
