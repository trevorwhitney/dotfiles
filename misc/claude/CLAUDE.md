## Using Tools

- When using the `mcp__acp__Write` tool, write to a path within the current worktree to avoid sandboxing/permissions issues. This includes when writing plan files.

## Running Commands

- When running shell commands, you may need to `direnv allow` or `direnv reload` if the directoy has a `.envrc`, as I use nix to setup many environments.
