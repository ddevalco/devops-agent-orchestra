# Agent Operating Rules

This file defines project-specific constraints and protocols for human and agent contributors.

## Project Context

- **Project Name:** [Your Project Name]
- **Primary Branch:** main
- **Repository:** [GitHub URL]
- **Issue Tracker:** [GitHub Issues URL]

## Pre-Work Safety Checklist

**Before ANY work:**

- [ ] Never create `.agent-local/`, `.vscode-agent-orchestration/`, or similar workspace directories in the repository
- [ ] Use `/tmp/` or in-memory structures for tracking/coordination

## Planning & GitHub Tracking Protocol (MANDATORY)

**For all non-trivial work (features, phases, multi-file changes):**

1. **Create Plan Document:**
   - Create `docs/<FEATURE_NAME>_PLAN.md` with:
     - Executive summary
     - Architecture changes
     - Step-by-step implementation packets (P\<N\>-01, P\<N\>-02, etc.)
     - Critical path and dependencies
     - Acceptance criteria per packet
   - Get plan approved before implementation begins

2. **Create GitHub Epic & Child Issues:**
   - Epic issue tracks overall feature/phase
   - Child issues map 1:1 to implementation packets
   - Include acceptance criteria in each issue
   - Label appropriately (epic, epic-child, area:*, priority:P*)

3. **Link Everything:**
   - Plan document references epic issue number
   - Epic issue references plan document path
   - Child issues reference epic parent
   - Commits reference issue numbers

4. **Update Tracking:**
   - Update BACKLOG.md when work completes
   - Update CHANGELOG.md for user-facing changes
   - Close issues when verified complete

**Exemptions:**

- Hot fixes under 10 lines
- Documentation-only updates
- Repo-specific AGENTS.md may override this protocol

**Enforcement:**

- Orchestrator MUST invoke Planner for non-trivial work
- Planner output MUST include GitHub issue structure
- DevOps creates issues before implementation begins

## Document Creation & Validation Protocol

**Before committing any markdown document:**

### Rule: All Markdown Must Pass Validation

**Agents with terminal access** (Frontend Dev, Backend Dev, DevOps, Documentation Agent):

1. Create the document
2. Run validation: `npx markdownlint <file>` or `bunx markdownlint <file>`
3. Fix all errors before committing
4. Include validation evidence in commit message

**Agents without terminal access** (Junior Developer):

1. Create the document
2. **MANDATORY:** Hand off to an agent with terminal access for validation
3. Do NOT commit until validation confirmed
4. Document must show "0 errors" before commit

### Handoff Pattern for Junior Developer

When Junior Developer creates markdown:

```yaml
task: Create <document_name>.md
status: created_pending_validation
next_action: handoff_to_documentation_agent_or_frontend_dev
reason: Junior Developer lacks terminal tools for markdownlint validation
validation_required: true
```

### Validation Command Reference

```bash
# Single file
npx markdownlint path/to/file.md

# Directory
npx markdownlint docs/

# With auto-fix (use cautiously)
npx markdownlint --fix path/to/file.md
```

### Enforcement

- **Orchestrator:** When delegating document creation to Junior Dev, must also delegate validation to another agent
- **Junior Developer:** Must explicitly state "pending validation" and hand off
- **Reviewers:** Reject PRs with markdown lint errors

### Why This Matters

- Prevents lint errors in repository
- Maintains documentation quality standards
- Catches formatting issues before commit
- Reduces cleanup work and back-and-forth

## Command Execution Best Practices

**For agents with terminal access (DevOps, Backend Dev, Frontend Dev, etc.):**

### Prefer Fast Commands Over Slow Commands

When executing terminal commands:

- Use `--limit`, `head`, `tail` to bound output
- Avoid commands that wait for external events (CI completion, network responses)
- Use `--json` output for structured parsing instead of watching spinners
- Add timeouts where available (e.g., `timeout 5s <command>`)

### Known Slow Commands to Avoid (or bound)

**GitHub CLI:**

```bash
# BAD - waits for CI indefinitely
gh pr checks --watch 123

# GOOD - get instant status
gh pr checks 123
gh pr view 123 --json statusCheckRollup

# BAD - waits for run to complete
gh run watch <run-id>

# GOOD - get instant status and rerun separately
gh run view <run-id>
gh run rerun --failed <run-id>  # triggers async rerun
```

**Git Operations:**

