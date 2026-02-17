# Tool Reference & Migration Guide

This document defines the standardized toolsets and the migration from legacy tool naming (Convention A) to modern standardized naming (Convention B).

## Standard Tool Definitions

| Tool | Capability |
| :--- | :--- |
| `read` | Read-only access to files and directory structures. |
| `edit` | Direct modification of files using string replacement or rewrite. |
| `execute` | Execution of shell commands and scripts in the terminal. |
| `git` | Version control operations (commit, branch, push, pull). |
| `agent` | Delegation to sub-agents (runSubagent). |
| `memory` | Long-term storage and retrieval of cross-session context. |
| `search` | Semantic or keyword search across the codebase. |

## Migration Guide: Convention A to Convention B

We are standardizing tool lists in agent prompts to improve consistency and tool-provider compatibility.

### Key Mappings

| Convention A (Legacy) | Convention B (Standard) | Notes |
| :--- | :--- | :--- |
| `read/readFile` | `read` | Simplified name. |
| `terminal` | `execute` | More descriptive of the action. |
| `vscode/memory` | `memory` | Namespace abstraction. |
| `searchCodebase` | `search` | Generic action name. |

### Implementation Examples

#### Documentation Agent
- **Old**: `tools: ['read/readFile', 'edit', 'terminal', 'git']`
- **New**: `tools: ['read', 'edit', 'execute', 'git', 'agent']`

#### Orchestrator
- **Old**: `tools: ['read/readFile', 'agent', 'vscode/memory', 'memory']`
- **New**: `tools: ['read', 'agent', 'memory']`

#### Junior Developer
- **Old**: `tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'todo', 'vscode/memory', 'memory']`
- **New**: `tools: ['read', 'edit', 'git', 'agent']`
