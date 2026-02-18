# Improvement Backlog

**Generated:** February 17, 2026  
**Priority Framework:** Impact on Autonomy × Concurrency × Traceability  
**Related:** [TOOL_CAPABILITY_MATRIX.md](./TOOL_CAPABILITY_MATRIX.md), [PROMPT_AUDIT.md](./PROMPT_AUDIT.md)

---

## Executive Summary

This backlog prioritizes 10 improvements ranked by their impact on:

- **Autonomy:** Can agents complete responsibilities without coordination?
- **Concurrency:** Can work proceed in parallel?
- **Traceability:** Can operators understand what happened?

**Quick Stats:**
- 🚨 **3 Critical blockers** (Must fix before production scale)
- ⚠️ **3 High-priority issues** (Impact reliability)
- 📋 **4 Medium-priority issues** (Technical debt)

---

## Priority Matrix

| ID | Issue | Autonomy | Concurrency | Traceability | **Total Score** | Priority |
|----|-------|----------|-------------|--------------|-----------------|----------|
| **P1** | Documentation Agent Missing Sub-Delegation | 🔴 10 | 🟡 6 | 🟢 2 | **18** | 🚨 Critical |
| **P2** | Tool Schema Fragmentation | 🔴 9 | 🟢 3 | 🔴 8 | **20** | 🚨 Critical |
| **P3** | Native Kickoff Ghost Agent | 🟡 5 | 🟢 1 | 🔴 9 | **15** | 🚨 Critical |
| **P4** | Planner Tool/Role Mismatch | 🟡 7 | 🟢 2 | 🟡 6 | **15** | ⚠️ High |
| **P5** | Junior Developer Over-Privileged | 🟡 6 | 🟢 3 | 🟡 5 | **14** | ⚠️ High |
| **P6** | Prompt Writer Cannot Write Files | 🟡 7 | 🟢 2 | 🟢 3 | **12** | ⚠️ High |
| **P7** | Handoff Token Inconsistencies | 🟢 4 | 🟢 2 | 🟡 6 | **12** | 📋 Medium |
| **P8** | Memory Tool Stability | 🟢 4 | 🟢 1 | 🟡 5 | **10** | 📋 Medium |
| **P9** | No Testing/Validation Tool | 🟢 3 | 🟢 3 | 🟡 5 | **11** | 📋 Medium |
| **P10** | No Rollback/Recovery Tools | 🟡 6 | 🟢 1 | 🟡 4 | **11** | 📋 Medium |

**Scoring:** 🔴 High Impact (7-10) | 🟡 Medium Impact (4-6) | 🟢 Low Impact (1-3)

---

## 🚨 Critical Blockers (Must Fix Before Production Scale)

### P1: Documentation Agent Missing Sub-Delegation

**Issue:** Documentation Agent lacks `agent` tool - cannot delegate complex tasks.

**Impact Analysis:**
- **Autonomy (10/10):** 🔴 Must implement everything itself or fail completely
- **Concurrency (6/10):** 🟡 Blocks parallel work when touching shared files (README, CHANGELOG)
- **Traceability (2/10):** 🟢 Low - doesn't affect observability

**Symptoms:**
- Cannot get help analyzing architecture for docs
- Cannot delegate diagram generation
- Must manually implement all documentation changes
- Single point of failure for all doc workflows

**Recommended Fix:**

1. **Add `agent` tool to [documentation-agent.md](../prompts/documentation-agent.md) frontmatter:**

   ```yaml
   tools: ['read/readFile', 'edit', 'terminal', 'git', 'agent']
   ```

2. **Add delegation guidance to prompt body:**

   ```markdown
   ## Sub-Delegation

   When documentation requires:
   - Complex architecture analysis → Delegate to Senior Fullstack Developer
   - Diagram generation → Delegate to Designer
   - Code snippet extraction → Delegate to Junior Developer

   Use `runSubagent` with clear context and expected deliverable format.
   ```

**Effort:** 1-2 hours  
**Dependencies:** None  
**Testing:** Assign Documentation Agent a complex task requiring architecture analysis

