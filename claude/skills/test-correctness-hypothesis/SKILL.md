---
name: test-correctness-hypothesis
description: Create focused unit tests from failing Loki correctness tests (TDD Red phase refinement)
---

# Test Hypothesis

Creates focused unit tests that isolate specific bugs found by Loki v1/v2 correctness tests. This is the **RED** phase refinement of TDD - starting from a failing correctness test against generated data, we create a minimal unit test that isolates the exact bug behavior.

## Workflow

The loki-correctness-tool now generates failing correctness tests directly:
1. **Tool generates**: `pkg/logql/bench/mismatch_<id>_test.go` - fails against generated data
2. **This skill**: Creates focused unit test in `pkg/engine/` - isolates the specific bug
3. **Next step**: `/fix-correctness-bug` implements the fix

## What this skill does

1. Reads and analyzes the existing failing correctness test
2. Runs the correctness test to understand the failure mode
3. Analyzes the hypothesis and root cause from test comments
4. Creates a focused unit test that:
   - Lives in `pkg/engine/` near the bug location
   - Tests the specific pipeline/stage behavior
   - Uses custom arrow records to isolate the bug
   - **FAILS** with the same root cause as the correctness test
5. Does NOT modify any implementation code
6. Verifies the unit test fails for the right reason

## Prerequisites

- Working in a Loki worktree created for the mismatch
- Existing correctness test file (e.g., `pkg/logql/bench/mismatch_<id>_test.go`)
- Test data generated (`make generate-data` in `pkg/logql/bench`)
- Go test environment set up

## Usage

```
/test-hypothesis <correctness-test-file>
```

Examples:
```
/test-hypothesis pkg/logql/bench/mismatch_bfebdb3f_test.go
/test-hypothesis mismatch_bfebdb3f_test.go
```

## Instructions for Claude

When this skill is invoked:

### Phase 0: Analyze the Correctness Test

1. **Read the correctness test file thoroughly:**
   - Extract the LogQL query being tested
   - Read all comments - they contain the hypothesis and root cause
   - Note the specific metrics:
     - How many entries v1 vs v2 returned
     - Lines processed ratio
     - Series count differences
   - Identify the root cause section pointing to specific code locations
   - Understand what combination of operations triggers the bug

2. **Run the correctness test:**
   ```bash
   cd pkg/logql/bench
   # Ensure data is generated
   make generate-data
   # Run the specific test
   go test -v -slow-tests -run TestMismatch_<id>
   ```

3. **Analyze the failure output:**
   - Note the exact assertion that fails
   - Review the logged statistics (entries, lines processed, series)
   - Understand the magnitude of the difference
   - Look for patterns in the series/labels that differ

4. **Extract key information:**
   - **Query structure**: What operations are chained together?
   - **Bug trigger**: What specific combination causes the issue?
   - **Root cause location**: Which files/functions are suspected?
   - **Expected vs actual**: What should happen vs what v2 does?

### Phase 1: Design the Unit Test

1. **Determine the appropriate test location:**
   - Tests for v2 engine are in `pkg/engine/` (not `pkg/logql/`)
   - Based on the root cause section, identify the file:
     - `aggregator.go` → test in same directory or `aggregator_test.go`
     - `range_aggregation.go` → `range_aggregation_test.go`
     - `vector_aggregate.go` → `vector_aggregate_test.go`
     - Pipeline issues → `pipeline_test.go`
   - Search for existing test patterns:
     ```bash
     grep -r "TestAggregator" pkg/engine/
     grep -r "arrow.Record" pkg/engine/
     ```

2. **Simplify the test query:**
   - Start with the full correctness test query
   - Remove parts that aren't essential to the bug
   - Keep the minimum operations that trigger the issue
   - Example simplification:
     ```
     Original: sum by (level, detected_level) (count_over_time({cluster="prod"} | json | drop __error__ [1s]))
     Simplified: sum by (level) (count_over_time({cluster="prod"} | json [1s]))
     Or even: count_over_time({cluster="prod"} | json [1s])
     ```
   - Test each simplification to verify it still triggers the bug

3. **Plan the test data:**
   - What minimal log lines are needed?
   - What labels must be present?
   - What values should extraction produce?
   - How many records/rows are needed?
   - What timestamps/time ranges are needed?

### Phase 2: Create the Unit Test

1. **Review existing test patterns in the target file:**
   - Look at how other tests construct pipelines
   - Note how they create arrow records for test data
   - Understand assertion patterns used
   - Find helper functions available

