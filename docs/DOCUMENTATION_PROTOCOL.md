# Documentation-First Completion Protocol

**Version:** 1.0
**Status:** ACTIVE
**Scope:** All projects using devops-agent-orchestra framework

## Purpose

Documentation-First Completion Protocol ensures that documentation updates occur synchronously with implementation, preventing documentation drift and maintaining project clarity.

## Core Principle

**Documentation updates must occur BEFORE marking any phase complete.**

Code commits without documentation updates = **INCOMPLETE** work.

## Why This Matters

**Problem without this protocol:**

- Documentation lags implementation by days/weeks
- Multi-day "catch-up" documentation sessions
- Code reviewers can't verify completeness
- Team members unsure of current project state
- Contradictions between docs and implementation

**Benefits of this protocol:**

- Documentation never more than 1 phase (2-3 packets) behind
- Reviewers see implementation + documentation together
- Always accurate state reflection
- Clear audit trail
- No orphaned code

## Phase Completion Flow (MANDATORY)

```yaml
phase_completion_mandatory_sequence:
  1. validate_implementation:
      description: Tests pass, code works
      owner: Implementation specialist
      blocking: yes
      
  2. update_documentation:
      description: Update docs for completed work
      owner: Documentation Agent
      blocking: yes
      status: MANDATORY GATE (cannot skip)
      duration: 2-5 minutes (incremental)
      
  3. github_sync:
      description: Commit code + docs together
      owner: Junior Developer or DevOps
      blocking: yes
      policy: atomic (code + docs in one commit)
      
  4. mark_phase_complete:
      description: Report phase as done
      owner: Orchestrator
      allowed_only_after: Steps 1-3 complete
```

**If you skip step 2, the phase is NOT complete.**

## Update Frequency Matrix

| Trigger | When | Files Updated | Duration | Type | Orchestrator Action |
|---------|------|---------------|----------|------|---------------------|
| **Per Packet** | After 1-2 packets | Skip (maintain momentum) | 0 min | N/A | Skip documentation |
| **Per Phase** | After 2-3 packets | 2-4 specific docs | 2-5 min | Incremental | **Call Documentation Agent** |
| **Per Work Stream** | After 5-8 packets | 5-8 comprehensive | 5-10 min | Consolidation | **Call Documentation Agent (extended scope)** |
| **Per Milestone** | Major completion | All docs | 15-20 min | Comprehensive audit | **Call Documentation Agent (full audit)** |

**Most common:** Per Phase updates (incremental, 2-5 min).

## Documentation Scope Guidelines

### Per Phase (Most Common)

**When:** After completing a phase (2-3 packets)

**Update these files incrementally:**

- `IMPLEMENTATION_STATUS.md` or equivalent status doc
- `CHANGELOG.md` or execution ledger
- Work stream plan or roadmap doc
- Phase-specific documentation

**Example updates:**

```markdown
## Phase 2A - Authentication Layer [DONE]

- ✅ Implemented JWT token validation
- ✅ Added rate limiting middleware
- ✅ Tests: 45/45 passing

Completion: 65% (was 60%)
```

### Per Work Stream

**When:** After completing a major work stream (5-8 packets)

**Add consolidation updates:**

