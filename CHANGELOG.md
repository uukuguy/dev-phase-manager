# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-22

### Added
- Initial release of Phase Manager
- Checkpoint system for state persistence across `/clear` operations
- Phase stack management for multi-phase parallel workflows
- Six core commands:
  - `/dev-phase-manager:checkpoint-plan` - Save plan execution state
  - `/dev-phase-manager:resume-plan` - Resume from checkpoint
  - `/dev-phase-manager:checkpoint-progress` - Update execution progress
  - `/dev-phase-manager:start-phase` - Start or resume phases
  - `/dev-phase-manager:end-phase` - Complete phase with cleanup
  - `/dev-phase-manager:list-plan` - Display comprehensive status
- Non-invasive integration with superpowers plugin
- Automatic progress detection from git history
- Idempotency checks and safety features
- Comprehensive documentation and examples

### Features
- **Checkpoint System**: Save and restore plan execution state
- **Phase Stack**: Manage active and suspended phases
- **Superpowers Integration**: Works seamlessly with brainstorming, writing-plans, subagent-driven-development
- **Smart Recovery**: Resume execution with full context restoration
- **Memory Integration**: Saves to claude-mem and memory MCP servers

### Documentation
- Professional README with detailed usage examples
- Complete command reference
- Architecture documentation
- Use case scenarios
- Integration guides

[1.0.0]: https://github.com/uukuguy/dev-phase-manager/releases/tag/v1.0.0
