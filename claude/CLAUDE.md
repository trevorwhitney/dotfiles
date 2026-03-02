## Using Tools

- When using the `mcp__acp__Write` tool, write to a path within the current worktree to avoid sandboxing/permissions issues. This includes when writing plan files.

## Running Commands

- When running shell commands, you may need to `direnv allow` or `direnv reload` if the directoy has a `.envrc`, as I use nix and direnv to setup many environments.


## MCP Usage

- Prefer using CLIs and command-line tools where possible instead of using equivalent MCPs.
  - Use the `gh` command instad of the GitHub MCP, falling back to the GitHub MCP if necessary.
  - Use the `grafana-assistant` CLI instead of the Grafana MCP, falling back to the Grafana MCP if necessary.

## Edits and Commits

When using Claude in Zed via the ACP, uncommitted changes provide a visual interface to modify, accept, and reject individual hunks. Once committed, this granular control is lost.
If the ACP tools are detected, ask for confirmation before committing changes so this interface is not lost.
If uncertain about the context, default to asking first.

## Git Commits

If you have trouble making commits because of GPG signing, make sure the SSH_AUTH_SOCK environment variable is correctly pointing to the 1Password ssh agent, which is used for signing commits.

## Praise

Never use the phrase "You're absolutely right" or similar sycophantic praise. Treat me like a professional colleague.
