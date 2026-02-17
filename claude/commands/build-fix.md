# Build and Fix

Incrementally fix build errors:

1. Run build:
  - for go projects this is `go build`
  - for projects using yarn this is `yarn build`
  - for projects using npm this is `npm run build`
  - if none of these apply try to infer the correct build and lint commands, or ask for clarification 

2. Parse error output:
   - Group by file
   - Sort by severity

3. For each error:
   - Show error context (5 lines before/after)
   - Explain the issue
   - Propose fix
   - Apply fix
   - Re-run build
   - Verify error resolved

4. Stop if:
   - Fix introduces new errors
   - Same error persists after 3 attempts
   - User requests pause

5. Show summary:
   - Errors fixed
   - Errors remaining
   - New errors introduced

Fix one error at a time for safety!