```bash
# BAD - interactive prompt
git commit

# GOOD - non-interactive
git commit -m "message"

# BAD - fetch without timeout
git fetch

# GOOD - fetch with timeout
timeout 10s git fetch || echo "fetch timeout"
```

**Build/Test Commands:**

```bash
# BAD - wait for all tests
npm test

# GOOD - run specific test or with timeout
timeout 30s npm test -- --testNamePattern="specific"

# BETTER - check if already passing, skip if so
npm run type-check  # usually fast
```

### Report Partial Results

If a command hangs or takes too long:

1. STOP the operation (Ctrl+C or timeout)
2. Report what you learned before it hung
3. Suggest alternative approach
4. Don't retry the same slow command

### Background Operations

For truly long-running operations (CI runs, deployments):

```bash
# Trigger operation asynchronously
gh run rerun --failed <run-id>

# Report: "CI rerun triggered, check status at <url>"
# Don't wait for completion inline
```

### Time Expectations

**Instant (<1s):** git status, gh pr view, file reads

**Fast (<5s):** type-check, git operations, gh issue create

**Medium (<30s):** bun run build, test suite runs

**Slow (>30s):** Full CI runs, deployments, cluster operations

If a command is "Slow", don't execute it inline. Report status and provide URL for user to monitor.

## Available External Tools

### Context7 (Web Search & Documentation)

**Available to all agents.** Use Context7 when you need real-time information about external technologies, libraries, APIs, or best practices.

**Invocation:**

```text
use context7 - <your specific question or research need>
```

**When to use:**

- [ ] Researching unfamiliar libraries, frameworks, or tools
- [ ] Looking up current API documentation
- [ ] Finding code examples or implementation patterns
- [ ] Checking latest best practices or security advisories
- [ ] Verifying package versions or compatibility
- [ ] Understanding domain-specific terminology
- [ ] Researching architectural patterns or design decisions

**When NOT to use:**

- Information about the current codebase (use `read_file` instead)
- General programming knowledge you already have
- Information available in project README/docs
- Questions answerable by reading existing code

**Usage Examples:**

```text
Example 1: Before implementing OAuth2 flow with unfamiliar library
"use context7 - Show me official documentation and best practices for implementing OAuth2 with the `oslo` library in TypeScript, including PKCE flow"

Example 2: Researching current best practices
"use context7 - What are React Server Components best practices in 2026? Include data fetching patterns and error handling"

Example 3: Looking up API documentation
"use context7 - Show me the official Stripe webhook API documentation including signature verification and event handling"

Example 4: Package compatibility check
"use context7 - Is TypeScript 5.4 compatible with Node.js 22? What are known issues?"
```

**Best Practices:**

- Be specific in your queries (include versions, context, specific aspects)
- Use during research/planning phase, not mid-implementation
- Focus on one topic per query for better results
- Don't use for information you already confidently know
- Combine with code reading for internal codebase understanding
- Document critical findings in project docs or use `memory` tool

**Integration Examples by Agent Type:**

- **Clarifier:** Research unfamiliar tech mentioned by user before asking questions
- **Planner:** Look up architectural patterns before designing implementation
- **Implementation Agents:** Find documentation and examples before coding with new libraries
- **Senior Agents:** Research security implications and performance patterns
- **DevOps:** Look up CI/CD patterns, deployment strategies, tool documentation
- **Documentation Agent:** Verify technical accuracy, lookup documentation standards

### GitHub MCP Server

**Available to all agents.** Use GitHub MCP for programmatic GitHub operations including issues, pull requests, code search, and repository management.

**Invocation:**

GitHub MCP provides structured API access to GitHub operations:

```typescript
// Examples
create_issue({owner, repo, title, body, labels})
create_pull_request({owner, repo, head, base, title, body})
get_issue({owner, repo, issue_number})
search_code({query, repo})
```

**When to use:**

- [ ] Creating or updating GitHub issues
- [ ] Managing pull requests (create, review, merge)
- [ ] Searching repositories or code across GitHub
- [ ] Checking repository metadata or CI status
- [ ] Reading issue/PR content and comments
- [ ] Assigning reviewers or adding labels
- [ ] Monitoring CI/CD pipeline health

**When NOT to use:**

- Git operations (commit, branch, push, pull) → use `git` commands
- Local repository operations → use `git`
- Local code search → use `search` or `grep`
- File editing → use file edit tools

**Example:**