---

### P2: Tool Schema Fragmentation

**Issue:** 2 incompatible tool naming conventions in production (Orchestrator + Documentation Agent use specific names, all others use aggregate `vscode` schema).

**Impact Analysis:**
- **Autonomy (9/10):** 🔴 Agents unclear what tools they have access to
- **Concurrency (3/10):** 🟢 Low - doesn't block parallel execution
- **Traceability (8/10):** 🔴 High - debugging which tool failed is ambiguous

**Symptoms:**
- Orchestrator uses `read/readFile`, developers use `read` - semantic difference unknown
- Documentation Agent uses `terminal`, developers use `execute` - assumed equivalent?
- No documentation explaining `vscode` aggregate scope

**Recommended Fix:**

**Phase 1: Standardization (Week 1)**

1. **Choose Convention B** (majority pattern - 18 agents already use it):

   ```yaml
   tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo', 'vscode/memory', 'memory']
   ```

2. **Update Orchestrator frontmatter:**

   ```yaml
   # Before
   tools: ['read/readFile', 'agent', 'vscode/memory', 'memory']

   # After
   tools: ['read', 'agent', 'vscode/memory', 'memory']
   ```

3. **Update Documentation Agent frontmatter:**

   ```yaml
   # Before
   tools: ['read/readFile', 'edit', 'terminal', 'git']

   # After
   tools: ['read', 'edit', 'execute', 'agent', 'vscode/memory', 'memory']
   ```

**Phase 2: Documentation (Week 2)**

4. **Create `docs/TOOL_REFERENCE.md`:**

   - Define each tool's capabilities
   - Document `vscode` aggregate scope
   - Explain when to use `execute` vs. when to delegate
   - Provide examples for each tool

**Effort:** 4-6 hours  
**Dependencies:** None (but coordinate with P1 for Documentation Agent)  
**Testing:** Run full orchestration workflow, verify no tool errors

---

### P3: Native Kickoff Ghost Agent ✅ COMPLETED

**Status:** RESOLVED - File deleted, all references removed (v0.4.0)

**Issue:** `native-orchestrator-kickoff.md` existed but had no frontmatter, no documented purpose, not in orchestration flows.

**Impact Analysis:**
- **Autonomy (5/10):** 🟡 Moderate - confuses roster, unclear when to use
- **Concurrency (1/10):** 🟢 Low - doesn't affect parallelization
- **Traceability (9/10):** 🔴 High - breaks roster audits, onboarding friction

**Previous Symptoms:**
- Appeared in PROMPT_AUDIT.md as "Undocumented Agent"
- No references in README.md orchestration flows
- Broke tooling that parses frontmatter

**Resolution Applied:** Option B - File Removed

1. ✅ Deleted `prompts/native-orchestrator-kickoff.md`
2. ✅ Removed all references in documentation
3. ✅ Updated PROMPT_AUDIT.md
4. ✅ Verified orchestration workflows operate correctly

**Completed:** February 17, 2026 (v0.4.0)  
**Validation:** E2E test passed with 18-agent roster

---

## ⚠️ High-Priority Issues (Impact Deployment Reliability)

### P4: Planner Tool/Role Mismatch

**Issue:** Planner has `execute` tool but prompt body forbids writing code ("You create plans. You do NOT write code").

**Impact Analysis:**
- **Autonomy (7/10):** 🟡 Confusing capability surface - unclear when to use execute
- **Concurrency (2/10):** 🟢 Low impact
- **Traceability (6/10):** 🟡 Moderate - debugging failures unclear if tool misuse

**Symptoms:**
- Tool/role contract mismatch
- Planner could theoretically violate prompt by executing code
- Unclear if `execute` intended for validation checks only

**Recommended Fix:**

**Phase 1: Clarify Intent (Week 1)**

1. **If `execute` is for validation only** (e.g., running `npm list` to check dependencies):

   Update prompt body:

   ```markdown
   ## Tool Usage
   - `execute`: ONLY for read-only validation checks (npm list, file existence, etc.)
   - DO NOT write code, commit changes, or modify state
   ```

