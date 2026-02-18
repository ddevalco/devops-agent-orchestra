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
