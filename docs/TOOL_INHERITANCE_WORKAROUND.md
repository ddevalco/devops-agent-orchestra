# Tool Inheritance Workaround

## Problem

VS Code Chat Agent API limitation: When Orchestrator calls `runSubagent(agent="@specialist")`, the spawned subagent inherits the Orchestrator's toolset instead of receiving the tools defined in the specialist's prompt.

**Impact**: Specialists spawned via Orchestrator delegation cannot perform file operations even when their prompt definitions include edit/terminal tools.

**Demonstrated**: Orchestrator → DevOps → DevOps reports "Edit tools not available" despite having `tools: ['read', 'edit', 'terminal', 'agent']` in its YAML frontmatter.

## Root Cause

The VS Code Chat Agent API's `runSubagent` function does not properly pass the target agent's tool definitions to the spawned subprocess. The child process receives a copy of the parent's tool environment instead of loading its own.

**This is a platform bug, not a configuration issue.** All agent prompt files are correctly defined with appropriate tools.

## Workaround: Soft Restriction Pattern

Grant Orchestrator the `edit` tool for inheritance passthrough while prohibiting direct use via strict policy enforcement.

### Changes Applied

**File**: `prompts/orchestrator.md`

**Line 5**:
```yaml
tools: ['read', 'edit', 'agent', 'memory']
```

**Lines 15-38**: Expanded "Tool Constraints" section with explicit Edit Tool Policy prohibiting Orchestrator from using edit directly while explaining its presence enables subagent inheritance.

### How It Works

1. **Orchestrator has edit in toolset** → Platform includes it in inheritance
2. **Orchestrator prompt prohibits direct use** → Ensures read-only coordination behavior
3. **Subagents inherit edit tool** → Can perform file operations when delegated
4. **Policy enforcement via prompt** → Architectural constraint maintained through instruction rather than platform restriction

### Verification

After applying changes, test with:

```
User → Orchestrator: "Create test.md with 'hello world'"
Expected flow:
  1. Orchestrator reads prohibition policy
  2. Orchestrator calls runSubagent(agent="@junior-developer")
  3. Junior Developer inherits edit tool
  4. Junior Developer creates file successfully
  5. Orchestrator reports completion without having edited directly
```

## Alternative: Direct Agent Calls

If workaround fails, bypass Orchestrator entirely:

```
# Works (subagent has full tools when called directly)
User → @documentation-agent: "Create file"

# Broken (subagent inherits restricted toolset)
User → Orchestrator → runSubagent(@documentation-agent): "Create file"
```

Direct calls work because the platform properly loads the target agent's tools when invoked as primary agent.

## Future Platform Fix

**Ideal solution**: VS Code Chat Agent API should load target agent tool definitions when spawning subagents via `runSubagent`, not inherit parent toolset.

**Until then**: Soft restriction pattern enables orchestrated workflows while maintaining architectural separation of concerns.

---

*Applied*: 2026-02-18
*Reason*: VS Code Chat Agent API limitation in tool inheritance
*Impact*: Unblocks all Orchestrator-delegated workflows requiring file operations
