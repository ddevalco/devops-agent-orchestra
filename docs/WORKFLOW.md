# Orchestration Workflow

## 1) Intake
- User provides objective + constraints.
- `Orchestrator` decides whether `Clarifier` is required.

## 2) Clarify (conditional)
- `Clarifier` outputs one of: `clear`, `clarified`, `assumptions`.
- If assumptions are used, they must be explicit and reversible.

## 3) Plan
- `Planner` creates phases and execution packets.
- Each packet must include scope, file paths, dependencies, risks, validation.
- Orchestrator parses packets into parallel/sequential phases by file overlap.

## 4) Execute
- `Orchestrator` assigns packets to `Executor` runs.
- Parallel allowed only when touched files are disjoint.
- Overlapping files must run sequentially.
- Orchestrator posts a checkpoint after each phase.

## 5) Review gate
- `Reviewer` validates correctness, scope, and regression risk.
- If rejected, route back to Planner or Executor with concrete fixes.

## 6) Final report
- `Orchestrator` returns concise outcome, changed files, risks, and next steps.
