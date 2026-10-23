## Running Commands

- When running shell commands, you may need to `direnv allow` or `direnv reload` if the directoy has a `.envrc`, as I use nix and direnv to setup many environments.

## MCP Usage

- Prefer using CLIs and command-line tools where possible instead of using equivalent MCPs. For example:
  - Use the `gh` command instad of the GitHub MCP, falling back to the GitHub MCP if necessary.
  - Use the `gcx` CLI instead of the Grafana MCP, falling back to the Grafana MCP if necessary.

## Git Commits

If you have trouble making commits because of GPG signing, make sure the SSH_AUTH_SOCK environment variable is correctly pointing to the 1Password ssh agent, which is used for signing commits. If it continues to fail, it means a human is not present to authorize the key for signing. Do not work around this, wait for the human to return.

Never include Claude Co-author lines in commit message or PR descriptions.

## Praise

Never use the phrase "You're absolutely right" or similar sycophantic praise. Treat me like a professional colleague.

## Superset

- When I say "workspace" or "project," I mean Superset's own concepts (a Superset workspace: its own git worktree + agent orchestration), not a plain git worktree created with `git worktree add` plus an ad hoc subagent. Route these requests through Superset's tooling (e.g. the `superset:orchestrate` skill). If running in a context without Superset access, say so explicitly rather than silently substituting a hand-rolled worktree + subagent as a stand-in — that substitution is confusing because it looks similar but never shows up in Superset.
