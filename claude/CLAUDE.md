## Using Tools

- When using the `mcp__acp__Write` tool, write to a path within the current worktree to avoid sandboxing/permissions issues. This includes when writing plan files.

## Running Commands

- When running shell commands, you may need to `direnv allow` or `direnv reload` if the directoy has a `.envrc`, as I use nix and direnv to setup many environments.


## MCP Usage

- Prefer using CLIs and command-line tools where possible instead of using equivalent MCPs.
  - Use the `gh` command instad of the GitHub MCP, falling back to the GitHub MCP if necessary.
  - Use the `grafana-assistant` CLI instead of the Grafana MCP, falling back to the Grafana MCP if necessary.
