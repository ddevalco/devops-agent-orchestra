# Heartbeat Monitor

- cadence: every 30 minutes
- owner: Orchestrator
- source of truth: GitHub issues + this run folder
- last_cycle_at: 2026-02-14 16:57:54 CST

## Current snapshot
- global ready-now: 15
- feature ready-now: 8
- docs ready-now: 2
- planner ready-now: 3
- quality ready-now: 2

## Current primary assignments
- feature: #706 Modules SDK: add contract test harness for provider adapters
- docs: #699 Docs: add lane queue SLO operations runbook
- planner: #709 Planner: operator decision brief packet for ask-me-first queue
- quality: #701 Quality: test queue SLO query helpers for lane scripts

## Health checks per cycle
1. Verify each lane has exactly one primary active issue.
2. Verify no conflicting file ownership among active packets.
3. Verify reviewer gate is pending/complete for finished packets.
4. Verify queue SLO remains above lane/global minimums.
5. Record blockers and reroute without idling a lane.
