# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-23

### Added
- **commands/ directory restored**: Thin wrapper layer for user-facing command entry points, following superpowers' dual-layer architecture (commands/ + skills/)
- **`/mem-save` command**: Save work memory to claude-mem, knowledge graph, and local MEMORY_INDEX.md
- **`/mem-search` command**: Search and browse memories with local index priority over MCP search
- **MEMORY_INDEX.md**: Local browsable memory index file at `docs/dev/MEMORY_INDEX.md` with phase-based archiving

### Enhanced
- **`/list-plan`**: Added real-time status collection (git log, git diff, MEMORY_INDEX.md) with checkpoint staleness detection
- **`/start-phase`**: Added auto-resume detection for orphaned checkpoints; reads MEMORY_INDEX.md for quick context recovery
- **`/end-phase`**: Added memory archiving — moves [Active Work] entries to completed phase sections in MEMORY_INDEX.md
- **`/checkpoint-progress`**: Added `/mem-save` hint in suggested next steps

### Architecture
- Restored commands/skills dual-layer structure: `commands/*.md` (thin wrappers) + `skills/*/SKILL.md` (full logic)
- Added Memory Management Layer with MEMORY_INDEX.md as primary local index
- MCP memory search demoted to optional fallback when local index exists

### Synced
- Updated 6 standalone commands in `~/.claude/commands/` with matching enhancements

[1.1.0]: https://github.com/uukuguy/dev-phase-manager/releases/tag/v1.1.0

## [1.0.0] - 2026-02-22

### Added
- Initial release of Phase Manager
- Checkpoint system for state persistence across `/clear` operations
- Phase stack management for multi-phase parallel workflows
- Six core commands:
  - `/checkpoint-plan` - Save plan execution state
  - `/resume-plan` - Resume from checkpoint
  - `/checkpoint-progress` - Update execution progress
  - `/start-phase` - Start or resume phases
  - `/end-phase` - Complete phase with cleanup
  - `/list-plan` - Display comprehensive status
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