2. **If `execute` is not needed:**

   Remove from frontmatter:

   ```yaml
   # Before
   tools: ['vscode', 'execute', 'read', 'agent', ...]

   # After
   tools: ['vscode', 'read', 'agent', ...]
   ```

**Effort:** 1 hour  
**Dependencies:** User clarification on use case  
**Testing:** Verify Planner workflows operate correctly

---

### P5: Junior Developer Over-Privileged

**Issue:** Junior Developer has identical toolset to Senior Fullstack Developer - no technical guardrails enforcing complexity routing.

**Impact Analysis:**
- **Autonomy (6/10):** 🟡 Moderate - cannot enforce routing via tooling
- **Concurrency (3/10):** 🟢 Low impact
- **Traceability (5/10):** 🟡 Moderate - unclear why junior/senior distinction exists

**Symptoms:**
- Work routing relies purely on Orchestrator judgment
- No technical enforcement of "escalate complex tasks"
- Identical tool access: `vscode`, `execute`, `read`, `edit`, `search`, `web`, `agent`, `todo`

**Recommended Fix:**

**Option A: Tool Restrictions (Preferred)**

1. Remove tools Junior shouldn't use:

   ```yaml
   # Junior Developer (restricted)
   tools: ['vscode', 'read', 'edit', 'agent', 'todo', 'vscode/memory', 'memory']
   # Removed: execute, search, web

   # Senior Fullstack (full access)
   tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo', 'vscode/memory', 'memory']
   ```

2. Update Junior Developer prompt body to clarify when to escalate.

**Option B: Explicit Escalation Triggers (If tool restrictions too limiting)**

Add to Junior Developer prompt:

```markdown
## Mandatory Escalation Triggers

Immediately escalate to Senior Fullstack via `runSubagent` if task involves:
- Distributed systems or multi-service integrations
- Security-sensitive auth/permissions logic
- Performance-critical optimizations
- Architecture redesign proposals

Do NOT attempt these yourself.
```

**Effort:** 2-3 hours  
**Dependencies:** User decision on tool restrictions  
**Testing:** Verify Junior Developer can still complete lightweight tasks

---

### P6: Prompt Writer Cannot Write Files

**Issue:** Prompt Writer has `agent` tool but no `edit` - must delegate to create prompt files.

**Impact Analysis:**
- **Autonomy (7/10):** 🟡 High - extra coordination overhead for simple file writes
- **Concurrency (2/10):** 🟢 Low impact
- **Traceability (3/10):** 🟢 Low impact

**Symptoms:**
- Prompt Writer creates prompt text but cannot save it
- Must delegate to Junior Developer or Executor to write file
- Two-step workflow for simple task

**Recommended Fix:**

**Option A: Add `edit` Tool (Preferred)**

```yaml
# Before
tools: ['vscode', 'read', 'search', 'web', 'agent', 'todo', 'vscode/memory', 'memory']

# After
tools: ['vscode', 'read', 'edit', 'search', 'web', 'agent', 'todo', 'vscode/memory', 'memory']
```

**Option B: Document Delegation Pattern**

If keeping Prompt Writer read-only by design:

```markdown
## Deliverable Workflow

1. Craft prompt in output YAML under `prompt:` field
2. Set `next_action: handoff_to_junior_developer` with instruction:
   "Create file at `prompts/[name].md` with the prompt text provided in deliverable"
```

**Effort:** 30 minutes  
**Dependencies:** None  
**Testing:** Assign Prompt Writer task to create a new agent prompt

---

## 📋 Medium-Priority Issues (Technical Debt)

### P7: Handoff Token Inconsistencies

**Issue:** Some agents use `handoff_to_frontend`, others use `handoff_to_orchestrator` - Orchestrator may misparse completion signals.

**Impact Analysis:**
- **Autonomy (4/10):** 🟢 Low - doesn't block work
- **Concurrency (2/10):** 🟢 Low impact
- **Traceability (6/10):** 🟡 Moderate - coordinationreliability affected

