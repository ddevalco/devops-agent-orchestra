# Validation Runbook

**Purpose:** Standard validation commands and requirements for all implementation agents.  
**Last Updated:** 2026-02-17  
**Related:** [RECOVERY_RUNBOOK.md](./RECOVERY_RUNBOOK.md), [TOOL_REFERENCE.md](./TOOL_REFERENCE.md)

---

## Agent Requirements

**MANDATORY:** All implementation agents (Junior, Frontend, Backend, Fullstack, Senior variants, Mobile, Data Engineer) MUST run relevant validation checks before `handoff_to_reviewer`.

Validation failures must be addressed before review handoff. If unable to fix, escalate to Orchestrator with blocker details.

---

## Standard Commands by Project Type

### Node.js / TypeScript

**Minimal Validation (Always Run):**

```bash
npm run lint            # Code style and quality
npm run type-check      # TypeScript type validation
```

**Broader Validation (When Applicable):**

```bash
npm test                # Unit and integration tests
npm run build           # Production build verification
```

**Full Pre-Merge Validation:**

```bash
npm run lint && npm run type-check && npm test && npm run build
```

### Python

**Minimal Validation:**

```bash
ruff check .            # Linting
mypy .                  # Type checking
```

**Broader Validation:**

```bash
pytest                  # Test suite
pytest --cov            # Test with coverage
```

### Go

**Minimal Validation:**

```bash
go fmt ./...            # Format check
go vet ./...            # Static analysis
```

**Broader Validation:**

```bash
go test ./...           # Test suite
go build ./...          # Build verification
```

### Swift / iOS (Xcode Projects)

**Minimal Validation:**

```bash
xcodebuild -scheme <SchemeName> clean build
```

**Broader Validation:**

```bash
xcodebuild test -scheme <SchemeName> -destination 'platform=iOS Simulator,name=iPhone 14'
```

---

## Markdown Documentation

**For any repository with .md files**

### Standard Check

```bash
# Check all markdown files
npx markdownlint-cli2 "**/*.md" "!node_modules"

# Expected: Summary: 0 error(s)
```

### Auto-Fix

```bash
# Fix auto-correctable issues
npx markdownlint-cli2 "**/*.md" "!node_modules" --fix

# Verify
npx markdownlint-cli2 "**/*.md" "!node_modules"
```

### Common Manual Fixes

```bash
# MD029: Fix ordered list numbering (start at 1)
# MD003: Convert setext headings to ATX style (## Heading)
```

**Pass Criteria:** `Summary: 0 error(s)`

---

## Validation Workflow

1. **Identify Project Type:** Check for package.json, requirements.txt, go.mod, .xcodeproj
2. **Run Minimal Validation:** Execute relevant commands from above
3. **Capture Output:** Include command results in output YAML under `validation:` field
4. **Handle Failures:**
   - **Fixable (typos, imports):** Fix and re-validate
   - **Complex (architecture):** Escalate to senior agent or Orchestrator
5. **Report to Reviewer:** Include all validation results in handoff

---

## Output Contract Extension

```yaml
validation:
  - check: npm run lint
    result: pass
  - check: npm run type-check
    result: pass  
  - check: npm test
    result: fail
    error: "2 tests failed in auth.spec.ts"
```

---

## Common Issues

**Issue:** "Command not found"  
**Solution:** Check project root, verify package.json scripts section

**Issue:** "No tests found"  
**Solution:** Acceptable if project has no test suite; document in validation result: `result: not-applicable`

**Issue:** "Validation takes too long"  
**Solution:** Run minimal validation only; document broader validation as post-merge action

---

## References

- See [RECOVERY_RUNBOOK.md](./RECOVERY_RUNBOOK.md) for handling validation failures
- See [templates/AGENTS.md](../templates/AGENTS.md) for agent-specific validation requirements
