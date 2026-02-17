# Error Recovery Procedures

**Purpose:** Standard recovery workflows for implementation agents when errors occur.  
**Last Updated:** 2026-02-17  
**Related:** [VALIDATION_RUNBOOK.md](./VALIDATION_RUNBOOK.md), [TOOL_REFERENCE.md](./TOOL_REFERENCE.md)

---

## Quick Reference

| Error Type | Retry Yourself | Escalate To |
| ---------- | -------------- | ----------- |
| Typo / Syntax Error | ✅ Yes | - |
| Missing Import | ✅ Yes | - |
| Failed Test (simple) | ✅ Yes | - |
| Failed Build (complex) | ❌ No | Senior Agent |
| Architecture Issue | ❌ No | Orchestrator |
| Dependency Conflict | ⚠️ Try Once | Senior Agent |
| Security Concern | ❌ No | Orchestrator |

---

## Procedure 1: Failed File Edit

**Scenario:** Edit resulted in syntax error or broke existing functionality.

**Recovery Steps:**

1. Check git status: `git status`
2. If uncommitted: `git restore <file>`
3. If committed but not pushed: `git revert HEAD`
4. Re-attempt edit with corrected approach
5. If still failing: Report blocker with recovery steps taken

**When to Escalate:**

- 2+ failed attempts to fix same issue
- Issue requires architecture change
- Uncertain about correct fix approach

---

## Procedure 2: Failed Build or Test

**Scenario:** Validation commands fail after your changes.

**Recovery Steps:**

1. Capture full error output
2. **Retry Criteria (attempt minimal fix):**
   - Typo in variable/function name
   - Missing import statement
   - Simple type mismatch
3. **Escalation Criteria (do NOT attempt fix):**
   - Error involves multiple files you didn't touch
   - Requires refactoring existing architecture
   - Security-related failure (auth, XSS, SQL injection)
   - Affects core system behavior

**Example - Retry:**

```text
Error: Cannot find name 'UserServce'
Fix: Correct typo to 'UserService'
```

**Example - Escalate:**

```text
Error: Build exceeds memory limit (heap out of memory)
Escalate: Requires optimization strategy, not a quick fix
```

---

## Procedure 3: Dependency Conflict

**Scenario:** Package installation fails or version conflicts arise.

**Recovery Steps:**

1. Run diagnostic: `npm list` (or `pip list`, `go list`, etc.)
2. Attempt lock file regeneration: `npm install` (or `pip install -r requirements.txt`)
3. If unresolvable after one attempt: Report blocker with dependency tree output
4. DO NOT attempt manual package.json / requirements.txt version changes without explicit user approval

**When to Escalate:**

- Conflict involves more than 2 packages
- Requires significant version downgrades
- Breaks compatibility with other project dependencies

---

## Procedure 4: Merge Conflict

**Scenario:** Branch has conflicts with main/target branch.

**Recovery Steps:**

1. DO NOT attempt to resolve merge conflicts yourself unless explicitly requested
2. Report conflict details to Orchestrator:
   - Conflicting files
   - Conflict markers count
   - Suggested resolution strategy (if simple)
3. Wait for user or Orchestrator guidance

**Exception:** Simple whitespace or formatting conflicts in files you authored may be resolved if confident.

---

## Escalation Protocol

**When to Escalate vs. Retry:**

### ✅ Retry Yourself (1-2 attempts max)

- Typos in your own code
- Missing imports for code you just wrote
- Simple syntax errors (missing semicolon, bracket, etc.)
- Test failures due to incorrect mock data

### ❌ Escalate Immediately

- Architecture refactoring needed
- Security vulnerabilities detected
- Cross-service or multi-file cascading failures
- User data integrity concerns
- Performance issues requiring profiling
- Third-party API integration failures

---

## Escalation Message Template

```yaml
decision: blocked
issues:
  - "Build fails with heap out of memory error after adding image processing"
  - "Attempted minimal fix: reduced image size in test fixtures - still fails"
  - "Root cause: Likely architectural - requires streaming or chunking strategy"
recovery_attempts:
  - "Reverted changes: git restore src/image-processor.ts"
  - "Re-attempted with smaller buffer: still fails"
recommended_escalation: senior-fullstack-developer
touched_files:
  - src/image-processor.ts
next_action: handoff_to_orchestrator
confidence: low
```

---

## Git Recovery Commands

**Undo uncommitted changes:**

```bash
git restore <file>              # Single file
git restore .                   # All files
```

**Undo last commit (not pushed):**

```bash
git reset --soft HEAD~1         # Keep changes staged
git reset --hard HEAD~1         # Discard changes entirely
```

**Undo pushed commit:**

```bash
git revert HEAD                 # Creates new commit undoing last one
```

**Stash and recover work:**

```bash
git stash                       # Save current work
git stash pop                   # Restore stashed work
```

---

## References

- See [VALIDATION_RUNBOOK.md](./VALIDATION_RUNBOOK.md) for standard validation commands
- See [templates/AGENTS.md](../templates/AGENTS.md) for agent-specific escalation paths
- See [docs/ARCHITECTURE.md](./ARCHITECTURE.md) for agent roster and specializations