**Documented in:** [PROMPT_AUDIT.md](./PROMPT_AUDIT.md) Section 4

**Recommended Fix:**

1. **Standardize on:** `next_action: handoff_to_orchestrator` for ALL completion paths

2. **Update affected agents:**
   - Designer: Remove `handoff_to_frontend`, always return to Orchestrator
   - Clarifier: Ensure `handoff_to_planner` only used when explicitly routing

3. **Document in AGENTS.md template:**

   ```markdown
   ## Output Contract

   Always use `next_action: handoff_to_orchestrator` upon task completion.
   Do NOT use horizontal handoffs like `handoff_to_frontend` - let Orchestrator route.
   ```

**Effort:** 2-3 hours  
**Dependencies:** None  
**Testing:** Run orchestration workflow, verify Orchestrator correctly interprets all handoffs

---

### P8: Memory Tool Stability

**Issue:** Prompts note `vscode/memory` is "experimental in some builds" - non-deterministic availability.

**Impact Analysis:**
- **Autonomy (4/10):** 🟢 Low - agents function without memory
- **Concurrency (1/10):** 🟢 Low impact
- **Traceability (5/10):** 🟡 Moderate - learning persistence inconsistent

**Symptoms:**
- Some VS Code builds have memory, others don't
- No documented fallback behavior
- Agents may attempt to use unavailable tool

**Recommended Fix:**

1. **Add to all agent prompts:**

   ```markdown
   ## Memory Tool (Experimental)

   If `vscode/memory` is unavailable in your environment:
   - Continue operation without memory storage
   - Document key learnings in output YAML under `learnings:` field
   - Orchestrator will aggregate learnings manually
   ```

2. **Update Orchestrator to handle missing memory:**

   ```markdown
   ## Memory Fallback

   If agents report learnings in output (instead of storing in memory):
   - Aggregate in working notes
   - Summarize in final report under "Operational Learnings"
   ```

**Effort:** 1-2 hours  
**Dependencies:** None  
**Testing:** Test on VS Code build without memory tool

---

### P9: No Testing/Validation Tool

**Issue:** Agents have `execute` but no explicit test framework awareness - validation steps ad-hoc.

**Impact Analysis:**
- **Autonomy (3/10):** 🟢 Low - agents can still run tests manually
- **Concurrency (3/10):** 🟢 Low impact
- **Traceability (5/10):** 🟡 Moderate - inconsistent validation patterns

**Symptoms:**
- Validation steps vary by agent (sometimes missing)
- No standard test command documented
- Regression risk increased

**Recommended Fix:**

1. **Create `docs/VALIDATION_RUNBOOK.md`:**

   ```markdown
   # Validation Runbook

   ## Standard Commands by Project Type

   ### Node.js/TypeScript
   - Lint: `npm run lint`
   - Type Check: `npm run type-check`
   - Tests: `npm test`
   - Build: `npm run build`

   ### Python
   - Lint: `ruff check .`
   - Type Check: `mypy .`
   - Tests: `pytest`

   ## Agent Requirements

   All implementation agents MUST run relevant validation before `handoff_to_reviewer`.
   ```

2. **Update AGENTS.md template to reference this runbook**

**Effort:** 2-3 hours  
**Dependencies:** Survey projects in workspace for common test patterns  
**Testing:** Verify agents can find and use runbook

---

### P10: No Rollback/Recovery Tools

**Issue:** No documented git rollback or error recovery procedures - agents cannot autonomously recover from failures.

**Impact Analysis:**
- **Autonomy (6/10):** 🟡 Moderate - must escalate all failures
- **Concurrency (1/10):** 🟢 Low impact
- **Traceability (4/10):** 🟢 Low impact

**Symptoms:**
- Failed changes require manual intervention
- No documented recovery workflow
- Agents cannot self-heal

**Recommended Fix:**