```text
Example 1: Create issue for discovered bug
GitHub MCP → create_issue({
  owner: "myorg",
  repo: "myproject",
  title: "Memory leak in WebSocket reconnection",
  body: "Found during testing: connection pool not cleaned up...",
  labels: ["bug", "backend"]
})

Example 2: Check PR status before deployment
GitHub MCP → get_pull_request({
  owner: "myorg",
  repo: "myproject", 
  pull_number: 42
})
→ Reviews: approved, CI: passing → Safe to deploy

Example 3: Search for implementation patterns
GitHub MCP → search_code({
  query: "authentication middleware",
  repo: "myorg/myproject"
})
→ Find existing patterns to maintain consistency
```

**Best practices:**

- Use GitHub MCP instead of gh CLI for consistency
- Search before creating to avoid duplicate issues/PRs
- Include detailed context in issue/PR descriptions
- Link related work (reference issues, PRs, commits)
- Check CI status before merge operations
- Be mindful of GitHub API rate limits

**Agent-specific usage:**

- **DevOps:** Primary user for CI/CD automation, issue creation, release management
- **Junior Developer:** Create issues for bugs, check PR status (no CLI access)
- **All Dev Agents:** Search code patterns, verify PR conflicts, read issue context
- **Documentation Agent:** Create docs issues, update documentation PRs, link related work

### Playwright MCP Server

**Available to implementation agents.** Use Playwright for browser automation, end-to-end testing, UI validation, and screenshot generation.

**Invocation:**

Playwright MCP provides browser automation capabilities:

```typescript
// Examples
playwright_navigate({url})
playwright_click({selector})
playwright_fill({selector, value})
playwright_screenshot({path, fullPage})
playwright_wait_for_selector({selector, timeout})
playwright_get_text({selector})
```

**When to use:**

- [ ] Creating end-to-end tests for user workflows
- [ ] Testing UI interactions and behaviors
- [ ] Generating screenshots for documentation or visual testing
- [ ] Validating form behavior and validation
- [ ] Testing multi-step user workflows
- [ ] Cross-browser compatibility testing
- [ ] Responsive design validation
- [ ] Frontend-backend integration testing

**When NOT to use:**

- Unit testing (use project test framework: Jest, Vitest, pytest)
- API testing (use curl, fetch, or API tools)
- Static analysis (use linters, type checkers)
- Performance/load testing (use dedicated tools)

**Example:**

```text
Example 1: E2E test for login flow
playwright_navigate({url: "http://localhost:3000/login"})
playwright_fill({selector: "#email", value: "test@example.com"})
playwright_fill({selector: "#password", value: "password123"})
playwright_click({selector: "button[type=submit]"})
playwright_wait_for_selector({selector: "#dashboard"})
→ Verify successful login

Example 2: Screenshot for documentation
playwright_navigate({url: "http://localhost:3000/app"})
playwright_wait_for_selector({selector: ".loaded"})
playwright_screenshot({
  path: "docs/screenshots/main-view.png",
  fullPage: true
})

Example 3: Form validation testing
playwright_navigate({url: "http://localhost:3000/settings"})
playwright_fill({selector: "#username", value: ""})
playwright_click({selector: "button.save"})
playwright_wait_for_selector({selector: ".error"})
playwright_get_text({selector: ".error"})
→ Verify: "Username is required" message appears
```

**Best practices:**

- Wait for elements before interacting (use `wait_for_selector`)
- Use specific selectors (prefer `data-testid` over CSS classes)
- Test critical user flows, not every UI interaction
- Keep tests isolated and independent
- Include keyboard navigation and accessibility checks
- Screenshot on test failure for debugging
- Use realistic test data and scenarios
- Clean up state between tests

**Agent-specific usage:**

- **Frontend Developer:** E2E tests for new features, form testing, screenshot generation
- **Senior Frontend:** Complex interaction testing, performance validation, reusable test utilities
- **Fullstack Developer:** Integration testing across frontend-backend
- **QA/Testing:** Comprehensive test suites, cross-browser testing, regression tests
- **Documentation Agent:** Generate screenshots for guides, validate tutorial steps

### Tool Selection Quick Reference

| Need | Use | Don't Use |
|------|-----|-----------|
| Web search, docs | Context7 | GitHub MCP, Playwright |
| Create GitHub issue | GitHub MCP | gh CLI |
| Manage PR | GitHub MCP | Manual browsing |
| E2E test | Playwright MCP | Unit tests |
| Screenshot | Playwright MCP | Manual capture |
| Git commit/push | git commands | GitHub MCP |
| Local file ops | file tools | Any MCP |
| API test | curl/fetch | Playwright |

