# Agent Operating Rules

This file defines project-specific constraints and protocols for human and agent contributors.

## Project Context

- **Project Name:** [Your Project Name]
- **Primary Branch:** main
- **Repository:** [GitHub URL]
- **Issue Tracker:** [GitHub Issues URL]

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

## Orchestrator Tool Boundaries

When running in Orchestrator mode:

- You have: read_file, runSubagent, memory tools only
- You do NOT have: file editing, CLI, git operations
- Delegate ALL execution work to specialist agents

## Commit Message Standards (50/72 rule)

- Subject line ≤ 50 characters, imperative mood, no period
- Blank line between subject and body
- Body lines ≤ 72 characters, hard-wrapped
- Explain why and what; reference issues

## Validation Requirements

Before and after changes:

- [Project-specific test command]
- [Project-specific build command]
- [Project-specific lint/type-check command]

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
