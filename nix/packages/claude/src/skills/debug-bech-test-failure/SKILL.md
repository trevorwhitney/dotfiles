---
name: debug-bench-test-failure
description: Figure out exactly why a LogQL Correctness Test in Loki is failing.
---

# Bench Test Debugger

Use this skill when debugging failures in `pkg/logql/bench/bench_test.go` (the `TestStorageEquality` test that compares chunk store vs dataobj-engine results). This skill should be invoked with a URL to a failing CI job or a reference to downloaded logs from a failure.

## Tools to Use

Throughout this workflow, use these Claude Code tools:

- **WebFetch**: Fetch CI job logs from GitHub Actions URLs
- **GitHub MCP**: Interact with GitHub (get PR details, read file contents, list commits, etc.)
  - Note: If an operation cannot be compljeted with the GitHub MCP, try the `gh` CLI via **Bash** instead
- **Grep/Glob**: Search for test files and related code
- **Read**: Read test files, implementation code, and logs
- **Bash**: Run tests, add debug logging, compile code, use `gh` CLI when needed
- **Write**: Create PROBLEM_SUMMARY.md and test files
- **Edit**: Modify existing code to add debug logging or tests

## Prerequisites

Before starting, ensure the environment is ready:

```bash
# If directory has .envrc, allow it (for nix-based environments)
direnv allow
# Or reload if already allowed
direnv reload
```

## Common Investigation Areas

When comparing dataobj-engine vs chunks, focus on these code paths:

- **Query planning**: `pkg/logql/engine/` - how queries are analyzed and planned for the databobj engine
- **Pipeline construction**: `pkg/logql/log/` - how log processing pipelines are built for the chunks engine
- **Schema handling**: `pkg/dataobj/schema/` - how dataobj-engine manages schemas
- **Iterator differences**: `pkg/dataobj/iter/` vs `pkg/storage/chunk/` - how data is iterated
- **Expression evaluation**: `pkg/logql/` - how the LogQL query is parsed, used by both engines

## Workflow

### Phase 1: Identify the Exact Failure

**Goal**: Create a clear, detailed problem statement documenting exactly what is failing.

**Steps**:

1. **If provided a CI URL**:
   - Use **WebFetch**, **GitHub MCP**, or `gh` via **Bash** to retrieve the job logs from the URL
   - Extract the failing test name(s)
   - Identify error messages and diff output
   - Copy relevant log snippets into PROBLEM_SUMMARY.md

2. **Identify the failing test case**:
   - Which test? (e.g., `TestStorageEquality/query=...`)
   - What query is being executed?
   - What are the query parameters? (time range, direction, limit)
   - Which assertion failed? (line number in bench_test.go)
   - Use **Read** to examine `pkg/logql/bench/bench_test.go`

3. **Compare branch to main**:
   ```bash
   git diff main...HEAD
   ```
   - What code changed in dataobj-engine or query engine?
   - Which files are modified?
   - How could these changes affect query results?

4. **Understand the exact difference**:
   - What did the chunk store return? (this is the "expected" baseline)
   - What did the dataobj-engine return? (this is the "actual" failing result)
   - Are they returning different log entries, or the same entries with different labels/values?
   - Show the exact diff - what is present in one but not the other?

5. **Examine the test data structure**:
   - Use **Read** to examine `pkg/logql/bench/generator.go` to understand how test data is generated
   - What are the stream labels? (labels attached to log streams)
   - What structured metadata exists? (labels attached to individual log entries)
   - What does the log content look like? (JSON, logfmt, plain text, etc.)
   - Which parts of the data are relevant to the failure?

6. **Understand expected behavior**:
   - Based on the query and test data, what SHOULD happen?
   - How does the chunk store (legacy) implementation handle this?
   - What is the dataobj-engine supposed to do?

**Output**: Create a `PROBLEM_SUMMARY.md` file in the current worktree root (to avoid permissions issues) with a section like:

```markdown
## 1. The Exact Problem

### Test Case
- **Test**: [exact test name]
- **Query**: [query string]
- **Time Range**: [start to end]
- **Direction**: [FORWARD/BACKWARD]

### The Exact Difference

[Detailed comparison showing what's different]

### Test Data Structure

[Description of relevant test data: stream labels, metadata, log content]

### Why [Expected Behavior] Should Exist

[Step-by-step explanation of what should happen based on query and data]

### Legacy/Chunk Store Behavior

[Code references showing how chunk store implements this]

### DataObj-Engine Expected Behavior

[Code references showing how dataobj-engine should implement this]
```

