---
name: fix-correctness-bug
description: Fix a Loki correctness bug to make the failing test pass (TDD Green phase)
---

# Fix Correctness Bug

Implements the code fix to resolve a Loki v1/v2 correctness bug, making the previously failing test pass. This is the **GREEN** phase of TDD - the goal is to make the failing test PASS with a minimal, correct implementation.

## What this skill does

1. Locates and reads the failing test created by `/test-hypothesis`
2. Analyzes the hypothesis report to understand the root cause
3. Implements the minimal code changes needed to fix the bug
4. Runs the test to verify it now PASSES
5. Does NOT modify the test - only implementation code
6. Ensures no other tests are broken by the fix

## Prerequisites

- Working in a Loki worktree with a failing test
- Test created by `/test-hypothesis` skill
- Hypothesis report available (usually `MISMATCH_REPORT.md`)
- Go build environment set up

## Usage

```
/fix-correctness-bug <test-file-path> <test-name>
```

Or just the test name if already discussed:
```
/fix-correctness-bug TestRegexFilterWithPipeOperator
```

Example with full path:
```
/fix-correctness-bug pkg/engine/pipeline_test.go TestRegexFilterWithPipeOperator
```

## Instructions for Claude

When this skill is invoked:

### Phase 1: Understand the Test and Bug

1. **Locate and read the failing test:**
   - If test file path provided, read that file
   - Otherwise search for test by name:
     ```bash
     grep -r "func TestYourTestName" pkg/engine/
     ```

2. **Analyze the test to understand:**
   - What behavior is being tested?
   - What inputs trigger the bug?
   - What is the expected output?
   - What does the test assert?
   - Why is it currently failing?

3. **Review the hypothesis report:**
   - Confirm the root cause description
   - Review the "Specific Code Locations" section
   - Check "Suggested Fix" section
   - Understand the bug mechanism

4. **Run the test to see current failure:**
   ```bash
   cd pkg/engine  # or appropriate directory
   go test -v -run TestYourTestName
   ```
   - Capture the exact failure message
   - Understand what value is returned vs expected

### Phase 2: Locate Implementation Code

1. **Identify files to modify:**
   - Use hypothesis report's "Specific Code Locations"
   - Follow imports from the test file
   - Look for the pipeline stage or component being tested
   - Common locations in v2 engine:
     - `pkg/engine/pipeline.go` - pipeline construction
     - `pkg/engine/stages.go` - stage implementations
     - `pkg/engine/filter.go` - filter logic
     - `pkg/engine/parser.go` - parser stages
     - `pkg/engine/<component>.go` - specific components

2. **Search for relevant functions:**
   ```bash
   # Based on test name, find related functions
   grep -r "FilterStage" pkg/engine/
   grep -r "RegexFilter" pkg/engine/
   ```

3. **Read the implementation code:**
   - Understand current logic flow
   - Identify where the bug is occurring
   - Look for missing checks, incorrect logic, or wrong assumptions

### Phase 3: Implement the Fix

1. **Key principles for the fix:**
   - **Minimal change** - smallest change that makes test pass
   - **Correct logic** - fix should align with v1 behavior when v1 is correct
   - **No test changes** - only modify implementation, never the test
   - **Preserve existing behavior** - don't break other cases
   - **Add comments** - explain why the fix is needed

2. **Common fix patterns by bug type:**

   **Missing optimization/simplification:**
   ```go
   // Before: complex processing always runs
   func processQuery(expr Expr) Result {
       return complexProcessing(expr)
   }
   
   // After: add optimization check
   func processQuery(expr Expr) Result {
       // Simplify regex patterns before processing (fixes mismatch d25f79fc)
       if canSimplify(expr) {
           expr = simplify(expr)
       }
       return complexProcessing(expr)
   }
   ```

   **Missing filter/check:**
   ```go
   // Before: condition not checked
   func filterRecords(records []Record) []Record {
       result := []Record{}
       for _, r := range records {
           result = append(result, process(r))
       }
       return result
   }
   
   // After: add missing filter
   func filterRecords(records []Record) []Record {
       result := []Record{}
       for _, r := range records {
           // Apply regex filter after extraction (fixes mismatch d25f79fc)
           if matchesFilter(r) {
               result = append(result, process(r))
           }
       }
       return result
   }
   ```

   **Incorrect logic:**
   ```go
   // Before: wrong comparison
   func parseValue(s string) int {
       if len(s) > 0 {  // Bug: should be >= some threshold
           return parse(s)
       }
       return 0
   }
   
   // After: correct comparison
   func parseValue(s string) int {
       // Fixed: check for minimum valid length (fixes mismatch d25f79fc)
       if len(s) >= 2 {
           return parse(s)
       }
       return 0
   }
   ```

   **Missing case handling:**
   ```go
   // Before: doesn't handle all cases
   func extractField(line string, extractor Extractor) string {
       switch extractor.Type {
       case JSON:
           return extractJSON(line)
       case Logfmt:
           return extractLogfmt(line)
       }
       return ""
   }
   
   // After: add missing case
   func extractField(line string, extractor Extractor) string {
       switch extractor.Type {
       case JSON:
           return extractJSON(line)
       case Logfmt:
           return extractLogfmt(line)
       case Regex:  // Added: handle regex extractors (fixes mismatch d25f79fc)
           return extractRegex(line, extractor.Pattern)
       }
       return ""
   }
   ```