### Pre-Commit Safety Protocol (MANDATORY)

Before `git add` or `git commit`, ALWAYS run:

```bash
# 1. Check for OS artifacts
find . -name ".DS_Store" -o -name "Thumbs.db" -o -name "._*" | xargs rm -f 2>/dev/null

# 2. Verify no artifacts remain
find . -maxdepth 2 \( -name "val_*" -o -name "temp_*" -o -name "packet_*" -o -name ".DS_Store" \) 2>/dev/null

# Should return NOTHING. If anything found, delete it.

# 3. Only then proceed with selective add
git add <specific-files>  # NEVER use -A or -a
```

## Required Context Order

Before substantial implementation, read in this order:

1. `README.md`
2. `CHANGELOG.md`
3. `BACKLOG.md` (or GitHub Projects)
4. Relevant `docs/*.md` files

## Branching + PRs

- Branch name pattern: `codex/<issue-id>-<short-desc>` or `feature/<desc>`
- Never commit directly to main
- PR required for everything (including docs)
- PR description must include:
  - Linked issue
  - What/why summary
  - How to test
  - Risk assessment
  - Rollback instructions

## Work Completion Protocol (Automatic)

When work completes, immediately and automatically:

1. ✅ Update BACKLOG.md/GitHub issues (mark done)
2. ✅ Update CHANGELOG.md (if user-facing)
3. ✅ Update epic/plan documents
4. ✅ Commit documentation updates
5. ✅ Begin next planned work (if dependencies satisfied)

This is operational hygiene. Do not ask permission.

## Validation Requirements

All implementation agents (Junior, Frontend, Backend, Fullstack, Senior variants, Mobile Developer, Data Engineer) MUST run validation before `handoff_to_reviewer`.

**See:** [docs/VALIDATION_RUNBOOK.md](../docs/VALIDATION_RUNBOOK.md) for standard commands by project type.

**Minimal validation steps:**

1. Identify project type (Node.js, Python, Go, Swift/iOS)
2. Run relevant lint/type-check commands
3. Capture results in output YAML `validation:` field
4. Fix simple failures (typos, imports) before review handoff
5. Escalate complex failures per [RECOVERY_RUNBOOK.md](../docs/RECOVERY_RUNBOOK.md)

### Markdown Validation

**When ANY .md files modified:**

```bash
npx markdownlint-cli2 "**/*.md" "!node_modules"
```

- Must show 0 errors before handoff to Reviewer
- Auto-fix available: add `--fix` flag
- See: [docs/MARKDOWN_LINT_RUNBOOK.md](../docs/MARKDOWN_LINT_RUNBOOK.md)

**DO NOT bypass validation.** Reviewer will reject incomplete packets lacking validation results.

## Orchestrator Tool Boundaries

When running in Orchestrator mode:

- You have: read_file, runSubagent, memory tools only
- You do NOT have: file editing, CLI, git operations
- Delegate ALL execution work to specialist agents

## Git Hygiene and Artifacts

**NEVER commit temporary artifacts:**

- Validation files: `val_*.txt`, `val_*.log`
- Temporary scripts: `temp_*.sh`, `temp_*.py`, `ls_*.sh`
- Agent tracking: `packet_*.yaml`, `analysis.txt`
- Agent workspace: `.agent-local/`, `.tmp/`

**Before every commit:**

1. Run `git status` and review ALL files
2. Verify no temporary artifacts are staged
3. Use selective staging: `git add <specific-file>` (NEVER `git add .` or `git add -A`)
4. Clean up validation output files after capturing results

**See:** [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md#git-hygiene-and-artifact-management) for complete rules and recovery procedures.

## Commit Message Standards (50/72 rule)

- Subject line ≤ 50 characters, imperative mood, no period
- Blank line between subject and body
- Body lines ≤ 72 characters, hard-wrapped
- Explain why and what; reference issues

## Documentation Discipline

When behavior changes, update:

- README.md
- CHANGELOG.md
- Relevant docs/*.md files
- BACKLOG.md (mirror GitHub state)

## Autonomy Levels

- **Low-risk changes:** Proceed without asking
- **Architecture/breaking changes:** Clarify first
- **Security/credentials:** Always get explicit approval
