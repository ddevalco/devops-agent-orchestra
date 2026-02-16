# Setup (Native VS Code Agent Orchestration)

## Goal

Make this package behave like Burke-style orchestration in VS Code: select `Orchestrator`, give one prompt, and let subagents coordinate plan/execute/review.

## Prerequisites

- VS Code (Insiders recommended for latest agent capabilities)
- GitHub Copilot + Chat Agents enabled
- Workspace opened with your target repo(s)

## Agent definition format

Each agent prompt in `prompts/*.md` is install-ready and includes:

- `name`
- `description`
- `model`
- `tools`

This mirrors the Burke pattern shown in agent install examples.

## Tools and memory note

- Include `agent` tool so Orchestrator can call subagents.
- Include `read/readFile` and search/edit/run tools where needed.
- Memory tool alias should be `vscode/memory` (Insiders/experimental feature availability may vary).
- Question tool alias: `vscode/askQuestions`.

## Install agents from this repo

1. Open Copilot Chat.
2. Open agent management and choose **Install from file**.
3. In the file picker, select each file from `prompts/` (do not paste an absolute file path into a name field):
   - `orchestrator.md`
   - `clarifier.md`
   - `planner.md`
   - `junior-dev.md`
   - `frontend-dev.md`
   - `backend-dev.md`
   - `fullstack-dev.md`
   - `sr-frontend-dev.md`
   - `sr-backend-dev.md`
   - `sr-fullstack-dev.md`
   - `data-engineer.md`
   - `designer.md`
   - `prompt-writer.md`
   - `devops.md`
   - `executor.md`
   - `reviewer.md`
4. If VS Code asks for a name, use only the simple agent name (for example: `Orchestrator`). Do not enter a path like `/Users/.../orchestrator.md`.

### If using Configure Custom Agent flow

When VS Code asks where to create the agent file, choose **User Data** for global availability.

- `User Data` = available across projects in the same VS Code profile
- `.github/agents` = repository-scoped/shareable in git
- `.claude/agents` = local folder-scoped

When prompted for filename, enter only a filename like `orchestrator.md` (not an absolute path), then paste the matching prompt content from this repo and save.

This is the step that makes agents available broadly in your VS Code profile.

### Common install error

If you see: **"The name contains invalid characters."**

- Cause: a file path (contains `/`) was entered where VS Code expected an agent name.
- Fix: cancel, run **Install from file** again, pick the `.md` file in the picker, and use a plain name if prompted.

## Easiest per-project apply

To copy a reusable scaffold into any project:

`scripts/apply-scaffold.sh <target-repo-path>`

Example:

`scripts/apply-scaffold.sh /Users/danedevalcourt/iPhoneApp/codex-pocket`

The script creates `.vscode-agent-orchestration/` inside the target repo.

## Start flow

1. Select `Orchestrator` from the chat agent dropdown.
2. Paste `prompts/native-orchestrator-kickoff.md` (optional but recommended for repeatable kickoff).
3. Provide your objective + constraints.
4. Expect sequence: Clarifier (if needed) → Planner → specialist agent packet(s) → Reviewer → final report.

## Important

- Native chat-agent orchestration is the control plane.
- Do not use external scripts to make orchestration decisions.

See `docs/AVAILABILITY.md` for global-vs-project behavior and troubleshooting.
