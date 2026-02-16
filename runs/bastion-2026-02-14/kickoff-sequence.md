# Kickoff Sequence (MVP Orchestrator Only)

## Control plane
- Orchestrator prompt: `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/prompts/orchestrator.md`
- Workflow: `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/docs/WORKFLOW.md`
- Policy: `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/docs/POLICY.md`

## Step 1 — Orchestrator thread bootstrap
Use this task envelope in Copilot Chat with the orchestrator prompt loaded:

- task_id: `bastion-takeover-2026-02-14`
- repos_in_scope:
  - `/Users/danedevalcourt/iPhoneApp/bastion`
- primary_goals:
  - Complete issue #706 (`ready-now`)
  - Refill `ready-now` backlog via planner lane
  - Re-baseline quality lane and seed one new quality `ready-now`
- constraints:
  - Do not use Bastion native orchestrator scripts as control plane
  - Follow approvals policy and ask-me-first boundaries

## Step 2 — Dispatch packets
- Packet for Feature Executor:
  - `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/runs/bastion-2026-02-14/packet-feature-706.md`
- Packet for Planner:
  - `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/runs/bastion-2026-02-14/packet-planner-refill.md`
- Packet for Quality Executor:
  - `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/runs/bastion-2026-02-14/packet-quality-baseline.md`

## Step 3 — Reviewer gate
After packet outputs, run reviewer using:
- `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/prompts/reviewer.md`

## Step 4 — Record and report
Update:
- `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/runs/bastion-2026-02-14/session-log.md`
- `/Users/danedevalcourt/iPhoneApp/danes-agent-orchestra/templates/final-report.md`
