# Agent Availability (Global vs Project)

## Short answer

Yes, what you are seeing can happen.

If prompts are only present as files in a repo, they are not automatically global chat agents. They must be installed into VS Code Chat Agent registry/profile to reliably appear in the dropdown.

## Mode A: Global install (recommended)

Use this when you want the same agents available in any repo.

1. Install each prompt from `prompts/` as a chat agent.
   - For profile-global availability, create/install agents under `User Data`.
2. Keep using your normal project folders.
3. Select `Orchestrator` in any workspace and run.

Result: agents are available across projects in the same VS Code profile.

Full roster in this repo includes Orchestrator + Clarifier + Planner + specialist developer/data/design/devops agents + Reviewer (+ fallback Executor).

## Mode B: Per-project scaffold

Use this when sharing setup with teammates or pinning config to a specific repo.

Run:

`scripts/apply-scaffold.sh <target-repo-path>`

This creates:

`<target-repo>/.vscode-agent-orchestration/`

with prompts/templates/docs and a `START_HERE.md` runbook.

## Why agents sometimes disappear

- Different VS Code profile/account than where agents were installed
- Opening a different machine/remote context
- Agent install was never completed (prompt file exists, but agent not registered)
- Experimental tool availability differences (e.g., memory)

## Common install error

Error: **"The name contains invalid characters."**

- Usually means a full path like `/Users/.../orchestrator.md` was typed into a name prompt.
- Use **Install from file** and choose the file in the picker instead.
- If prompted for name, enter only a plain name like `Orchestrator`.

## Best practice

Do both:

- Install globally once (Mode A)
- Keep per-project scaffold (Mode B) for reproducibility and onboarding
