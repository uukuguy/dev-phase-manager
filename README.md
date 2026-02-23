# Dev Phase Manager

> Professional phase and checkpoint management system for Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blue.svg)](https://github.com/anthropics/claude-code)
[![Version](https://img.shields.io/badge/version-1.1.0-green.svg)](https://github.com/uukuguy/dev-phase-manager/releases)

Dev Phase Manager is a non-invasive workflow enhancement plugin for Claude Code that enables context-aware, multi-phase development workflows with intelligent checkpoint management.

## 🎯 Key Features

### 📍 Checkpoint System
- **State Persistence**: Save plan execution state across `/clear` operations
- **Automatic Progress Detection**: Parse completed tasks from git history
- **Seamless Recovery**: Resume execution from saved checkpoints without context loss

### 🔄 Phase Stack Management
- **Multi-Phase Parallel**: Suspend current phase to start urgent work
- **Phase Hierarchy**: Manage active and suspended phases with stack-based approach
- **Smart Recovery**: Resume suspended phases with full context restoration

### 🤝 Superpowers Integration
- **Non-Invasive Design**: Works alongside superpowers without modifications
- **Enhanced Workflow**: Integrates with `brainstorming`, `writing-plans`, `subagent-driven-development`
- **File-Based State**: Uses filesystem for state transfer, maintaining clean separation

### 🛡️ Idempotency & Safety
- **Duplicate Prevention**: Prevents accidental repeated operations
- **Graceful Degradation**: Works even when files are missing
- **Smart Prompts**: Intelligent confirmations and suggestions

## 📦 Installation

### Method 1: From GitHub (Recommended)

```bash
# Add GitHub repository as marketplace
claude plugin marketplace add uukuguy/dev-phase-manager

# Install the plugin
claude plugin install dev-phase-manager
```

### Method 2: Local Development

```bash
# Clone the repository
git clone https://github.com/uukuguy/dev-phase-manager.git

# Add local directory as marketplace
claude plugin marketplace add /path/to/dev-phase-manager

# Install the plugin
claude plugin install dev-phase-manager
```

## 🚀 Quick Start

### Basic Workflow

```bash
# 1. Start a new phase
/start-phase "Phase 1 - Feature Implementation"

# 2. Design and plan
/brainstorming
/writing-plans

# 3. Save checkpoint before clearing context
/checkpoint-plan
/clear

# 4. Resume execution
/resume-plan
/subagent-driven-development

# 5. Complete phase
/end-phase
```

### Multi-Phase Workflow

```bash
# Start Phase 1
/start-phase "Phase 1 - Core Features"
# ... work on Phase 1 ...

# Urgent: Start Phase 2 (suspends Phase 1)
/start-phase "Phase 2 - Critical Bugfix"
# → Prompts: Suspend Phase 1? (y)
# ... complete Phase 2 ...
/end-phase

# Resume Phase 1
/start-phase --resume phase1
# ... complete Phase 1 ...
/end-phase
```

## 🏛️ Architecture: Commands + Skills

Dev Phase Manager follows the **dual-layer architecture** pattern (same as superpowers):

```
dev-phase-manager/
├── commands/                    ← User entry points (thin wrappers)
│   ├── start-phase.md           ← One-line: invoke skill
│   ├── end-phase.md
│   ├── list-plan.md
│   ├── checkpoint-plan.md
│   ├── checkpoint-progress.md
│   ├── resume-plan.md
│   ├── mem-save.md              ← NEW in v1.1.0
│   └── mem-search.md            ← NEW in v1.1.0
└── skills/                      ← Full skill logic
    ├── start-phase/SKILL.md
    ├── end-phase/SKILL.md
    ├── list-plan/SKILL.md
    ├── checkpoint-plan/SKILL.md
    ├── checkpoint-progress/SKILL.md
    ├── resume-plan/SKILL.md
    ├── mem-save/SKILL.md         ← NEW in v1.1.0
    └── mem-search/SKILL.md       ← NEW in v1.1.0
```

**commands/*.md** are thin wrappers that invoke the corresponding skill:
```yaml
---
description: "Start new phase or resume suspended phase"
disable-model-invocation: true
---
Invoke the dev-phase-manager:start-phase skill and follow it exactly as presented to you
```

**skills/*/SKILL.md** contain the complete behavior definition with all execution steps.

## 📚 Commands Reference

### Core Commands

#### `/checkpoint-plan`
Save current plan execution state to filesystem.

**Usage:**
```bash
/checkpoint-plan
```

**What it does:**
- Locates latest plan file in `docs/plans/`
- Collects execution state (phase, completed tasks, current task)
- Saves to `docs/plans/.checkpoint.json`
- Enables recovery after `/clear`

**Output:**
```
✅ Checkpoint saved

Plan: Phase 5 - MCP Server
File: docs/plans/2026-02-22-mcp-server.md
Phase: design
Status: Design completed, ready for execution

Next steps:
1. /clear - Clear context
2. /resume-plan - Resume execution
```

---

#### `/resume-plan`
Resume plan execution from saved checkpoint.

**Usage:**
```bash
/resume-plan
```

**What it does:**
- Loads checkpoint from `docs/plans/.checkpoint.json`
- Displays progress summary
- Prompts for execution mode selection
- Loads plan content into context

**Output:**
```
📋 Resume Plan Execution

Phase: Phase 5 - MCP Server
Plan: docs/plans/2026-02-22-mcp-server.md
Status: design → execution
Progress: 0/10 tasks completed
Next: Task 1 - Setup MCP server structure

Choose execution mode:
1. subagent-driven-development
2. executing-plans

Please execute: /subagent-driven-development
```

---

#### `/checkpoint-progress`
Update execution progress during implementation.

**Usage:**
```bash
/checkpoint-progress
```

**What it does:**
- Auto-detects completed tasks from git log
- Updates checkpoint with current progress
- Supports manual input if auto-detection fails

**Output:**
```
✅ Progress saved

Completed: 3/10 tasks (30%)
  - Task 1: Setup MCP server structure
  - Task 2: Define tool interfaces
  - Task 3: Implement basic handlers

Current: Task 4 - Implement tool handlers
Mode: subagent-driven-development

Next steps:
1. Continue current task
2. /clear - Clear context (if needed)
3. /resume-plan - Resume after clear
```

---

#### `/start-phase`
Start a new phase or resume a suspended phase.

**Usage:**
```bash
# Start new phase
/start-phase "Phase 5 - MCP Server"

# Resume suspended phase
/start-phase --resume phase4

# Continue current phase
/start-phase
```

**Arguments:**
- `phase_name` (optional): Name of the new phase
- `--resume <phase_id>` (optional): Resume suspended phase

**What it does:**
- Reads phase stack from `docs/dev/.phase_stack.json`
- Detects conflicts with active phases
- Manages phase suspension and resumption
- Loads memory and session guide

**Output:**
```
✅ Phase started: Phase 5 - MCP Server

Start time: 2026-02-22 15:00
Phase stack: 1 active, 1 suspended

⏸️  Suspended phases:
  Phase 4 - Cognitive Layer (60% complete)

Next steps:
1. /brainstorming - Discuss design
2. /writing-plans - Create implementation plan
3. /list-plan - View complete plan
```

---

#### `/end-phase`
Complete current phase with proper cleanup.

**Usage:**
```bash
/end-phase
```

**What it does:**
- Idempotency check (prevents duplicate operations)
- Saves memory to claude-mem and memory MCP
- Updates `docs/dev/WORK_LOG.md`
- Updates `docs/dev/NEXT_SESSION_GUIDE.md`
- Commits documentation changes to git
- Cleans up phase stack
- Prompts to resume suspended phases

**Output:**
```
✅ Phase 5 completed

Memory saved
Documentation updated
Git committed

⏸️  Suspended phases detected:
  Phase 4 - Cognitive Layer
  Suspended: 2026-02-22 15:00
  Progress: 60%

Suggested actions:
1. /start-phase --resume phase4 - Resume
2. /clear - Clear context first
3. /list-plan - View all phases

Resume phase4 now? (y/n)
```

---

#### `/list-plan`
Display comprehensive project status.

**Usage:**
```bash
/list-plan
```

**What it does:**
- Reads phase stack status
- Reads checkpoint progress
- Searches recent memories
- Displays comprehensive status view

**Output:**
```
📋 Project Status

🟢 Active Phase:
  Phase 5 - MCP Server Implementation
  Started: 2026-02-22 15:00
  Plan: docs/plans/2026-02-22-mcp-server.md
  Progress: 3/10 tasks (30%)
  Current: Task 4 - Implement tool handlers
  Mode: subagent-driven-development

⏸️  Suspended Phases:
  Phase 4 - Cognitive Layer
  Started: 2026-02-22 10:00
  Suspended: 2026-02-22 15:00
  Reason: Starting urgent Phase 5
  Progress: 6/10 tasks (60%)

📝 Recent Memory:
  1. [2026-02-22 15:00] Phase 5 started
  2. [2026-02-22 14:30] Phase 4 suspended
  3. [2026-02-22 12:00] Phase 4 progress - FSM design

💡 Suggested Actions:
  1. Continue Phase 5: Execute Task 4
  2. If needed: /checkpoint-progress + /clear
  3. When done: /end-phase
  4. Resume Phase 4: /start-phase --resume phase4

📂 Key Files:
  - Active plan: docs/plans/2026-02-22-mcp-server.md
  - Session guide: docs/dev/NEXT_SESSION_GUIDE.md
  - Work log: docs/dev/WORK_LOG.md
  - Phase stack: docs/dev/.phase_stack.json
```

---

#### `/mem-save`
Save current work memory to multiple backends with local index tracking.

**Usage:**
```bash
/mem-save
```

**What it does:**
- Summarizes current progress (2-3 sentences)
- Saves to claude-mem and knowledge graph
- Appends entry to `docs/dev/MEMORY_INDEX.md`
- Does NOT create git commits

**Output:**
```
Memory saved

Saved to:
- claude-mem: "[Project] Memory Save - [Achievement]"
- knowledge graph: Updated observations
- MEMORY_INDEX.md: Added entry to [Active Work]

Summary:
- Completed: Feature X implementation
- In progress: Integration testing
- Next steps: Run full test suite
```

---

#### `/mem-search`
Search and browse work memories with local index priority.

**Usage:**
```bash
# Browse recent memories
/mem-search

# Search specific topic
/mem-search architecture
```

**What it does:**
- Reads `docs/dev/MEMORY_INDEX.md` first (local, fast, browsable)
- Searches claude-mem and knowledge graph as supplement
- Merges and displays results with local index first

**Output:**
```
Memory Search Results

Local Index (MEMORY_INDEX.md):
  [Active Work]
  - 15:30 | Completed MCP server integration
  - 14:00 | Architecture decision: FastMCP

  claude-mem:
  - [2026-02-22] Phase 4 completed

  Knowledge Graph:
  - Ouroboros: bilingual architecture (Python + TypeScript)
```

---

## 🏗️ Architecture

### File Structure

```
docs/
├── dev/
│   ├── .phase_stack.json              # Phase stack (active/suspended)
│   ├── MEMORY_INDEX.md                # Local memory index (NEW in v1.1.0)
│   ├── NEXT_SESSION_GUIDE.md          # Active phase guide
│   ├── NEXT_SESSION_GUIDE-phase4.md   # Suspended phase guide
│   └── WORK_LOG.md                    # Work log
└── plans/
    ├── .checkpoint.json               # Active phase checkpoint
    ├── .checkpoint-phase4.json        # Suspended phase checkpoint
    ├── .checkpoint.archive.json       # Archived checkpoint
    └── 2026-02-22-feature.md          # Plan file
```

### Phase Stack Format

```json
{
  "active_phases": [
    {
      "name": "Phase 5 - MCP Server",
      "started_at": "2026-02-22T15:00:00+08:00",
      "checkpoint": "docs/plans/.checkpoint.json",
      "guide": "docs/dev/NEXT_SESSION_GUIDE.md",
      "progress": "30%"
    }
  ],
  "suspended_phases": [
    {
      "name": "Phase 4 - Cognitive Layer",
      "started_at": "2026-02-22T10:00:00+08:00",
      "suspended_at": "2026-02-22T15:00:00+08:00",
      "checkpoint": "docs/plans/.checkpoint-phase4.json",
      "guide": "docs/dev/NEXT_SESSION_GUIDE-phase4.md",
      "progress": "60%",
      "reason": "Starting urgent Phase 5"
    }
  ]
}
```

### Checkpoint Format

```json
{
  "plan_file": "docs/plans/2026-02-22-mcp-server.md",
  "phase": "execution",
  "created_at": "2026-02-22T17:30:00+08:00",
  "updated_at": "2026-02-22T18:15:00+08:00",
  "completed_tasks": ["Task 1", "Task 2", "Task 3"],
  "current_task": "Task 4",
  "execution_mode": "subagent-driven",
  "phase_name": "Phase 5 - MCP Server",
  "notes": "Completed 3/10 tasks, continuing with Task 4"
}
```

## 🔗 Integration with Superpowers

Phase Manager is designed to work seamlessly with the [superpowers](https://github.com/coleam00/superpowers) plugin:

### Enhanced Workflow

```
start-phase (Phase Manager)
  ↓
brainstorming (Superpowers)
  ↓
writing-plans (Superpowers)
  ↓
checkpoint-plan (Phase Manager)
  ↓
clear
  ↓
resume-plan (Phase Manager)
  ↓
subagent-driven-development (Superpowers)
  OR
executing-plans (Superpowers)
  ↓
checkpoint-progress (Phase Manager)
  ↓
end-phase (Phase Manager)
```

### Non-Invasive Design

- **No Modifications**: Superpowers skills remain unchanged
- **File-Based State**: Uses filesystem for state transfer
- **Clean Separation**: Clear responsibility boundaries
- **User Control**: Manual skill composition for flexibility

## 📖 Use Cases

### Use Case 1: Long-Running Feature Development

**Scenario**: Implementing a complex feature that requires multiple sessions.

```bash
# Session 1: Design
/start-phase "Feature X Implementation"
/brainstorming
/writing-plans
/checkpoint-plan
/clear

# Session 2: Implementation (Part 1)
/resume-plan
/subagent-driven-development
# ... complete 5/10 tasks ...
/checkpoint-progress
/clear

# Session 3: Implementation (Part 2)
/resume-plan
/subagent-driven-development
# ... complete remaining tasks ...
/end-phase
```

**Benefits**:
- Context preserved across sessions
- Progress tracked automatically
- No manual state management

---

### Use Case 2: Urgent Interruption Handling

**Scenario**: Working on Feature A when critical bug requires immediate attention.

```bash
# Working on Feature A
/start-phase "Feature A"
# ... 60% complete ...

# Critical bug discovered
/start-phase "Hotfix - Critical Bug"
# → Suspend Feature A? (y)
# ... fix bug ...
/end-phase

# Resume Feature A
/start-phase --resume featurea
/resume-plan
# ... complete Feature A ...
/end-phase
```

**Benefits**:
- No context loss when switching
- Clear phase hierarchy
- Easy resumption

---

### Use Case 3: Context Management

**Scenario**: Context approaching limit during implementation.

```bash
/resume-plan
/subagent-driven-development
# ... context at 85% ...

# Save and clear
/checkpoint-progress
/clear

# Resume with fresh context
/resume-plan
/subagent-driven-development
# ... continue seamlessly ...
```

**Benefits**:
- Prevents context overflow
- Seamless continuation
- No manual state tracking

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

```bash
# Clone repository
git clone https://github.com/uukuguy/dev-phase-manager.git
cd phase-manager

# Link to Claude Code plugins directory
ln -s $(pwd) ~/.claude/plugins/phase-manager

# Test commands
/list-plan
```

### Guidelines

- Follow existing code style
- Add tests for new features
- Update documentation
- Keep commands idempotent
- Maintain backward compatibility

## ❓ FAQ

### How is this different from superpowers?

**Complementary, not competing:**
- **Superpowers**: Core development skills (TDD, debugging, planning, code review)
- **Dev Phase Manager**: Phase and checkpoint management for long-running workflows

Dev Phase Manager is designed to **enhance** superpowers workflows by adding state persistence across `/clear` operations.

### Do I need superpowers to use this plugin?

**No, but recommended.** Dev Phase Manager works standalone, but it's designed to integrate seamlessly with superpowers workflows like:
- `/brainstorming` → `/writing-plans` → `/checkpoint-plan` → `/clear` → `/resume-plan` → `/subagent-driven-development`

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Claude Code](https://github.com/anthropics/claude-code) - The amazing CLI tool
- [Superpowers](https://github.com/coleam00/superpowers) - Inspiration for workflow enhancement
- Community contributors and testers

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/uukuguy/dev-phase-manager/issues)
- **Discussions**: [GitHub Discussions](https://github.com/uukuguy/dev-phase-manager/discussions)
- **Documentation**: [Wiki](https://github.com/uukuguy/dev-phase-manager/wiki)

## 🗺️ Roadmap

- [x] v1.1: Memory enhancement + commands/ restoration
- [ ] v1.2: Progress visualization with progress bars
- [ ] v1.3: Phase dependency management
- [ ] v1.4: Timeline view for phase history
- [ ] v2.0: Web UI for phase management

---

**Made with ❤️ for the Claude Code community**
