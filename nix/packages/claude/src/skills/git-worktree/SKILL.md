---
name: git-worktree
description: Manage git worktrees for parallel AI agent tasks with isolated working directories.
---

# Git Worktree - Parallel Agent Reference

## Why Worktrees for Agents

Git worktrees allow multiple working directories from a single repository. Each AI agent can work in isolation without:
- Branch checkout conflicts
- Stash collisions
- Uncommitted change interference

## Quick Reference

```bash
git worktree add -b twhitney/fix-auth ../fix-auth  # create with new branch
git worktree add ../fix-auth fix-auth              # create from existing branch
git worktree list                                  # show all worktrees
git worktree remove ../fix-auth                    # remove worktree
git worktree prune                                 # clean stale entries
```

## Agent Workflow

### 1. Create Worktree

```bash
# From main repo, create isolated worktree for agent task
git worktree add -b twhitney/new-api ../new-api

# Or use existing branch
git worktree add ../new-api twhitney/new-api
```

### 2. Work in Worktree

```bash
cd ../new-api
# Agent performs work here independently
# Other agents/worktrees unaffected
```

### 3. Cleanup

```bash
cd ~/workspace/myapp/main
git worktree remove ../new-api
git branch -d twhitney/new-api  # after PR merged
```

## Naming Convention

Use `{repo}-{feature-or-task}` pattern and place worktrees as siblings to main branch of the repo, within a parent folder named for the repo. The main folder should always be present, and is usually `main` or `master`:

```
~/workspace/
├── myapp/                # parent folder to hold all worktrees for repo "myapp"
├──── main/               # main branch of repo "myapp"
├──── myapp-fix-auth/     # feature worktree
└──── myapp-pr-review/    # task worktree
```

Branches should be named `twhitney/{feature-or-task}` so the feature `add-calendar` would for the repo `myapp` would track the branch `twhitney/add-calendar` and be located in the folder `~/workspace/myapp/add-calendar`.

## Best Practices

1. **One branch per worktree** - A branch can only be checked out in one worktree
2. **Clean up after merge** - Remove worktrees when PRs are merged
3. **Use descriptive names** - Include task/feature in worktree path
4. **Prune regularly** - Run `git worktree prune` to clean orphaned entries

## Troubleshooting

### Branch already checked out

```
fatal: 'feature-branch' is already checked out at '/path/to/worktree'
```

**Fix:** Use a different branch or remove the existing worktree first.

```bash
git worktree list                    # find which worktree has it
git worktree remove /path/to/worktree
```

### Worktree path exists but not registered

```
fatal: '/path/to/worktree' already exists
```

**Fix:** Prune stale entries or manually remove directory.

```bash
git worktree prune
rm -rf /path/to/worktree  # if directory is orphaned
```

### Cannot remove worktree with changes

```
fatal: cannot remove: '/path/to/worktree' contains modified or untracked files
```

**Fix:** Force remove or commit/discard changes first.

```bash
git worktree remove --force /path/to/worktree
```

## Useful Commands

```bash
# List with details
git worktree list --porcelain

# Move worktree to new location
git worktree move ../old-path ../new-path

# Lock worktree (prevents pruning)
git worktree lock ../myapp-fix-auth
git worktree unlock ../myapp-fix-auth

# Repair broken worktree paths
git worktree repair
```
