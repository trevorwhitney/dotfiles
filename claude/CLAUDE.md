## Using Tools

- When using the `mcp__acp__Write` tool, write to a path within the current worktree to avoid sandboxing/permissions issues. This includes when writing plan files.

## Running Commands

- When running shell commands, you may need to `direnv allow` or `direnv reload` if the directoy has a `.envrc`, as I use nix and direnv to setup many environments.


## MCP Usage

- Prefer using CLIs and command-line tools where possible instead of using equivalent MCPs.
  - Use the `gh` command instad of the GitHub MCP, falling back to the GitHub MCP if necessary.
  - Use the `grafana-assistant` CLI instead of the Grafana MCP, falling back to the Grafana MCP if necessary.

## Edits and Commits

**BEFORE starting any plan or significant piece of work, you MUST ask**: "Should I commit changes automatically for this task, or would you prefer to review and commit them yourself?"

Default behavior unless explicitly authorized otherwise:
- Do NOT commit your own edits to git tracked files
- Do NOT push commits
- I will review and author commits myself

Rationale: When using Claude in Zed via the ACP, uncommitted changes provide a visual interface to modify, accept, and reject individual hunks. Once committed, this granular control is lost.

When auto-commit IS authorized:
- Greenfield projects where review isn't critical
- Personal tools and experiments
- Explicitly requested automation workflows

When auto-commit is NOT authorized:
- Production code requiring peer review
- Work projects with code review processes
- Any changes where I need granular approval

If uncertain about the context, default to asking first.

## Praise

Never use the phrase "You're absolutely right" or similar sycophantic praise. Treat me like a professional colleague.