**Before proceeding**: 
1. Show the PROBLEM_SUMMARY.md content to the user
2. Ask: "Does this analysis match your understanding of the failure?"
3. Wait for user confirmation before proceeding to Phase 2

---

### Phase 2: Generate and Record Hypotheses

**Goal**: Brainstorm possible root causes and document them for systematic testing.

**Steps**:

1. **Research relevant code**:
   - Use **Read** to examine the chunk store implementation to understand correct behavior
   - Use **Read** to examine the dataobj-engine implementation to understand current behavior
   - Use **Grep** to search for related functions and types
   - Look for differences in how they handle the query
   - Focus on recent changes in `git diff main...HEAD`
   - Identify potential bug locations in these common areas:
     - Datobj Query planning: `pkg/logql/engine/`
     - Chunks Pipeline construction: `pkg/logql/log/`
     - Schema handling: `pkg/dataobj/schema/`
     - Iterator differences: `pkg/dataobj/iter/` vs `pkg/storage/chunk/`

2. **Generate hypotheses**:
   - For each potential cause, create a hypothesis statement
   - Be specific about what might be wrong
   - Include code locations to investigate

3. **Record hypotheses in PROBLEM_SUMMARY.md**:

```markdown
## 2. Hypotheses to Test

### Hypothesis 1: [Brief description]
**Why this might happen**:
- [Reason 1]
- [Reason 2]

**How to verify**:
- [Test approach 1]
- [Test approach 2]

**Code locations**:
- `pkg/path/file.go:line`

### Hypothesis 2: [Next hypothesis]
...
```

**Before testing**: Present hypotheses to the user and ask:
- "Do these hypotheses make sense?"
- "Are there other scenarios we should test?"
- "Which hypothesis should we test first?"

---

### Phase 3: Test Each Hypothesis Systematically

**Goal**: Validate or invalidate each hypothesis through unit tests, code inspection, or debug logging.

**For each hypothesis**:

1. **Design a test**:
   - Create a unit test that fails with the current implementation, but which proves the hypothesis
   - If the hypothesis is TRUE, and we were to change the implementation accordingly, the test would then PASS
   - This is a TDD, or Red-Green approach
   - The test should isolate just this one aspect

2. **Implement the test (RED)**:
   - Use **Write** to create test file (in `*_test.go` format, placed in same package as code under test)
   - Keep tests focused and minimal
   - Use clear, descriptive test names
   - Add comments explaining what's being tested
   - Run using **Bash**:
     ```bash
     go test -v -run TestName ./pkg/...
     # Or for the bench test specifically:
     go test -v -run 'TestStorageEquality/query=...' ./pkg/logql/bench/
     ```
   - Confirm it fails as expected

3. **Analyze results**:
   - If test fails correctly: Hypothesis VALIDATED → Keep test, proceed to propose fix
   - If test passes unexpectedly: Hypothesis INVALIDATED → Delete test using **Bash** (`rm`)
   - If unclear: Add debug logging and re-run

**When to stop testing**:
- ✅ Stop when you find ONE validated hypothesis that explains the failure
- ✅ You can then present findings and propose a fix
- ❌ Don't feel obligated to test ALL hypotheses if root cause is found

4. **Update PROBLEM_SUMMARY.md**:

```markdown
## 2. Hypotheses Ruled Out

### ❌ Hypothesis X: "[Description]"
**Why ruled out**:
- [Evidence 1]
- [Evidence 2]

**Evidence**: [Test results, code behavior, debug output]
```

Or:

```markdown
## 3. Hypotheses Validated

### ✅ Hypothesis Y: "[Description]"
**Why this is the cause**:
- [Evidence 1]
- [Evidence 2]

**Evidence**: [Test results showing this is the problem]
```

5. **If new hypotheses emerge**:
   - Add them to the list
   - Test them systematically
   - Don't get distracted - finish testing current hypothesis first

**Important practices**:
- Test ONE hypothesis at a time
- Don't keep tests for invalidated hypotheses (they add noise)
- DO keep tests for validated hypotheses (they prevent regressions)
- Add debug logging strategically when tests aren't conclusive

---

### Phase 3a: Add Debug Logging (When Needed)

**When unit tests aren't conclusive**, add strategic debug logging:

1. **Identify key execution points**:
   - Where data flows through the system
   - Where transformations happen
   - Where the bug might be occurring

2. **Add focused logging**:
   - Use **Edit** to add logging statements to relevant files
   ```go
   fmt.Printf("\n[COMPONENT] Event: key=%v, value=%v\n", key, value)
   ```

