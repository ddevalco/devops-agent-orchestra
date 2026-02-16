# Execution Packet

- task_id: bastion-takeover-2026-02-14
- packet_id: P-QUALITY-BASELINE
- owner: executor
- goal: Re-establish quality lane baseline and create one actionable `ready-now` quality issue.
- allowed_scope:
  - /Users/danedevalcourt/iPhoneApp/bastion/core
  - /Users/danedevalcourt/iPhoneApp/bastion/.github/workflows
  - /Users/danedevalcourt/iPhoneApp/bastion/docs/agents/HANDOFF-quality.md
- touched_files:
  - quality checks and handoff docs only
- validation:
  - run defined quality baseline commands
  - all failures linked to issues with reproduction notes
- constraints:
  - no broad refactor
  - no policy changes
- fallback_if_blocked:
  - create blocker report with reproducible command matrix and linked issue IDs
