# Runbook (First Live Cycle)

## Goal
Run a single orchestration cycle across one real task in your multi-repo workspace.

## Step 1: Start thread
- Open Copilot Chat in VS Code.
- Select `Orchestrator` from the agent dropdown.
- Submit task objective and constraints.

## Step 2: Clarify and plan
- Orchestrator delegates to Clarifier only if blocking ambiguity exists.
- Orchestrator delegates planning with `prompts/planner.md` behavior.
- Save output into `templates/clarified-requirements.md` and `templates/execution-plan.md`.

## Step 3: Execute packets
- For each packet, orchestrator delegates one executor pass.
- Use parallel only if file lists do not overlap.
- Record packet result in `templates/session-log.md`.

## Step 4: Review gate
- Run `prompts/reviewer.md` against packet outputs.
- If rejected, route specific fixes back to executor.

## Step 5: Finalize
- Produce final status using `templates/final-report.md`.
- Store lessons learned in `templates/session-log.md` follow-ups.

## Done criteria
- Reviewer approved.
- Validation checks recorded.
- Final report includes risks and next steps.
