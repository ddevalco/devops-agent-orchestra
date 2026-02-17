# Installation Validation Report

**Test Date:** February 17, 2026
**Scope:** Workspace and global agent install scripts

## Script Versions

- Repository HEAD: `032ff2416f76e302971a8ff5ca84c194e9603268`
- Phase 3 validation update: `fc2ea1f62ce79e4a59f7094b82faae26a23bf564`

## Phase 4.2: Workspace Install Validation

**Script:** `scripts/install-workspace-agents.sh`

### Workspace Validation Procedure

1. Read the script to confirm the target directory, discovery rules, and copy logic.
2. Enumerate prompt files under `prompts/` to confirm expected agent count.
3. Confirm handling of YAML frontmatter and `name:` field requirements.
4. Confirm behavior for multi-repo workspaces by checking target path usage.

### Workspace Expected Behavior (by design)

- **Target directory:** `<workspace-root>/.github/agents/`
- **File discovery:** glob `prompts/*.md` within the repository root.
- **Agent validity checks:**
  - First line must be `---` (YAML frontmatter start).
  - A `name:` field must exist within the first 30 lines.
- **Copy behavior:**
  - Copies valid prompts as-is (no extension change).
  - Skips non-agent markdown files.
- **Multi-repo workspace behavior:**
  - The install target is a single workspace root passed to the script.
  - All agents are installed under that root, making them available to the entire workspace.

### Workspace Actual Behavior (by inspection)

- The script creates `<workspace-root>/.github/agents/` and copies all valid prompt files that pass the frontmatter and `name:` checks.
- Current prompt inventory: **18** `prompts/*.md` files (includes `mobile-dev.md`).
- **Expected install count:** 18 (assuming all prompt files include YAML frontmatter + `name:` within the first 30 lines).

## Phase 4.3: Global Install Validation

**Script:** `scripts/install-global-agents.sh`

### Global Validation Procedure

1. Read the script to confirm the target directory, discovery rules, and copy logic.
2. Confirm `.agent.md` extension convention for global installs.
3. Check history for prior validation evidence (Phase 3 commit).

### Global Expected Behavior (by design)

- **Target directory:** `~/Library/Application Support/Code/User/prompts/`
- **File discovery:** glob `prompts/*.md` within the repository root.
- **Agent validity checks:**
  - First line must be `---` (YAML frontmatter start).
  - A `name:` field must exist within the first 30 lines.
- **Copy behavior:**
  - Copies each valid prompt to `*.agent.md` in User Data.
  - Skips non-agent markdown files.
- **Profile-scoped behavior:**
  - Installs to the default VS Code User Data location.
  - Other VS Code profiles may use different User Data roots.
- **Conflict resolution with workspace agents:**
  - Workspace agents in `.github/agents` should still be available alongside global agents.
  - If an agent name exists in both scopes, VS Code behavior may vary (duplicate entries or priority). Manual verification recommended.

### Global Actual Behavior (by inspection)

- The script copies valid prompt files to `~/Library/Application Support/Code/User/prompts/` with a `.agent.md` suffix.
- Prompt count in repo is 18, so expected global install count is 18 (assuming all prompts satisfy frontmatter and `name:` checks).
- Prior validation evidence: commit `fc2ea1f62ce79e4a59f7094b82faae26a23bf564` updated the validation report to FULL PASS, but it does not explicitly record a global install run. A targeted install test is still recommended.

## Verification Steps (Recommended)

### Workspace Install

1. Run: `bash scripts/install-workspace-agents.sh /Users/danedevalcourt/iPhoneApp`
2. Verify files:
   - `.github/agents/` contains 18 agent files (one per prompt).
3. In VS Code:
   - Run **Developer: Reload Window**.
   - Open agent picker and confirm all agents appear.

### Global Install

1. Run: `bash scripts/install-global-agents.sh`
2. Verify files:
   - `~/Library/Application Support/Code/User/prompts/` contains 18 `*.agent.md` files.
3. In VS Code:
   - Run **Developer: Reload Window**.
   - Open agent picker in a different workspace to confirm global availability.

## Known Limitations

- The scripts rely on YAML frontmatter and `name:` detection within the first 30 lines; malformed prompts are skipped without detailed error output.
- Global install path is hard-coded to the default VS Code User Data directory. Custom profiles may store prompts elsewhere.
- Duplicate agent names between workspace and global scopes can cause confusion; VS Code behavior may vary by version.

## Troubleshooting Guide

- **Symptom:** Agents do not appear after install.
  - **Fix:** Run **Developer: Reload Window** and reopen the agent picker.
- **Symptom:** Some agents missing.
  - **Fix:** Confirm each prompt includes YAML frontmatter and `name:` in the first 30 lines.
- **Symptom:** Global agents missing in a secondary profile.
  - **Fix:** Install again with the profile’s User Data directory or use **Configure Custom Agent** within that profile.
- **Symptom:** Duplicate agent entries.
  - **Fix:** Remove duplicates from either `.github/agents/` or User Data, then reload.

## Recommendations for Production Use

- Run both workspace and global installs for the smoothest onboarding.
- Add a lightweight post-install verification step that checks file counts and prompts a reload.
- Document profile-specific User Data paths if multiple VS Code profiles are in active use.
- Log skipped files during install (future enhancement) to aid troubleshooting.
