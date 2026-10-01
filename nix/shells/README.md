# Shared development shells

Fiction installs the common development tools from `../development-tools.nix`.
That file also defines the toolchain arguments used by the system Neovim and
all project editors: Node 22, the shared Go tools, and LSP support. Python 3.12
with gyp, tiktoken, Tkinter, pip, and setuptools is installed globally.

On Darwin these shells assume Fiction's toolchain is installed. Rebuild Fiction
before reloading an existing shell after this migration. Linux shells include
the shared tools themselves because they do not inherit Fiction's configuration.

- `gel`: editor with `requires_docker` build tags and Compose debugger targets;
  GCC, network tools, and Snyk remain local to the shell.
- `loki`: editor with `integration` build tags and its Compose debugger targets;
  GCC, network tools, protobuf tooling, buf, crane, gotestsum, and Loki remain local.
- `default`: standard editor, matching the former slim `dev-env` shell.
  On Linux it also includes the shared development tools. The deployment/VM
  tools have been removed.

This repo has its own regular `.envrc` using `use flake .`, so it evaluates the
current checkout rather than the main clone. nix-direnv watches `flake.nix` and
`flake.lock`; after `make update`, the next shell prompt reloads the updated
flake. The shared tool definition and default shell definition are watched too.
On Fiction this evaluates the new editor/toolchain dependencies, but globally
installed CLIs still require a Fiction rebuild to update.

Go Jsonnet is the common Jsonnet implementation. Drone CLI is no longer included.
Node and Python are no longer explicitly installed through Homebrew; dependencies
may still bring their own runtimes. Yarn uses the same Node as the editors.

The redundant `dev-env`, `prometheus`, and `grafana` shell outputs have been
removed. Lefthook and wire are now part of the shared development tools.
Their envrc files remain as symlink targets containing only
`PATH_add ./node_modules/.bin`. These environments now rely on globally installed
tools; on Linux, use the remaining `default` shell or install the shared tools
in the host configuration.

Keep direnv and nix-direnv enabled for Loki/GEL and repositories with their own
flakes. Project variables remain in the Loki/GEL `.envrc` files.
The shells no longer set `NODE_PATH` to Node's bundled module directory.
