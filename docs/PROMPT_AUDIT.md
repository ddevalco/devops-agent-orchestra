# Prompt Roster Alignment Audit

This audit evaluates the consistency across the agent prompts, the orchestrator's knowledge of the roster, and the documented architecture in the README.

## 1. Roster Comparison Table

| Agent Role | File Name | In Orchestrator? | In README? | Status |
| :--- | :--- | :---: | :---: | :--- |
| **Clarifier** | [clarifier.md](../prompts/clarifier.md) | ✅ | ✅ | Aligned |
| **Planner** | [planner.md](../prompts/planner.md) | ✅ | ✅ | Aligned |
| **Orchestrator** | [orchestrator.md](../prompts/orchestrator.md) | N/A | ✅ | Aligned |
| **Junior Developer** | [junior-dev.md](../prompts/junior-dev.md) | ✅ | ✅ | Aligned |
| **Frontend Developer** | [frontend-dev.md](../prompts/frontend-dev.md) | ✅ | ✅ | Aligned |
| **Backend Developer** | [backend-dev.md](../prompts/backend-dev.md) | ✅ | ✅ | Aligned |
| **Fullstack Developer** | [fullstack-dev.md](../prompts/fullstack-dev.md) | ✅ | ✅ | Aligned |
| **Senior Frontend** | [sr-frontend-dev.md](../prompts/sr-frontend-dev.md) | ✅ | ✅ | Aligned |
| **Senior Backend** | [sr-backend-dev.md](../prompts/sr-backend-dev.md) | ✅ | ✅ | Aligned |
| **Senior Fullstack** | [sr-fullstack-dev.md](../prompts/sr-fullstack-dev.md) | ✅ | ✅ | Aligned |
| **Data Engineer** | [data-engineer.md](../prompts/data-engineer.md) | ✅ | ✅ | Aligned |
| **Designer** | [designer.md](../prompts/designer.md) | ✅ | ✅ | Aligned |
| **Documentation Agent** | [documentation-agent.md](../prompts/documentation-agent.md) | ✅ | ❌ | **Incomplete Roster in README** |
| **Prompt Writer** | [prompt-writer.md](../prompts/prompt-writer.md) | ✅ | ✅ | Aligned |
| **DevOps** | [devops.md](../prompts/devops.md) | ✅ | ✅ | Aligned |
| **Executor** | [executor.md](../prompts/executor.md) | ✅ | ✅ | Aligned |
| **Reviewer** | [reviewer.md](../prompts/reviewer.md) | ✅ | ✅ | Aligned |
| **Native Kickoff** | [native-orchestrator-kickoff.md](../prompts/native-orchestrator-kickoff.md) | ❌ | ❌ | **Undocumented Agent** |

## 2. Tool Capability Matrix

| Agent | Edit (`edit`) | Execute (`execute/terminal`) | Read (`read`) | Sub-Agent (`agent`) | Consistency Note |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Orchestrator** | ❌ | ❌ | ✅ | ✅ | Uses `read/readFile` naming. |
| **Planner** | ❌ | ✅ | ✅ | ✅ | Has `execute` but body says "do not write code". |
| **Documentation** | ✅ | ✅ | ✅ | ❌ | Uses `terminal/git` and `read/readFile`. |
| **Developers (All)** | ✅ | ✅ | ✅ | ✅ | Standardized toolset includes `agent` (sub-delegation). |
| **Reviewer** | ❌ | ❌ | ✅ | ✅ | Lacks `edit` as expected. |
| **Designer** | ❌ | ❌ | ✅ | ✅ | Lacks `edit` as expected. |
| **Prompt Writer** | ❌ | ❌ | ✅ | ✅ | Lacks `edit` but has `agent`. |

## 3. Top 5 Critical Inconsistencies

1. **Schema Divergence:** `documentation-agent.md` and `orchestrator.md` use specific tool names like `read/readFile`, `terminal`, and `git`, while all other agents use the aggregate `vscode` tool schema with generic `read` and `execute` names. This causes registry fragmentation.
2. **README Roster Gap:** The `Documentation Agent` is listed in `orchestrator.md` as a sub-agent but is missing from both the "Full roster" list and the "Agent Architecture" Mermaid diagram in the main `README.md`.
3. **Ghost Agent:** `native-orchestrator-kickoff.md` exists in the `prompts/` directory but is not mentioned in any orchestration workflows or documentation. It also lacks the mandatory frontmatter (name, description, tools) present in all other prompts.
4. **Handoff Token Mismatches:** Several agents (e.g., `Designer`) define handoff tokens like `handoff_to_frontend` or `handoff_to_planner`, but the standard `Orchestrator` contract expects `handoff_to_orchestrator` as the primary return path after task completion.
5. **Over-Privileged Roles:** `Junior Developer` has the exact same toolset as `Senior Fullstack Developer`, including `web` search, `execute` terminal access, and `agent` sub-delegation. There are no technical guardrails in the prompt to restrict tool use based on role seniority.

## 4. Communication Contract Mapping

* **Northbound:** All agents are instructed to return to the Orchestrator/Reviewer.
* **Southbound:** Orchestrator uses `runSubagent` to call specialists.
* **Horizontal:** Mostly banned, but `Designer` and `Clarifier` have legacy "handoff to X" strings that bypass the Orchestrator in their logic, which could break the `runSubagent` blocking model.
