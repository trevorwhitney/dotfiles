---
name: fix-correctness-bug
description: Fix a Loki correctness bug using TDD (GREEN phase)
---

# Fix Correctness Bug Command

This command invokes the `fix-correctness-bug` skill to implement the code fix that makes a failing test pass.

## Usage

```
/fix-correctness-bug <test-file-path> <test-name>
```

Or with just test name:
```
/fix-correctness-bug TestRegexFilterWithPipeOperator
```

## What it does

Reads the skill instructions from `skills/fix-correctness-bug/SKILL.md` and executes them to:
1. Analyze the failing test
2. Locate the bug in implementation code
3. Implement minimal fix
4. Verify test passes
5. Check for regressions

## Instructions

Load and execute the fix-correctness-bug skill with the provided arguments.
