# Verification Command

Run comprehensive verification on current codebase state.

## Instructions

Execute verification in this exact order:

1. **Build Check**
   - Run the build command for this project
   - If it fails, report errors and STOP

2. **Type Check**
   - Run TypeScript/type checker if applicable to project language
   - Report all errors with file:line if applicable to project language

3. **Format Check**
   - Run formatter if applicable to project
   - Report warnings and errors
   
4. **Lint Check**
   - Run linter
   - Report warnings and errors

5. **Test Suite**
   - Run all tests
   - Report pass/fail count
   - Report coverage percentage

6. **Git Status**
   - Show uncommitted changes
   - Show files modified since last commit

## Output

Produce a concise verification report:

```
VERIFICATION: [PASS/FAIL]

Build:    [OK/FAIL]
Types:    [OK/X errors]
Lint:     [OK/X issues]
Tests:    [X/Y passed, Z% coverage]
Secrets:  [OK/X found]

Ready for PR: [YES/NO]
```

If any critical issues, list them with fix suggestions.

## Arguments

$ARGUMENTS can be:
- `quick` - Only build + types
- `full` - All checks (default)
- `pre-commit` - Checks relevant for commits
- `pre-pr` - Full checks plus security scan

## Makefile

If the project has a Makefile, tasks may be defined as targets, for example:

```
.PHONY: build
build:

.PHONY: test
test:

.PHONY: format
format:
```

Look for these as they will know how to execute these specific steps for this project and language.
