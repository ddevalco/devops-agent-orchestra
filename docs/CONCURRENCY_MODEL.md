# Concurrency Model

## Platform Concurrency Limits (Hard Constraint)

- `runSubagent` is a blocking call in VS Code Copilot.
- Only one subagent can execute at a time in a single chat thread.
- True parallel execution of multiple subagents is NOT supported.

This constraint is absolute and must be treated as a platform limit, not a workflow preference.

## Achievable Parallelism Strategies

### Practical workaround: batch and parallelize inside one subagent

Current workaround is to batch parallel-safe packets into one subagent call (typically Junior Dev). That agent can then spawn multiple background processes (shell `&`, parallel tool runs) inside a single execution.

This is effective when:

- Tasks are disjoint in files and are low-risk to run concurrently.
- The same specialist can own the entire batch without expertise conflict.
- Work can be expressed as independent shell commands or tooling tasks.
- There is minimal shared state and no write conflicts.

This is NOT effective when:

- Different specialist expertise is required (e.g., DevOps + Frontend + Data Eng).
- Tasks require sequential dependencies or shared files.
- The subagent needs interactive reasoning between steps.
- Tools or scripts are not safe to run concurrently.

### Examples

Batchable:

- Lint + unit test in separate packages with disjoint outputs.
- Generate documentation files in different folders.
- Run static analysis across separate modules.

Non-batchable:

- Backend migration + frontend integration that depends on new API surface.
- Schema change followed by code refactor across shared files.
- Tasks that require different specialist roles in the same phase.

## Operational Reality: Documented vs Actual

- Documented behavior: "Run packets in parallel when files are disjoint."
- Platform reality: subagent calls are sequential only.
- Practical workaround: batch disjoint packets into a single subagent and parallelize internally.

This gap must be made explicit in planning and runbooks to avoid false expectations about speed or concurrency.
