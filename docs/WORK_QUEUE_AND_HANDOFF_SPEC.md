# Work Queue and Handoff Spec

## Goal

Ensure no idle agents when work is available, while respecting the platform limit of a single active subagent call at a time.

## Queue Model

Each packet is tracked in a queue with explicit state:

- `ready`: dependencies satisfied, can be executed now.
- `blocked`: waiting on dependencies or external input.
- `in_progress`: currently assigned to a subagent.
- `done`: completed and validated.

Dependencies are modeled as a DAG to prevent cycles and ensure deterministic handoff order.

## Idle Detection

Orchestrator is idle when:

- No subagent call is active, AND
- At least one packet is in `ready` state.

Orchestrator availability is inferred by the absence of an active `runSubagent` call and the completion status of the last delegated packet.

## Queue Scanning Cadence

- Immediate scan after any packet completes or becomes blocked.
- Periodic scan every 5 minutes while idle to catch external unblocks.
- Manual scan on explicit user signal (e.g., "resume queue").

Cadence is a policy; adjust only if throughput or responsiveness requires it.

## Handoff Rules

1. Select the next `ready` packet with highest priority and lowest dependency depth.
2. If multiple packets are disjoint, batch them into a single subagent call.
3. Prefer a single specialist who can safely own the batch.
4. If expertise conflicts, split into sequential subagent calls.

## Reroute Policy

When a packet becomes unblocked:

- If the originally assigned specialist is available, reuse.
- If not, reroute to the nearest competent role (e.g., Junior Dev for low-risk tasks).
- If the packet requires specific expertise, keep in `ready` and wait until the right specialist is available.

## Dependency Chain Management

- On completion, mark dependent packets as `ready` if all prerequisites are `done`.
- If a packet fails validation, mark dependents as `blocked` and requeue the packet with corrective notes.
- Avoid parallelization across shared files even if dependencies appear satisfied.

## Operational Reality Note

Even with a "no idle agents" policy, only one subagent can run at a time. The only concurrency is internal to a single subagent call via batched work and background processes.
