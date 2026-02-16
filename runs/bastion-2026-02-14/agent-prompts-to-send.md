# Agent Prompts To Send (Current Cycle)

Use these with the matching role prompts in `/Users/danedevalcourt/iPhoneApp/dane-agent-orchestra/prompts/`.

## Planner agent prompt
Task: Execute issue #709 first, then #708.
Constraints:
- Stay within planning/relabeling/issue-decomposition scope.
- Keep one lane label and one readiness label per executable issue.
- Record decisions and SLO impact in run artifacts.

## Feature executor prompt
Task: Execute issue #706.
Constraints:
- Use packet: `packet-feature-706.md`.
- No unrelated refactors.
- Report changed files, validation, and residual risks.

## Docs executor prompt
Task: Execute issue #699, queue #698.
Constraints:
- Keep docs aligned with MVP orchestration operations.
- Reflect any process changes in canonical docs.

## Quality executor prompt
Task: Execute issue #701, queue #700.
Constraints:
- Keep scope to tests/CI/quality contracts.
- Link all failures to reproducible checks/issues.

## Reviewer prompt
Trigger when planner + at least one executor packet reports done.
Required output:
- approve|reject
- concrete required fixes
- residual risks and final gate decision
