---
name: debug-ci-failure
description: Debug a failing test on CI and come up with a fix.
---

# Debug CI Failure

Use this skill when debugging failures on CI. The skill is invoked with a url to a failing CI job. Using the logs from that failing job and the source code, identify the exact failure and come up with a fix.

## Tools to Use

Throughout this workflow, use these Claude Code tools:

- **WebFetch**: Fetch CI job logs from GitHub Actions URLs
- **GitHub MCP**: Interact with GitHub (get PR details, read file contents, list commits, etc.)
  - Note: If an operation cannot be completed with the GitHub MCP, try the `gh` CLI via **Bash** instead
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

## Workflow

### Phase 1: Identify the Exact Failure

**Goal**: Create a clear, detailed problem statement documenting exactly what is failing.

**Steps**:

1. **If provided a CI URL**:
   - If given a GitHub url, use the **GitHub MCP** or `gh` CLI via **Bash** to retrieve the job logs from the URL.
     - If the logs cannot be fetched, ask the user to download them manually and provide a reference to them. 
   - If not a GitHub url, use **WebFetch** to retrieve the job logs from the URL
   - Extract the failing test name(s)
   - Identify error messages and stack traces
   - Copy relevant log snippets into PROBLEM_SUMMARY.md

2. **Identify the failing test case**:
   - Which exact test is failing? (e.g., `TestStorageEquality/query=...`)
   - What is the test setup?
   - Which assertion failed? (line number in *_test.go)
   - Use **Read** to examine the test file

3. **Compare branch to main**:
   ```bash
   git diff main...HEAD
   ```
   - What code changed?
   - Which files are modified?
   - How could these changes cause the failure?

4. **Understand the exact difference**:
   - Show the exact diff - what is present in one but not the other?
   - How is the current branch different from `main`, and how could this cause the failure?

5. **Examine the test data structure**:
  - How is the test setup? What assumptions are being made?
  - Are there certain configs or mocks to produce a certain code path?

6. **Understand expected behavior**:
   - Based on test data, what SHOULD happen?
   - How do the changes in the branch (when compared to `main`) affect the expected behavior?

**Output**: Create a `PROBLEM_SUMMARY.md` file in the current worktree root (to avoid permissions issues) with a section like:

```markdown
## 1. The Exact Problem

### Test Case
- **Test**: [exact test name]
- **Setup**: [summary of relevant test setup]
- **Expected Behavior**: [summary of what should happen]
- **Actual Behavior**: [summary of what actually happened]

### The Exact Difference

[Detailed comparison showing what's different]

### Test Data Structure

[Description of relevant test data]

### Why [Expected Behavior] Should Exist

[Step-by-step explanation of what should happen based on test data and code]

### Actual Behavior

[What behavior was observed, ans how it contrasts with the expected behavior]
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
   - Use **Read** to examine all code paths exercised by the test
   - Use **Grep** to search for related functions and types
   - Pay close attention to any changes on the local branch compared to `main`. A failing CI test usually means a new behavior, bug, or regression was introduced. Try to figure out which one this is.
   - Identify potential locations for the bug, behavior, or regression

2. **Generate hypotheses**:
   - For each potential cause, create a hypothesis statement
   - Be specific about what might be wrong
   - Include code locations to investigate
   
3. **Generate test cases to test the hypotheses**:
   - For each hypothesis, design a test case, or multiple test cases, that will either prove or disprove it
   - Keep test cases simple and focused, try to test as close as possible to the suspected code.

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
- "Are there other hypotheses we should consider?"

---

### Phase 3: Test Each Hypothesis Systematically

**Goal**: Validate or invalidate each hypothesis through unit tests, code inspection, or debug logging. Often you may need a unit test to drive code with debug logging, so you may need a combination of these tactics.

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
   - Run: `go test -v -run TestName ./pkg/...` using **Bash**
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
   - `[ComponentName]` - for specific components

4. **Log relevant information**:
   - Input schemas (what columns exist)
   - Output schemas (what columns were created)
   - Execution order (what runs when)
   - Data transformations (what changed)

5. **Run tests and analyze**:
   - If necessary, create or modify tests to make sure they execute the code where the logging was added
   - Run unit test: `go test -v -run TestName ./pkg/...` using **Bash**
   
6. **Clean up debug logging**:
   - Once root cause is found, use **Edit** to remove ALL debug statements
   - Run tests again to confirm they still pass/fail as expected
   - Don't leave debug code in the codebase

7. **Update findings**:
   Update PROBLEM_SUMMARY.md and hypotheses accordingly.

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

**OR, if root cause not found** - document what was eliminated:
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

- **Can't reproduce the failure**: Check if test is environment-specific (CI vs local)
  - Compare CI environment variables with local
  - Check for timing issues or race conditions
  - Look for platform-specific behavior (Linux vs macOS)

- **Too many hypotheses**: Focus on changes in `git diff main...HEAD` first
  - New code is the most likely culprit for new failures
  - Look for recently modified functions called by the failing test

- **Unclear test results**: Add more specific assertions or debug output
  - Make assertions more granular
  - Print intermediate values to understand state

- **Can't isolate the bug**: Try bisecting the changes or simplifying test case
  - Use `git bisect` to find the exact commit that introduced the failure
  - Create minimal reproduction case with less setup

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

### DON'T:
- ❌ Test multiple hypotheses simultaneously
- ❌ Keep failing tests that don't prove anything
- ❌ Skip documentation - the summary is critical
- ❌ Jump to conclusions without evidence
- ❌ Add debug logging everywhere - be strategic
- ❌ Forget to remove debug logging when done
- ❌ Leave debug code in the codebase after investigation

---

## Example Session Flow

1. **User reports**: "Test X is failing" or "https://github.com/org/repo/actions/runs/21611883568/job/62282309508?pr=20603 is failing"

2. **You investigate** Phase 1:
   - Use **GitHub MCP**, `gh` via **Bash**, or **WebFetch** to get CI logs (if URL provided)
   - Use **Read** to examine test file
   - Run `git diff main...HEAD` with **Bash**
   - Use **Write** to create detailed problem statement in PROBLEM_SUMMARY.md
   - **Present to user**, get confirmation

3. **You brainstorm** Phase 2:
   - Use **Read** and **Grep** to research relevant code
   - Generate 2-5 hypotheses
   - Use **Edit** to add hypotheses to PROBLEM_SUMMARY.md
   - **Present to user**, ask for additional hypotheses

4. **You test** Phase 3:
   - Use **Write** to create unit test for Hypothesis 1 in `pkg/path/file_test.go`
   - Run test with **Bash**: `go test -v -run TestName ./pkg/...`
   - Result invalidates hypothesis
   - Use **Bash** to delete test: `rm pkg/path/file_test.go`
   - Mark hypothesis as ❌ ruled out in PROBLEM_SUMMARY.md
   - Move to Hypothesis 2
   - Use **Write** to create unit test for Hypothesis 2
   - Run test → Result validates hypothesis!
   - Keep test, mark hypothesis as ✅ validated
   - Root cause found - stop testing remaining hypotheses

5. **You add logging** Phase 3a (if needed):
   - Use **Edit** to add strategic logging to key components
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
   - Exact problem description
   - Git diff analysis (`main...HEAD`)
   - Hypotheses tested (validated and ruled out)
   - Root cause (if found)
   - Evidence from tests and logging
   - Proposed fix

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
   - Specific file/line to fix
   - Test that will validate the fix
   - Evidence-based understanding of the problem
   - Confidence that the fix will resolve the CI failure