1. **Create `docs/RECOVERY_RUNBOOK.md`:**

   ```markdown
   # Error Recovery Procedures

   ## Failed File Edit

   1. Check git status: `git status`
   2. If uncommitted: `git restore <file>`
   3. If committed: `git revert HEAD`
   4. Report blocker with recovery steps taken

   ## Failed Build/Test

   1. Capture full error output
   2. Attempt minimal fix (typo, import, etc.)
   3. If complex: Report blocker, suggest rollback
   4. Do NOT attempt architecture changes to fix

   ## Dependency Conflict

   1. Run `npm list` or equivalent to diagnose
   2. Attempt lock file regeneration: `npm install`
   3. If unresolvable: Report blocker with dependency tree

   ## When to Escalate vs. Retry

   - **Retry:** Typos, missing imports, simple syntax
   - **Escalate:** Architecture issues, security concerns, multi-service failures
   ```

2. **Update all implementation agent prompts to reference this runbook**

**Effort:** 2-3 hours  
**Dependencies:** None  
**Testing:** Simulate failure scenario, verify agent follows recovery procedure

---

## Implementation Roadmap

### Week 1 (Critical Blockers)
- [ ] **P1:** Add `agent` tool to Documentation Agent (1-2h)
- [ ] **P2 Phase 1:** Standardize tool schema (4-6h)
- [ ] **P3:** Resolve Native Kickoff agent (1-2h)

**Checkpoint:** Run full orchestration workflow, verify no tool errors.

### Week 2-3 (High-Priority)
- [ ] **P4:** Fix Planner tool/role mismatch (1h)
- [ ] **P5:** Add Junior Developer guardrails (2-3h)
- [ ] **P6:** Enable Prompt Writer file editing (30m)
- [ ] **P2 Phase 2:** Create TOOL_REFERENCE.md (2-3h)

**Checkpoint:** Verify agents respect tool boundaries, routing works correctly.

### Month 2 (Medium-Priority Technical Debt)
- [ ] **P7:** Standardize handoff tokens (2-3h)
- [ ] **P8:** Document memory fallback (1-2h)
- [ ] **P9:** Create validation runbook (2-3h)
- [ ] **P10:** Create recovery runbook (2-3h)

**Checkpoint:** Full regression test across all agent workflows.

---

## Success Metrics

### Autonomy
- **Before:** Documentation Agent must fail or implement complex tasks solo
- **After:** Documentation Agent delegates analysis to specialists, completes 90%+ of tasks

### Concurrency
- **Before:** Tool ambiguity causes false file conflicts
- **After:** Clear tool contracts enable parallel execution when files disjoint

### Traceability
- **Before:** Tool failures ambiguous (was it `read` or `read/readFile`?)
- **After:** Standardized tool names, clear error attribution

---

## Risk Assessment

| Improvement | Implementation Risk | Rollback Difficulty |
|-------------|---------------------|---------------------|
| P1 | 🟢 Low (additive only) | 🟢 Easy (remove tool) |
| P2 | 🟡 Medium (touches all agents) | 🟡 Medium (revert frontmatter) |
| P3 | 🟢 Low (delete or document) | 🟢 Easy (restore file) |
| P4 | 🟢 Low (remove or document) | 🟢 Easy (revert frontmatter) |
| P5 | 🟡 Medium (may break workflows) | 🟡 Medium (restore tools) |
| P6 | 🟢 Low (additive only) | 🟢 Easy (remove tool) |
| P7 | 🟢 Low (doc + prompt edits) | 🟢 Easy (revert tokens) |
| P8 | 🟢 Low (doc only) | N/A |
| P9 | 🟢 Low (doc only) | N/A |
| P10 | 🟢 Low (doc only) | N/A |

---

## Open Questions

1. **P3 (Native Kickoff):** Original intent for this agent? Delete or document?
2. **P4 (Planner execute):** Is `execute` for validation checks? Or legacy artifact?
3. **P5 (Junior restrictions):** Tool restrictions or prompt-based guardrails?
4. **P2 (vscode aggregate):** Full scope documentation of what `vscode` includes?

**Next Step:** Prioritize Week 1 critical blockers, assign owners, schedule implementation.
