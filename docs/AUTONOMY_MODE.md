# Autonomy Mode (Native VS Code Agents)

## Objective
Run any target project with low human intervention while keeping assignments and progress visible in VS Code chat.

## Operating model
- `@Orchestrator` (installed native chat agent) owns dispatch, monitoring, and rerouting.
- Role agents execute via native delegation:
  - Clarifier
  - Planner
  - Executor
  - Reviewer
- Human intervention is required only for:
  - `ask-me-first` issues
  - approvals/security-sensitive decisions
  - conflict arbitration when overlapping file ownership cannot be resolved automatically

## Cycle cadence
- Default cycle: every 30 minutes (or each completed phase)
- Per cycle, Orchestrator must:
  1. Read queue health and lane issue status
  2. Confirm one active primary issue per lane
  3. Route blocked lane to next ready-now issue
  4. Trigger reviewer gate for completed packets
  5. Post chat checkpoint summary

## Visibility contract
Each cycle publishes in chat:
- active assignments by role
- current blockers and reroutes
- reviewer gate status
- concise status report (who is active, what changed, what is blocked)

## Control-plane rule
- Native VS Code chat-agent orchestration is the control plane.
- Custom shell scripts can be used for project build/test tasks, but not for orchestration decisions.
