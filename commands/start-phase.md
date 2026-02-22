---
description: Start new phase or resume suspended phase
args:
  - name: phase_name
    description: Phase name (optional, e.g., "Phase 5 - MCP Server")
    required: false
  - name: resume
    description: Resume suspended phase (optional, e.g., "phase4")
    required: false
---

# Start Phase

Start new phase work, supporting phase stack management and pause/resume.

## Execution Steps

### 1. Read Phase Stack

Read `docs/dev/.phase_stack.json` (if exists):

```json
{
  "active_phases": [
    {
      "name": "Phase 4 - Cognitive Layer",
      "started_at": "2026-02-22T10:00:00+08:00",
      "checkpoint": "docs/plans/.checkpoint-phase4.json",
      "guide": "docs/dev/NEXT_SESSION_GUIDE-phase4.md",
      "progress": "60%"
    }
  ],
  "suspended_phases": []
}
```

If file doesn't exist, create initial structure.

### 2. Handle Resume Suspended Phase

If `--resume` parameter provided:

```bash
# Find specified phase in suspended_phases
# Restore checkpoint and NEXT_SESSION_GUIDE
# Move to active_phases
```

Display resume information:

```
✅ Resumed phase: Phase 4 - Cognitive Layer

Suspended: 2026-02-22 15:00
Progress: 6/10 tasks completed (60%)
Checkpoint: docs/plans/.checkpoint-phase4.json
Guide: docs/dev/NEXT_SESSION_GUIDE-phase4.md

Restored files:
- .checkpoint-phase4.json → .checkpoint.json
- NEXT_SESSION_GUIDE-phase4.md → NEXT_SESSION_GUIDE.md

Suggested next steps:
1. /resume-plan - View execution progress
2. /list-plan - View complete plan
```

Then skip to step 4 (Read NEXT_SESSION_GUIDE).

### 3. Detect Active Phase Conflict

If there's an active phase and user provided new `phase_name`:

```
⚠️ Active phase detected: Phase 4 - Cognitive Layer
Started: 2026-02-22 10:00
Progress: 60%

You want to start new phase: Phase 5 - MCP Server

Options:
1. Continue current phase Phase 4 (recommended)
2. Suspend Phase 4, start Phase 5
3. Cancel, execute /end-phase first to end Phase 4

Please select (1/2/3):
```

**Option 1**: Ignore new phase name, continue current phase
**Option 2**: Suspend current phase (see step 3.1)
**Option 3**: Exit, let user end-phase first

#### 3.1 Suspend Current Phase

If user chooses to suspend:

```bash
# 1. Backup current files
if [ -f docs/plans/.checkpoint.json ]; then
  mv docs/plans/.checkpoint.json docs/plans/.checkpoint-phase4.json
fi

if [ -f docs/dev/NEXT_SESSION_GUIDE.md ]; then
  mv docs/dev/NEXT_SESSION_GUIDE.md docs/dev/NEXT_SESSION_GUIDE-phase4.md
fi

# 2. Update phase stack
# Move current phase from active_phases to suspended_phases
```

Display suspension information:

```
⏸️  Suspended phase: Phase 4 - Cognitive Layer

Suspended: 2026-02-22 15:00
Progress: 60%
Reason: Starting Phase 5 - MCP Server

Saved files:
- .checkpoint.json → .checkpoint-phase4.json
- NEXT_SESSION_GUIDE.md → NEXT_SESSION_GUIDE-phase4.md

Tip: After completing Phase 5, use /start-phase --resume phase4 to restore
```

### 4. Read NEXT_SESSION_GUIDE

Read `docs/dev/NEXT_SESSION_GUIDE.md` (if exists):

```bash
if [ -f docs/dev/NEXT_SESSION_GUIDE.md ]; then
  echo "📖 Reading session guide..."
  cat docs/dev/NEXT_SESSION_GUIDE.md
fi
```

Display key information:
- Current status
- Completion checklist
- Next step priorities
- Key code paths

### 5. Load Memory

Use MCP tools to load project memory:

```bash
# 1. Search recent work memory
mcp__plugin_claude-mem_mcp-search__search \
  --query "Ouroboros phase" \
  --limit 5

# 2. Search architecture decisions and technical conventions
mcp__memory__search_nodes \
  --query "Ouroboros architecture"
```

Briefly report loaded key context (2-3 sentences):

```
💡 Memory loaded

Recent progress:
- Phase 4 60% completed, implemented FSM base architecture
- Using PydanticAI as cognitive layer framework
- Next step needs MCP server integration

Architecture decisions:
- Adopted bilingual architecture (Python + TypeScript)
- Using FastMCP as MCP server framework
```

### 6. Update Phase Stack

Add new phase to `active_phases`:

```json
{
  "active_phases": [
    {
      "name": "Phase 5 - MCP Server",
      "started_at": "2026-02-22T15:00:00+08:00",
      "checkpoint": "docs/plans/.checkpoint.json",
      "guide": "docs/dev/NEXT_SESSION_GUIDE.md",
      "progress": "0%"
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
      "reason": "Starting Phase 5 - MCP Server"
    }
  ]
}
```

### 7. Display Startup Summary

```
✅ Phase started: Phase 5 - MCP Server

Started: 2026-02-22 15:00
Phase stack: 1 active, 1 suspended

⏸️  Suspended phases:
  Phase 4 - Cognitive Layer (60% completed)

📋 Work focus:
- When calling external SDKs, use Context7 to query SDK usage and correct function signatures
- For major architecture-level adjustments, update design documents promptly

Suggested next steps:
1. /brainstorming - Discuss design approach
2. /writing-plans - Create implementation plan
3. /list-plan - View complete plan
```

## Use Cases

### Scenario 1: Start new phase (no conflict)

```bash
/start-phase "Phase 5 - MCP Server"
# → No active phase
# → Directly start Phase 5
```

### Scenario 2: Start new phase (with conflict)

```bash
# Phase 4 in progress
/start-phase "Phase 5 - MCP Server"
# → Detect Phase 4 active
# → Ask: Continue/Suspend/Cancel
# → Select: Suspend
# → Phase 4 suspended, Phase 5 started
```

### Scenario 3: Resume suspended phase

```bash
/start-phase --resume phase4
# → Restore Phase 4 from suspended_phases
# → Restore checkpoint and NEXT_SESSION_GUIDE
# → Phase 4 becomes active again
```

### Scenario 4: Continue current phase

```bash
/start-phase
# → No phase_name provided
# → Continue current active phase
# → Reload memory and guide
```

## File Management

- **Phase stack**: `docs/dev/.phase_stack.json`
- **Active phase guide**: `docs/dev/NEXT_SESSION_GUIDE.md`
- **Suspended phase guide**: `docs/dev/NEXT_SESSION_GUIDE-{phase_id}.md`
- **Active phase checkpoint**: `docs/plans/.checkpoint.json`
- **Suspended phase checkpoint**: `docs/plans/.checkpoint-{phase_id}.json`

## Integration with Third-party Skills

**Does not modify third-party skills**, start-phase only handles:
1. Phase stack management
2. Document preparation
3. Memory loading

Subsequent brainstorming, writing-plans, etc. still use original superpowers.

## Notes

1. **Phase ID**: Generated from phase name (e.g., "Phase 4" → "phase4")
2. **File naming**: Use phase ID as suffix (e.g., `.checkpoint-phase4.json`)
3. **Idempotency**: Multiple calls should be safe
4. **Cleanup**: Clean up suspended phase files during end-phase
