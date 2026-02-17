# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Memory tool fallback guidance across all 18 agent prompts (P8)
- ADR-005: Memory Tool Fallback Strategy in ARCHITECTURE.md (P8)
- VALIDATION_RUNBOOK.md with standard commands for Node.js, Python, Go, Swift/iOS (P9)
- RECOVERY_RUNBOOK.md with error recovery procedures and escalation criteria (P10)
- Error recovery guidance in all 8 developer agent prompts (P10)
- Validation requirements in AGENTS.md template (P9)
- E2E integration test report validating v0.3.0 orchestration capabilities
- INSTALLATION_VALIDATION.md documenting script behavior and verification
- Mobile Developer specialist agent for iOS native development (Swift/SwiftUI/UIKit)
- CHANGELOG.md following Keep a Changelog format
- BACKLOG.md for tracking improvement priorities
- docs/ARCHITECTURE.md with comprehensive system overview
- Documentation Agent mode integration for maintaining project documentation

### Changed

- Updated TOOL_REFERENCE.md with memory tool stability notes (P8)
- Phase 4 status: In Progress → Completed

## [0.3.0] - 2026-02-17

### Added

- Agent delegation with proper tool boundaries for Orchestrator
- Tool capability standardization across all agent roles
- Guardrails for file-overlap detection and sequential execution enforcement
- Status reporting contract with mandatory checkpoint fields
- Concurrency model documentation with batch workaround patterns

### Changed

- Enhanced Orchestrator prompt with clearer delegation rules (WHAT, not HOW)
- Improved native-orchestrator-kickoff.md with mandatory execution model
- Refined specialist routing strategy in orchestration flow
- Updated WORKFLOW.md with review gate validation requirements

### Fixed

- File overlap causing race conditions in parallel packet execution
- Missing validation requirements in execution packets
- Ambiguous handoff protocols between orchestration phases

## [0.2.0] - 2026-02-10

### Added

- Phase 2 analysis documents in docs/ folder
- WORKFLOW.md with detailed orchestration lifecycle
- SETUP.md with comprehensive install instructions
- AVAILABILITY.md explaining global vs project agent behavior
- POLICY.md defining MVP scope and quality gates
- Templates for clarified requirements, execution plans, and review reports

### Changed

- Reorganized documentation structure for better onboarding
- Enhanced error messaging for common install issues
- Improved troubleshooting guidance for invalid-name errors

## [0.1.0] - 2026-02-03

### Added

- Initial agent roster establishment with 16 specialized roles
- Orchestrator-first workflow implementation
- Clarifier, Planner, and Reviewer gate agents
- Junior/Frontend/Backend/Fullstack developer agents
- Senior Frontend/Backend/Fullstack escalation paths
- Data Engineer, Designer, Prompt Writer, DevOps specialists
- Executor fallback agent for flexible execution
- Bulk installation scripts (install-workspace-agents.sh, install-global-agents.sh)
- apply-scaffold.sh for per-project setup deployment
- Workspace-wide auto-discovery via .github/agents
- Profile-global install option for cross-project availability
- Mermaid diagrams for agent architecture and workflow sequences
- Initial README.md with architecture overview
- Agent operating rules template
- Quick start guide for workspace/global installation
- Credits and acknowledgment of upstream simkeyur/vscode-agents

### Changed

- Renamed project folder from upstream fork structure
- Completed initial audit of agent prompts and tool definitions
- Migrated from burke-style external orchestration to native VS Code chat-agent model

## [0.0.1] - 2026-01-27

### Added

- Initial repository structure
- Fork from simkeyur/vscode-agents with extensions planned
- Basic prompts/ directory structure
- Initial project vision and scope definition

[Unreleased]: https://github.com/ddevalco/danes-agent-orchestra/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/ddevalco/danes-agent-orchestra/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/ddevalco/danes-agent-orchestra/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/ddevalco/danes-agent-orchestra/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/ddevalco/danes-agent-orchestra/releases/tag/v0.0.1
