# Debug CI Failure

Debug a failing test on CI and develop a fix using systematic hypothesis testing.

## Usage

```bash
/debug-ci [CI_URL or test name]
```

## Arguments

- `CI_URL`: GitHub Actions job URL (e.g., https://github.com/org/repo/actions/runs/123/job/456)
- Test name: Name of failing test (e.g., `TestStorageEquality`)
- No arguments: Will ask for CI URL or test details

## Instructions

Invoke the `debug-ci-failure` skill to execute a systematic debugging workflow:

**Phase 1: Identify the Exact Failure**
- Fetch CI logs if URL provided. If necessary, use the GitHub MCP or `gh` cli to fetch the logs
- If log fetching fails, ask the user to provide them manually
- Read test file and analyze failure
- Compare branch to `main` with git diff
- Create PROBLEM_SUMMARY.md with detailed problem statement
- Present findings and get user confirmation

**Phase 2: Generate and Record Hypotheses**
- Research code paths exercised by test
- Focus on changes in `git diff main...HEAD`
- Generate 2-5 testable hypotheses
- Document in PROBLEM_SUMMARY.md
- Present to user for feedback

**Phase 3: Test Each Hypothesis Systematically**
- Create focused unit test for each hypothesis (TDD RED state)
- Run test to validate or invalidate hypothesis
- Keep tests that prove the bug (validated hypotheses)
- Delete tests that disprove (invalidated hypotheses)
- Stop when root cause found

**Phase 3a: Add Debug Logging (if needed)**
- Add strategic logging when tests aren't conclusive
- Run tests to analyze behavior
- Clean up all debug logging when done

**Phase 4: Present Findings**
- Show root cause with evidence
- Show failing test (RED - documents bug)
- Show passing test (GREEN - proves logic works)
- Propose specific fix location and approach

## Output

At completion, you will have:
- **PROBLEM_SUMMARY.md**: Complete analysis with evidence
- **Unit test(s)**: TDD tests that document the bug and prevent regressions
- **Clean codebase**: No debug logging or invalid tests
- **Clear fix path**: Specific files/lines to change with confidence

## Examples

```bash
# Debug from CI URL
/debug-ci https://github.com/grafana/loki/actions/runs/12345/job/67890

# Debug by test name
/debug-ci TestQuerySharding

# Start investigation
/debug-ci
```

## Notes

- Uses systematic TDD approach (Red-Green)
- Focuses on changes in current branch vs main
- Stops testing when root cause found
- Always cleans up debug code
- Requires user confirmation before proceeding between phases
