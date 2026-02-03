# Debug Bench Test Failure

Debug a failing LogQL Correctness Test in Loki that compares chunk store vs dataobj-engine results.

## Usage

```bash
/debug-bench [CI_URL or test details]
```

## Arguments

- `CI_URL`: GitHub Actions job URL for failing TestStorageEquality
- Test details: Specific query or test case name
- No arguments: Will ask for CI URL or test details

## Instructions

Invoke the `debug-bench-test-failure` skill to execute a systematic debugging workflow for `pkg/logql/bench/bench_test.go` failures.

This skill is specialized for debugging the `TestStorageEquality` test, which compares query results between:
- **Chunk store** (legacy implementation) - the "expected" baseline
- **Dataobj-engine** (new implementation) - the "actual" result being validated

**Phase 1: Identify the Exact Failure**
- Fetch CI logs if URL provided. If necessary use the GitHub MCP or `gh` cli to fetch the logs
- If log fetching fails, ask the user to provide them
- Read bench_test.go and identify failing test case
- Examine test data structure from generator.go
- Compare branch to `main` with git diff
- Create PROBLEM_SUMMARY.md analyzing:
  - Which query is failing
  - Exact differences between chunk store and dataobj-engine results
  - Test data structure (stream labels, structured metadata, log content)
  - Expected vs actual behavior
- Present findings and get user confirmation

**Phase 2: Generate and Record Hypotheses**
- Research chunk store and dataobj-engine implementations
- Focus on common areas:
  - Query planning: `pkg/logql/engine/`
  - Pipeline construction: `pkg/logql/log/`
  - Schema handling: `pkg/dataobj/schema/`
  - Iterator differences: `pkg/dataobj/iter/` vs `pkg/storage/chunk/`
- Generate 3-5 testable hypotheses about the difference
- Document in PROBLEM_SUMMARY.md
- Present to user for feedback

**Phase 3: Test Each Hypothesis Systematically**
- Create focused unit test for each hypothesis (TDD RED state)
- Run test to validate or invalidate hypothesis
- Keep tests that prove the bug (validated hypotheses)
- Delete tests that disprove (invalidated hypotheses)
- Stop when root cause found

**Phase 3a: Add Debug Logging (if needed)**
- Add strategic logging to both engines when tests aren't conclusive
- Compare behavior between chunk store and dataobj-engine
- Clean up all debug logging when done

**Phase 4: Present Findings**
- Show root cause with evidence
- Show failing test (RED - documents bug)
- Show passing test (GREEN - proves logic works)
- Propose specific fix location in dataobj-engine

## Common Issues

This workflow helps debug typical dataobj-engine issues:
- **Schema differences**: Different column names/order but same data
- **Label handling**: Stream labels vs structured metadata representation
- **Pipeline stages**: Different execution order or missing transformations
- **Aggregation logic**: Grouping or aggregation function differences
- **Time range handling**: Boundary conditions or timestamp precision

## Output

At completion, you will have:
- **PROBLEM_SUMMARY.md**: Complete analysis comparing both engines
- **Unit test(s)**: TDD tests that document the bug and prevent regressions
- **Clean codebase**: No debug logging or invalid tests
- **Clear fix path**: Specific files/lines to change in dataobj-engine

## Examples

```bash
# Debug from CI URL
/debug-bench https://github.com/grafana/loki/actions/runs/12345/job/67890

# Debug by query name
/debug-bench TestStorageEquality/query=count_over_time

# Start investigation
/debug-bench
```

## Notes

- Focuses on semantic equivalence, not structural identity
- Chunk store is the correct baseline; dataobj-engine is being validated
- Uses systematic TDD approach (Red-Green)
- Stops testing when root cause found
- Always cleans up debug code
- Requires user confirmation before proceeding between phases