- `README.md` (What's Working Today section)
- `VISION.md` or delivery plan
- Architecture docs if patterns changed

**Example updates:**

```markdown
## What's Working Today

- ✅ Authentication system with JWT + rate limiting
- ✅ User registration and login flows
- ✅ Password reset via email
```

### Per Milestone

**When:** Major milestone completion (e.g., MVP, Phase 1 complete)

**Comprehensive audit:**

- All documentation files
- Cross-reference consistency check
- Remove outdated content
- Update examples/commands
- Verify all links work

## Delegation Pattern

### Standard Phase Completion Delegation

```yaml
# Step 1: Implementation specialist validates work
assigned_to: Backend Developer (or appropriate specialist)
task: "Run tests and verify Phase 2A implementation"
success_criteria: All tests passing

# Step 2: Documentation Agent updates docs (MANDATORY)
assigned_to: Documentation Agent
task: |
  Update documentation for Phase 2A completion:
  
  Files to update:
    - docs/IMPLEMENTATION_STATUS.md
    - CHANGELOG.md
    - docs/auth-design.md
  
  Changes to document:
    - Phase 2A complete (JWT validation + rate limiting)
    - Tests: 45/45 passing
    - Update completion percentage: 65% (was 60%)
    
scope: incremental
duration_target: 2-5 minutes
depends_on: Step 1

# Step 3: GitHub sync with atomic commit
assigned_to: Junior Developer
task: |
  Commit Phase 2A implementation + documentation updates together:
  
  Implementation files:
    - src/auth/jwt.py
    - src/auth/rate_limit.py
    - tests/test_auth.py
    
  Documentation files:
    - docs/IMPLEMENTATION_STATUS.md
    - CHANGELOG.md
    - docs/auth-design.md
    
  Commit type: atomic (code + docs together)
depends_on: Step 2

# Step 4: Mark phase complete
orchestrator_action: Report phase complete with documentation_update_status: complete
```

### Using the Documentation Update Request Template

Use the `templates/documentation-update-request.yaml` template:

```yaml
documentation_update_request:
  trigger: phase_completion
  scope: incremental
  files_to_update:
    - docs/IMPLEMENTATION_STATUS.md
    - CHANGELOG.md
    - docs/project-plan.md
  changes_to_document:
    - "Phase 2A complete (3 packets delivered)"
    - "Tests: 45 passing"
    - "Completion: 65% (was 60%)"
  duration_target: 2-5 minutes
```

## Atomic Commit Policy

**NEVER commit code without documentation updates.**

### ❌ WRONG - Separate Commits

```bash
# Commit 1: Code only
git add src/feature.py tests/test_feature.py
git commit -m "feat: add feature X"

# Commit 2: Documentation only (SEPARATE - BAD!)
git add README.md CHANGELOG.md
git commit -m "docs: update for feature X"
```

**Problem:** Code merged without docs, docs might never get merged, history unclear.

### ✅ RIGHT - Atomic Commit

```bash
# Single commit with code + documentation
git add src/feature.py tests/test_feature.py README.md CHANGELOG.md
git commit -m "feat: add feature X

Implementation:
- Add feature X logic in src/feature.py
- Add comprehensive tests in tests/test_feature.py
- All 15 tests passing

Documentation:
- Update README.md with feature X usage examples
- Update CHANGELOG.md with feature X entry
- Update architecture docs with feature X design
"
```

**Benefit:** Code and docs always in sync, clear history, easy rollback.

## Checkpoint Reporting (Enhanced)

Every phase completion checkpoint MUST include documentation status.

### Standard Checkpoint Format

```yaml
phase_completion_checkpoint:
  phase: "Phase 2A - Authentication Layer"
  status: done
  
  # Implementation status
  implementation_deliverables:
    - JWT token validation
    - Rate limiting middleware
    - Auth middleware tests
  test_results: "45/45 passing"
  
  # Documentation status (MANDATORY)
  documentation_update_status: complete      # ← Required: complete|pending|blocked
  documentation_files_updated:               # ← Required: list of files
    - docs/IMPLEMENTATION_STATUS.md
    - CHANGELOG.md
    - docs/auth-design.md
  documentation_agent_duration: "3min"       # ← Required: time spent
  documentation_scope: incremental           # ← Required: incremental|consolidation|comprehensive
  
  # GitHub sync status
  github_sync_status: complete
  commit_sha: abc123def
  commit_type: atomic                        # ← Required: atomic|code_only (always use atomic)
  files_in_commit:
    implementation:
      - src/auth/jwt.py
      - src/auth/rate_limit.py
      - tests/test_auth.py
    documentation:
      - docs/IMPLEMENTATION_STATUS.md
      - CHANGELOG.md
      - docs/auth-design.md
  
  next_handoff: "Phase 2B - User Profile Management"
```

### Checkpoint Validation Rules

A phase is only **done** when:

- ✅ `status: done`
- ✅ `implementation_deliverables` all complete
- ✅ `test_results` showing passing tests
- ✅ `documentation_update_status: complete`
- ✅ `documentation_files_updated` is non-empty list
- ✅ `github_sync_status: complete`
- ✅ `commit_type: atomic`

**If any of these are `pending` or `blocked`, the phase is NOT complete.**

## Protocol Benefits (Detailed)

### 1. Eliminates Documentation Drift

**Before this protocol:**

```
Day 1: Implement features A, B, C
Day 2: Implement features D, E
Day 3: Implement features F, G, H
Day 7: Spend 4 hours updating docs (try to remember what we did)
```

**With this protocol:**

```
Phase 1 (2-3 packets): Implement A, B, C → Update docs (5 min) → Commit atomic
Phase 2 (2-3 packets): Implement D, E → Update docs (5 min) → Commit atomic
Phase 3 (2-3 packets): Implement F, G, H → Update docs (5 min) → Commit atomic
```

**Result:** Documentation never more than 1 phase behind.

### 2. Improves Code Review

**Reviewers can:**

- See implementation + documentation in one commit
- Verify feature completeness (code + docs + tests)
- Understand changes from documentation context
- Spot inconsistencies between code and docs immediately

### 3. Reduces Risk

**Prevents:**

- Orphaned code changes without docs
- Contradictions between docs and implementation
- Uncertainty about current project state
- "What does this code do?" questions

**Ensures:**

- Always know what's implemented
- Always know what's working
- Always know how to use features
- Clear rollback path (code + docs together)

## Success Metrics

Track these KPIs monthly:

| Metric | Target | Measurement | Tracks | Action If Off-Target |
|--------|--------|-------------|--------|---------------------|
| **Documentation Lag** | <1 day | Time between code commit and doc update | Drift risk | Review phase completion checklist |
| **Batch Doc Sessions** | <1/week | Large doc-only commits (>10 files) | Protocol violations | Audit commit history, retrain |
| **Documentation Accuracy** | 100% | Audit: claims match implementation | Quality | Quarterly audit, fix drift |
| **Commit Atomicity** | 100% | % commits with both code + docs | Protocol compliance | Enforce atomic commit policy |

### How to Measure

**Documentation Lag:**

```bash
# Find commits with code but no docs
git log --oneline --since="1 month ago" --name-only | grep -v "README\|CHANGELOG\|docs/"
```

**Batch Doc Sessions:**

```bash
# Find doc-only commits with >10 files
git log --oneline --since="1 month ago" --numstat | awk '/docs\/|README|CHANGELOG/ {count++} END {if(count>10) print}'
```

**Commit Atomicity:**

```bash
# Check recent commits for code+docs together
git log --oneline --since="1 week ago" --stat | grep -E "(src/|tests/)" | grep -E "(docs/|README|CHANGELOG)"
```

## Enforcement (Orchestrator Rules)

### Orchestrator MUST

- ✅ Call Documentation Agent after implementation validation (every phase)
- ✅ Wait for documentation update to complete before GitHub sync
- ✅ Never mark phase complete without `documentation_update_status: complete`
- ✅ Always report documentation status in checkpoints
- ✅ Ensure atomic commits (code + docs together)
- ✅ Block phase completion if documentation update fails

### Orchestrator MUST NOT

- ❌ Skip documentation updates "for velocity"
- ❌ Allow "will document later" or "docs TODO"
- ❌ Batch documentation across multiple phases
- ❌ Commit code without documentation
- ❌ Report phase as "done" with `documentation_update_status: pending`
- ❌ Allow separate commits for code and docs

### Orchestrator Decision Tree

```
Phase implementation complete?
  ↓
  YES → Call Documentation Agent (incremental scope)
    ↓
    Documentation update complete?
      ↓
      YES → Call GitHub sync agent (atomic commit)
        ↓
        Commit successful?
          ↓
          YES → Mark phase complete (status: done)
          NO → BLOCK phase completion (status: blocked)
      NO → BLOCK phase completion (status: blocked)
  NO → Continue implementation
```

## Quick Reference Card

**When:**

- Per Phase (most common): After 2-3 packets (2-5 min)
- Per Work Stream: After 5-8 packets (5-10 min)
- Per Milestone: Major completions (15-20 min)

**What to update:**

- Phase: Status doc, CHANGELOG, plan doc (2-4 files)
- Work Stream: + README, VISION, architecture (5-8 files)
- Milestone: All docs, audit, cleanup (comprehensive)

**How:**

1. ✅ Validate implementation (tests pass)
2. ✅ Call Documentation Agent (incremental scope)
3. ✅ GitHub sync (atomic: code + docs together)
4. ✅ Mark phase complete

**Never:**

- ❌ Skip documentation "for velocity"
- ❌ Separate code and doc commits
- ❌ Mark phase done without docs
- ❌ Allow "docs TODO"

**Checkpoint must include:**

- `documentation_update_status: complete`
- `documentation_files_updated: [list]`
- `commit_type: atomic`

## Template Reference

See `templates/documentation-update-request.yaml` for standard delegation template.

## Related Documentation

- [prompts/orchestrator.md](../prompts/orchestrator.md) - Orchestrator agent prompt (includes protocol enforcement)
- [docs/WORKFLOW.md](WORKFLOW.md) - Overall workflow documentation
- [templates/documentation-update-request.yaml](../templates/documentation-update-request.yaml) - Documentation update request template

## Changelog

- **2026-02-19:** Initial version - Documentation-First Completion Protocol v1.0