2. **Create descriptive test function:**
   ```go
   // TestAggregatorDuplicatesGroupsPerRow tests that the aggregator
   // properly deduplicates groups by label values, not creating a new
   // group for each row. Currently fails because Add() computes hashes
   // per-row without stream-level deduplication.
   // 
   // Root cause: pkg/engine/internal/executor/aggregator.go lines 90-180
   // See: pkg/logql/bench/mismatch_bfebdb3f_test.go
   func TestAggregatorDuplicatesGroupsPerRow(t *testing.T) {
   ```

3. **Structure the test following this pattern:**

```go
func TestSpecificBugBehavior(t *testing.T) {
    // 1. Parse the simplified LogQL query
    query := `sum by (level) (count_over_time({job="app"} | json [1s]))`
    
    expr, err := syntax.ParseExpr(query)
    require.NoError(t, err)
    
    // 2. Create test data as arrow records
    pool := memory.NewGoAllocator()
    
    // Define schema matching what the pipeline expects
    schema := arrow.NewSchema([]arrow.Field{
        {Name: "line", Type: arrow.BinaryTypes.String},
        {Name: "timestamp", Type: arrow.FixedWidthTypes.Timestamp_ns},
        // Add other fields as needed
    }, nil)
    
    builder := array.NewRecordBuilder(pool, schema)
    defer builder.Release()
    
    // Add minimal test data that exposes the bug
    // For aggregation bugs: multiple rows with same labels
    // For parser bugs: specific log formats
    // For filter bugs: data that should be filtered
    builder.Field(0).(*array.StringBuilder).AppendValues([]string{
        `{"level":"error","msg":"first"}`,
        `{"level":"error","msg":"second"}`,
        `{"level":"warn","msg":"third"}`,
    }, nil)
    
    // Add timestamps (use realistic ns precision)
    now := time.Now().UnixNano()
    builder.Field(1).(*array.Int64Builder).AppendValues([]int64{
        now,
        now + int64(time.Second),
        now + 2*int64(time.Second),
    }, nil)
    
    record := builder.NewRecord()
    defer record.Release()
    
    // 3. Build and execute the pipeline
    // (exact construction depends on what you're testing)
    pipeline, err := BuildPipeline(expr) // or appropriate constructor
    require.NoError(t, err)
    
    result, err := pipeline.Process(record)
    require.NoError(t, err)
    
    // 4. Assert on EXPECTED behavior (what v1 does, what SHOULD happen)
    // This assertion should FAIL because v2 has the bug
    
    // For aggregation bugs:
    assert.Equal(t, 2, CountUniqueGroups(result), 
        "Expected 2 groups (error, warn) but v2 creates a group per row")
    
    // For count bugs:
    assert.Equal(t, 3, GetTotalCount(result),
        "Expected total count of 3 but v2 returns wrong count")
    
    // For value bugs:
    expectedSeries := map[string]float64{
        `{level="error"}`: 2.0,
        `{level="warn"}`: 1.0,
    }
    AssertSeriesMatch(t, expectedSeries, result)
}
```

4. **Key principles for the unit test:**
   - **Test only v2 code** (in `pkg/engine/`)
   - **Use minimal data** - just enough to expose the bug
   - **Assert correct behavior** - what v1 does or what should happen
   - **Make it focused** - test ONE specific behavior
   - **No mocks unless necessary** - use real pipeline/component construction
   - **Clear failure messages** - explain what's wrong
   - **Reference the correctness test** - link back to the failing test

5. **Common test patterns by bug type:**

   **For aggregation bugs (like mismatch_bfebdb3f):**
   ```go
   // Multiple rows with same label values should be one group
   // Test that groups are deduplicated by label hash, not per-row
   // Assert on number of unique groups vs total rows
   ```

   **For range aggregation bugs:**
   ```go
   // Multiple samples in time windows
   // Test count_over_time, rate, sum_over_time, etc.
   // Assert on aggregated values across time windows
   ```

   **For filter/pipeline bugs:**
   ```go
   // Build pipeline from parsed query
   // Feed representative data
   // Assert on filtered result count and values
   ```

   **For parser/extractor bugs:**
   ```go
   // Create pipeline with parser stage (json, logfmt, regex)
   // Feed lines that should be parsed
   // Assert on extracted label values
   ```

### Phase 3: Run and Verify Test Failures

1. **Run the unit test:**
   ```bash
   cd pkg/engine  # or appropriate directory
   go test -v -run TestYourBugDescription
   ```

2. **Verify it fails for the RIGHT reason:**
   - Test should FAIL (not error/panic)
   - Failure message should indicate the bug behavior
   - Failure should be because v2 produces wrong results
   - NOT because of test setup issues

3. **Expected output:**
   ```
   --- FAIL: TestAggregatorDuplicatesGroupsPerRow (0.01s)
       aggregator_test.go:123: Expected 2 groups (error, warn) but got 6 groups
       aggregator_test.go:124: Aggregator created a group per row instead of deduplicating by labels
   FAIL
   ```