3. **Add explanatory comment:**
   - Reference the bug/mismatch
   - Explain why the change is needed
   - Link to test that proves the fix

   ```go
   // Apply regex filter after field extraction. Without this, regex patterns
   // are not evaluated correctly on extracted fields, causing mismatches between
   // v1 and v2 (see TestRegexFilterWithPipeOperator, mismatch d25f79fc).
   if matchesRegex(extractedValue, pattern) {
       // ... process matching records
   }
   ```

### Phase 4: Verify the Fix

1. **Run the specific failing test:**
   ```bash
   cd pkg/engine
   go test -v -run TestYourTestName
   ```

2. **Verify it now PASSES:**
   ```
   --- PASS: TestRegexFilterWithPipeOperator (0.01s)
   PASS
   ok      github.com/grafana/loki/pkg/engine    0.123s
   ```

3. **If test still fails:**
   - Review the failure message
   - Check if your fix addressed the right issue
   - Debug the logic flow
   - Review hypothesis report again
   - May need to revise the fix approach

4. **If test passes but seems wrong:**
   - Verify you didn't inadvertently change test expectations
   - Ensure the fix actually solves the problem, not just makes test pass
   - Check that the logic matches what v1 does (when v1 is correct)

### Phase 5: Run Related Tests

1. **Run all tests in the same package:**
   ```bash
   cd pkg/engine
   go test -v ./...
   ```

2. **Check for regressions:**
   - Ensure no other tests broke
   - If tests fail, your fix may be too broad or incorrect
   - Adjust fix to be more targeted

3. **Common regression patterns:**
   - Fix breaks edge cases
   - Fix is too aggressive/broad
   - Fix changes behavior in unexpected ways

4. **If regressions occur:**
   - Make fix more specific/targeted
   - Add guards or conditions
   - May need to adjust approach

### Phase 6: Verify Broader Impact

1. **Run v2 engine tests:**
   ```bash
   go test -v github.com/grafana/loki/pkg/engine/...
   ```

2. **Optionally test with the original mismatch query:**
   - If feasible, construct a test with the actual query from the report
   - Verify it produces expected results
   - This is more of a sanity check than requirement

### Phase 7: Document and Report

1. **Review the changes:**
   - Ensure code is clean and readable
   - Check that comments are clear
   - Verify minimal change principle was followed

2. **Report to user:**
   - Files modified
   - Brief explanation of fix
   - Test results (passing)
   - Any notes or caveats

   Example output:
   ```
   ✓ Fixed bug in pkg/engine/filter.go:234
   
   Changes:
   - Added regex pattern check after field extraction
   - Ensures filters apply to extracted values, not raw log lines
   
   Test Results:
   ✓ TestRegexFilterWithPipeOperator: PASS
   ✓ All pkg/engine tests: PASS (42 tests)
   
   The fix ensures v2 correctly applies regex filters to extracted fields,
   matching v1 behavior. This resolves the mismatch where v2 returned 0 rows
   but v1 correctly returned 2 rows.
   
   Ready for commit and PR creation.
   ```

## Common Pitfalls to Avoid

1. **Don't modify the test** - Only change implementation code
2. **Don't make large changes** - Keep it minimal and focused
3. **Don't skip running tests** - Must verify fix actually works
4. **Don't break other tests** - Check for regressions
5. **Don't cargo-cult v1 code** - Understand the fix, don't blindly copy
6. **Don't over-engineer** - Simple fix is usually best
7. **Don't leave TODOs** - Complete the fix fully

## Success Criteria

✓ Implementation code modified (not test)
✓ Changes are minimal and focused
✓ Original failing test now PASSES
✓ All related tests still PASS
✓ Code includes explanatory comments
✓ No regressions introduced
✓ Fix addresses root cause from hypothesis

## Next Steps

After this skill completes successfully:
1. Review the changes
2. Consider additional test cases (edge cases)
3. Prepare commit message referencing the mismatch
4. Create PR for review
5. Monitor for any additional issues

## Example End-to-End Flow

1. Hypothesis identifies: "v2 doesn't apply regex filters after logfmt extraction"
2. `/test-hypothesis` creates test that parses `{} | logfmt | status=~"5.."` and asserts 2 rows
3. Test FAILS: v2 returns 0 rows instead of 2
4. `/fix-correctness-bug` identifies the bug in `pkg/engine/filter.go`
5. Adds check: `if isRegexFilter && afterExtraction { applyRegexFilter() }`
6. Test now PASSES: v2 returns 2 rows
7. All other tests still pass
8. Fix is complete and ready for PR