3. **Use consistent prefixes**:
   - `[PLANNER]` - for query planning phase
   - `[PIPELINE CONSTRUCTION]` - for pipeline setup
   - `[EXECUTOR]` - for execution phase
   - `[DATAOBJ-ENGINE]` - for dataobj-engine specific code
   - `[CHUNKS]` - for chunk store code
   - `[ComponentName]` - for specific components

4. **Log relevant information**:
   - Input schemas (what columns exist)
   - Output schemas (what columns were created)
   - Execution order (what runs when)
   - Data transformations (what changed)
   - Query parameters and filters being applied

5. **Run tests and analyze**:
   - Run unit test using **Bash**: `go test -v -run TestName ./pkg/...`
   - Run bench test: `go test -v -run 'TestStorageEquality/query=...' ./pkg/logql/bench/`
   - Or use: `./run_single_test.sh` if available
   - Compare outputs - do they show the same pattern?

6. **Clean up debug logging**:
   - Once root cause is found, use **Edit** to remove ALL debug statements
   - Run tests again to confirm they still pass/fail as expected
   - Don't leave debug code in the codebase

7. **Update PROBLEM_SUMMARY.md with findings**:

```markdown
## Evidence from Debug Logging

### From Unit Test
```
[Log output showing behavior]
```

### From CI Test  
```
[Log output showing behavior]
```

### Analysis
[What the logs reveal about the bug]
```

---

### Phase 4: Present Findings

**Goal**: Summarize all findings in a clear, actionable format.

**Create final sections in PROBLEM_SUMMARY.md**:

1. **Root Cause Identified** (if found):
```markdown
## ROOT CAUSE IDENTIFIED

**The Bug**: [One-sentence description]

### Evidence
[Concrete proof from tests, logs, code analysis]

### Why This Happens
[Technical explanation]

### Expected vs Actual Behavior
[Comparison showing the problem]
```

2. **Test Coverage** (if root cause found):
```markdown
## Test Coverage

### Failing Test (RED - Documents the Bug)
**Test**: `TestName` in `path/file_test.go`

This test reproduces the exact bug:
1. [What it does]
2. [Why it fails]

**Status**: ❌ FAILS (as expected - documents the bug)
**Expected after fix**: ✅ PASS

### Passing Test (GREEN - Proves Logic is Sound)
**Test**: `TestName` in same file

This test proves the underlying logic works:
1. [What it does]
2. [Why it passes]

**Status**: ✅ PASS (proves implementation is correct when used properly)
```

3. **The Fix** (proposed solution):
```markdown
## CONCLUSION

### The Fix
[What needs to change]

**Location to investigate**: `path/file.go:line-range`

**Proposed approach**:
1. [Step 1]
2. [Step 2]

### How to Verify Fix
```bash
# Run the failing test (should turn green)
go test -v -run TestFailingCase ./pkg/...

# Run the bench test (should pass)
./run_single_test.sh
```
```

4. **OR, if root cause not found** - document what was eliminated:
```markdown
## Investigation Summary

### What We've Ruled Out
[List of invalidated hypotheses with evidence]

### What We Know
[Confirmed facts from testing]

### Remaining Questions
[Open questions that need further investigation]

### Suggested Next Steps
[New hypotheses to explore or different approaches]
```

---

## If You Get Stuck

- **Results look identical but test fails**: Check for subtle differences
  - Label ordering (maps in Go are unordered - use sorted comparison)
  - Timestamp precision differences (nanosecond vs millisecond)
  - Floating point comparison issues (use tolerance-based comparison)
  - Stream order differences (results may be semantically identical but ordered differently)

- **Can't understand why results differ**: Add schema logging
  - Log input/output schemas in both engines
  - Use **Edit** to add logging in `pkg/dataobj/schema/` and chunk store code
  - Compare column names, types, and order
  - Check for missing or extra columns

- **Too many hypotheses**: Focus on the query type first
  - Filter queries: Check label matcher handling and filter expression evaluation
  - Aggregations: Check grouping logic and aggregation function implementation
  - Pipeline stages: Identify which specific stage produces different results
  - Time range queries: Check time range handling and boundary conditions

- **Can't reproduce locally**: Check test data generation
  - Use **Read** to verify `pkg/logql/bench/generator.go` produces expected data
  - Check if test uses specific seeds or timestamps
  - Look for environment-specific behavior (timing, randomness)
  - Try running with same parameters as CI: `go test -v -run 'TestStorageEquality/query=...' ./pkg/logql/bench/`