4. **If test passes unexpectedly:**
   - The simplification might have removed the bug trigger
   - Add back complexity until it fails
   - Review the correctness test for what's essential

5. **If test errors (vs fails):**
   - Fix test setup issues (imports, record construction, etc.)
   - Ensure the test infrastructure is correct
   - Don't modify implementation code

6. **Compare with correctness test:**
   - Does the unit test fail for the same reason?
   - Are the magnitudes similar (e.g., both show over-counting)?
   - Does it isolate the same root cause?

### Phase 4: Document and Report

1. **Add comprehensive comments to the test:**
   ```go
   // TestAggregatorDuplicatesGroupsPerRow tests that the aggregator
   // properly deduplicates groups by label values, not creating a new
   // group for each row with the same labels.
   //
   // Root Cause: pkg/engine/internal/executor/aggregator.go lines 90-180
   // The Add() method computes grouping keys by hashing label values
   // for each row without stream-level deduplication. Each row creates
   // a new potential group instead of being merged with existing groups
   // from the same stream.
   //
   // This reproduces the bug found in correctness test:
   // pkg/logql/bench/mismatch_bfebdb3f_test.go
   //
   // Expected: 2 groups (error, warn)
   // Actual (buggy): 6 groups (one per row)
   ```

2. **Report to user:**
   - Unit test path and line number
   - Test function name
   - Confirmation that test FAILS correctly
   - Explanation of what the test proves
   - Link to correctness test
   - Next steps

   Example output:
   ```
   ✓ Analyzed correctness test: pkg/logql/bench/mismatch_bfebdb3f_test.go
   
   Correctness test shows:
   - V1: 5 entries, 230K lines processed
   - V2: 5485 entries (1097x), 39M lines processed (171x)
   - Root cause: aggregator.Add() creates groups per-row, not per-label-set
   
   ✓ Created focused unit test: pkg/engine/internal/executor/aggregator_test.go:456
   
   Test: TestAggregatorDuplicatesGroupsPerRow
   Status: FAILING (as expected)
   
   This unit test proves that the aggregator creates a new group for each
   row instead of deduplicating by label values. With 3 rows having labels
   {level="error"} and {level="warn"}, v1 creates 2 groups but v2 creates 6.
   
   The test isolates the bug to aggregator.Add() method without the complexity
   of JSON parsing, range aggregation, or full query execution.
   
   Ready for fix implementation phase with /fix-correctness-bug.
   ```

## Feedback for loki-correctness-tool

The current generated test format is excellent! It includes:
- ✓ Clear hypothesis and root cause in comments
- ✓ Original query and time range
- ✓ Expected vs actual metrics (entries, lines processed)
- ✓ Specific code locations (file:line)
- ✓ Detailed failure message in assertion

Optional improvements that could help:
- Add a "Simplified Query" comment showing minimal reproduction
- Add "Sample Data" section with example log lines (if available from real query)
- Add "Test Strategy" section suggesting unit test approach
- Include cardinality info (unique values for key labels)

## Common Pitfalls to Avoid

1. **Don't test v1 code** - Focus on `pkg/engine/`, not `pkg/logql/`
2. **Don't fix the bug** - Only write tests, resist the urge to fix implementation
3. **Don't over-simplify** - Must still trigger the bug
4. **Don't over-complicate** - Keep it minimal while exposing the bug
5. **Don't use overly complex test data** - Simplify while still exposing the bug
6. **Don't assert on wrong behavior** - Assert what SHOULD happen, not what currently happens
7. **Don't skip running the tests** - Must verify they actually fail
8. **Don't copy-paste without understanding** - Each bug is different

## Success Criteria

✓ Correctness test has been read and analyzed
✓ Correctness test has been run and failure understood
✓ Root cause and suspected locations identified
✓ Unit test is in appropriate file in `pkg/engine/`
✓ Unit test uses arrow records and real query/pipeline construction
✓ Unit test is minimal - only what's needed to expose the bug
✓ Unit test is focused - tests ONE specific behavior
✓ Unit test asserts on EXPECTED (correct) behavior
✓ Unit test FAILS when run
✓ Unit test failure matches correctness test failure reason
✓ No implementation code was modified
✓ Unit test is documented with bug reference and root cause
✓ Clear path forward for implementing the fix

## Next Steps

After this skill completes successfully:
1. Use `/fix-correctness-bug` to implement the actual fix
2. The fix should make both the correctness test and unit test pass
3. The unit test provides fast feedback during fix development
4. The correctness test validates the fix against real query scenarios
