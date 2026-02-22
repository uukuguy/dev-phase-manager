---
description: Save plan execution state for recovery after clear
---

# Checkpoint Plan

Save current plan execution state to filesystem, enabling seamless workflow continuation across `/clear` operations.

## Execution Steps

### 1. Locate Plan File

Check `docs/plans/` directory for the latest plan file:

```bash
# Find the most recent plan file
latest_plan=$(ls -t docs/plans/*.md 2>/dev/null | grep -v "\.checkpoint" | head -1)

if [ -z "$latest_plan" ]; then
  echo "⚠️ No plan file found"
  echo ""
  echo "Please do one of the following:"
  echo "1. /writing-plans - Create new plan"
  echo "2. Manually create plan file in docs/plans/"
  exit 1
fi
```

### 2. Collect State Information

Gather state from current context and filesystem:

- **Plan file path**: From step 1
- **Current phase**:
  - If not started → `design`
  - If executing → `execution`
  - If completed → `review`
- **Completed tasks**: From git log or user input
- **Current task**: From user input
- **Execution mode**: `subagent-driven` or `executing-plans` or `null`
- **Phase name**: From phase stack or user input

### 3. Save Checkpoint

Create or update `docs/plans/.checkpoint.json`:

```json
{
  "plan_file": "docs/plans/2026-02-22-mcp-server.md",
  "phase": "design",
  "created_at": "2026-02-22T17:30:00+08:00",
  "updated_at": "2026-02-22T17:30:00+08:00",
  "completed_tasks": [],
  "current_task": null,
  "execution_mode": null,
  "phase_name": "Phase 5 - MCP Server",
  "notes": "Design phase completed, ready for execution"
}
```

**Field Descriptions**:
- `plan_file`: Relative path to plan file
- `phase`: Current phase (`design` | `execution` | `review`)
- `created_at`: First creation time (ISO 8601 format)
- `updated_at`: Last update time (ISO 8601 format)
- `completed_tasks`: Array of completed tasks
- `current_task`: Current task (string or null)
- `execution_mode`: Execution mode (`subagent-driven` | `executing-plans` | null)
- `phase_name`: Phase name for display
- `notes`: Optional notes

### 4. Confirmation Output

Display success information:

```
✅ Checkpoint saved

Plan: Phase 5 - MCP Server
File: docs/plans/2026-02-22-mcp-server.md
Phase: design
Status: Design completed, ready for execution

Next steps:
1. /clear - Clear context
2. /dev-phase-manager:resume-plan - Resume execution
```

## Use Cases

### Case 1: After Design Completion

```bash
/brainstorming
/writing-plans
/dev-phase-manager:checkpoint-plan    # Save design phase state
/clear
/dev-phase-manager:resume-plan        # Start execution
```

### Case 2: During Execution

```bash
/dev-phase-manager:resume-plan
/subagent-driven-development
# ... executed 3 tasks ...
/dev-phase-manager:checkpoint-plan    # Save execution progress
/clear
/dev-phase-manager:resume-plan        # Continue execution
```

### Case 3: Switching Work

```bash
# Working on Phase 5
/dev-phase-manager:checkpoint-plan    # Save current progress
# Switch to other work
# Later return
/dev-phase-manager:resume-plan        # Resume Phase 5
```

## Integration with Third-Party Skills

**Non-invasive design** - integrates through workflow composition:

```
writing-plans (superpowers)
  ↓
checkpoint-plan (user-defined)
  ↓
clear
  ↓
resume-plan (user-defined)
  ↓
subagent-driven-development (superpowers)
```

## File Locations

- **Checkpoint file**: `docs/plans/.checkpoint.json`
- **Plan file**: `docs/plans/YYYY-MM-DD-feature.md` (created by writing-plans)
- **Phase stack file**: `docs/dev/.phase_stack.json` (managed by start-phase)

## Notes

1. **Auto-detection**: Automatically detect completed tasks from git log when possible
2. **User confirmation**: Ask user for current progress if auto-detection fails
3. **Overwrite warning**: Warn user if checkpoint already exists
4. **Backup suggestion**: Recommend periodic checkpoint file backups