- **Dataobj-engine and chunks produce different column schemas**: This is expected sometimes
  - Focus on semantic equivalence, not structural identity
  - Check if the data is the same, even if column names/order differ
  - Look at how each engine represents structured metadata vs stream labels

## Best Practices

### DO:
- ✅ Start with the simplest hypothesis first
- ✅ Create focused, isolated unit tests
- ✅ Delete tests for invalidated hypotheses  
- ✅ Keep tests for validated hypotheses
- ✅ Use debug logging when tests aren't conclusive
- ✅ Document both positive and negative findings
- ✅ Present findings to user before moving to next phase
- ✅ Update PROBLEM_SUMMARY.md continuously
- ✅ Write PROBLEM_SUMMARY.md to worktree root to avoid permissions issues
- ✅ Run `direnv allow` or `direnv reload` if using nix-based environments
- ✅ Focus on recent changes in `git diff main...HEAD` first

### DON'T:
- ❌ Test multiple hypotheses simultaneously
- ❌ Keep failing tests that don't prove anything
- ❌ Skip documentation - the summary is critical
- ❌ Jump to conclusions without evidence
- ❌ Add debug logging everywhere - be strategic
- ❌ Forget to remove debug logging when done
- ❌ Leave debug code in the codebase after investigation
- ❌ Assume identical structure - focus on semantic equivalence for dataobj vs chunks

---

## Example Session Flow

1. **User reports**: "TestStorageEquality is failing" or provides CI URL

2. **You investigate** Phase 1:
   - Use **WebFetch** to get CI logs (if URL provided)
   - Use **Read** to examine `pkg/logql/bench/bench_test.go`
   - Run `git diff main...HEAD` with **Bash**
   - Use **Read** to examine `pkg/logql/bench/generator.go`
   - Use **Write** to create detailed problem statement in PROBLEM_SUMMARY.md
   - **Present to user**, get confirmation

3. **You brainstorm** Phase 2:
   - Use **Read** and **Grep** to research chunk store and dataobj-engine code
   - Focus on `pkg/logql/engine/`, `pkg/dataobj/`, `pkg/storage/chunk/`
   - Generate 3-5 hypotheses about differences
   - Use **Edit** to add hypotheses to PROBLEM_SUMMARY.md
   - **Present to user**, ask for additional hypotheses

4. **You test** Phase 3:
   - Use **Write** to create unit test for Hypothesis 1 in `pkg/dataobj/some_test.go`
   - Run test with **Bash**: `go test -v -run TestName ./pkg/dataobj/`
   - Result invalidates hypothesis
   - Use **Bash** to delete test: `rm pkg/dataobj/some_test.go`
   - Mark hypothesis as ❌ ruled out in PROBLEM_SUMMARY.md
   - Move to Hypothesis 2
   - Use **Write** to create unit test for Hypothesis 2
   - Run test → Result validates hypothesis!
   - Keep test, mark hypothesis as ✅ validated
   - Root cause found - stop testing remaining hypotheses

5. **You add logging** Phase 3a (if needed):
   - Use **Edit** to add strategic logging to dataobj-engine and chunk store code
   - Run both unit test and bench test with **Bash**
   - Analyze logs to confirm root cause
   - Use **Edit** to remove all debug logging
   - Document findings in PROBLEM_SUMMARY.md

6. **You present** Phase 4:
   - Show root cause with evidence
   - Show failing test (RED state - documents bug)
   - Show passing test (GREEN state - proves logic works)
   - Propose fix location and approach
   - **User can now implement fix with confidence**

---

## Key Outputs

After completing this workflow, you should have:

1. **PROBLEM_SUMMARY.md** - Complete analysis document in worktree root with:
   - CI log snippets (if applicable)
   - Exact problem description comparing chunk store vs dataobj-engine results
   - Git diff analysis (`main...HEAD`)
   - Test data structure from generator.go
   - Hypotheses tested (validated and ruled out)
   - Root cause (if found)
   - Evidence from tests and logging
   - Proposed fix with specific code locations

2. **Unit test(s)** - In appropriate `*_test.go` file (same package as code under test):
   - Failing test that reproduces the bug (RED state)
   - Passing test that proves logic is sound (GREEN state)
   - Tests should follow TDD red-green pattern
   - Tests are committed to prevent regressions

3. **Clean codebase**:
   - NO debug logging left in code
   - NO temporary test files for invalidated hypotheses
   - Only production-quality tests remain

4. **Clear path forward** for the user:
   - Specific file/line to fix in dataobj-engine (or chunk store if that's where the bug is)
   - Test that will validate the fix
   - Evidence-based understanding of the problem
   - Confidence that the fix will make TestStorageEquality pass
