---
name: test-correctness-hypothesis
description: Write a failing unit test for a Loki correctness hypothesis (RED phase)
---

# Test Hypothesis Command

This command invokes the `test-hypothesis` skill to create a failing unit test that further proves a correctness bug exists.

## Usage

```
/test-correctness-hypothesis <hypothesis-file>
```

Example:
```
/test-correctness-hypothesis pkg/logql/bench/mismatch_bfebdb3f_test.go
```

## What it does

Reads the skill instructions from `skills/test-correctness-hypothesis/SKILL.md` and executes them to:
1. Analyze failing test against generated data to understand the hypothesis being tested
2. Create a focused unit test
3. Verify the test fails correctly
4. Produce documentation about the bug that can be used by the `/fix-correctness-bug` command.

## Instructions

Load and execute the test-hypothesis skill with the provided hypothesis file path.
