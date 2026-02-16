# MVP Policy

## Scope control
- Modify only user-requested areas.
- Avoid unrelated refactors.

## Tooling control
- Prefer built-in editor tools and deterministic commands.
- Keep commands idempotent where possible.

## Quality gate
- Validate with the smallest relevant checks first.
- Escalate to broader checks only after local confidence.

## Reporting contract
Every role response includes:
- `task_id`
- `decision`
- `assumptions`
- `touched_files`
- `next_action`
- `confidence` (`low|medium|high`)
