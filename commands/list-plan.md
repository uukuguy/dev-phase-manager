---
description: Display comprehensive project status
---

# List Plan

Display comprehensive view of current work plan, phase status, and execution progress.

## Execution Steps

### 1. Read Phase Stack

Read phase information from `docs/dev/.phase_stack.json`:

```bash
if [ -f docs/dev/.phase_stack.json ]; then
  active_phases=$(jq '.active_phases' docs/dev/.phase_stack.json)
  suspended_phases=$(jq '.suspended_phases' docs/dev/.phase_stack.json)
else
  echo "⚠️ Phase stack file not found"
  echo "May not have executed /start-phase yet"
  echo ""
fi
```

### 2. Read Checkpoint

Read execution progress from `docs/plans/.checkpoint.json`:

```bash
if [ -f docs/plans/.checkpoint.json ]; then
  checkpoint=$(cat docs/plans/.checkpoint.json)
  plan_file=$(jq -r '.plan_file' <<< "$checkpoint")
  completed_tasks=$(jq -r '.completed_tasks[]' <<< "$checkpoint")
  current_task=$(jq -r '.current_task' <<< "$checkpoint")
  execution_mode=$(jq -r '.execution_mode' <<< "$checkpoint")
else
  echo "⚠️ Checkpoint file not found"
  echo "May not have executed /checkpoint-plan yet"
  echo ""
fi
```

### 3. Search Memory

Use MCP tools to search recent progress records:

```bash
# Search claude-mem
mcp__plugin_claude-mem_mcp-search__search \
  --query "Ouroboros phase" \
  --limit 5

# Search memory knowledge graph
mcp__memory__search_nodes \
  --query "Ouroboros"
```

### 4. Display Comprehensive Information

Integrate all information and display complete project status:

```
📋 Ouroboros Project Status

🟢 Active Phase:
  Phase 5 - MCP Server Implementation
  Started: 2026-02-22 15:00
  Plan: docs/plans/2026-02-22-mcp-server.md
  Progress: 3/10 tasks completed (30%)
  Current: Task 4 - Implement tool handlers
  Execution mode: subagent-driven-development

⏸️  Suspended Phases:
  Phase 4 - Cognitive Layer
  Started: 2026-02-22 10:00
  Suspended: 2026-02-22 15:00
  Reason: Starting urgent Phase 5
  Progress: 6/10 tasks completed (60%)
  Checkpoint: docs/plans/.checkpoint-phase4.json

📝 Recent Memory:
  1. [2026-02-22 15:00] Phase 5 started - MCP Server
  2. [2026-02-22 14:30] Phase 4 suspended - Waiting for MCP implementation
  3. [2026-02-22 12:00] Phase 4 progress - Completed FSM design
  4. [2026-02-22 10:00] Phase 4 started - Cognitive Layer
  5. [2026-02-21 18:00] Phase 3 completed - Cognitive Layer foundation

💡 Suggested Actions:
  1. Continue Phase 5: Execute Task 4
  2. If need to pause: /checkpoint-progress + /clear
  3. After completion: /end-phase
  4. Resume Phase 4: /start-phase --resume phase4

📂 Key Files:
  - Active plan: docs/plans/2026-02-22-mcp-server.md
  - Suspended plan: docs/plans/2026-02-21-cognitive-layer.md
  - Session guide: docs/dev/NEXT_SESSION_GUIDE.md
  - Work log: docs/dev/WORK_LOG.md
  - Phase stack: docs/dev/.phase_stack.json
```

### 5. Display Detailed Task List (Optional)

If user needs more detailed task information, parse task list from plan file:

```bash
if [ -n "$plan_file" ] && [ -f "$plan_file" ]; then
  echo ""
  echo "📋 Task Details:"
  echo ""

  # Parse tasks from plan file
  # Example: ### Task 1: Setup MCP server structure
  grep -E "^### Task [0-9]+:" "$plan_file" | while read -r line; do
    task_num=$(echo "$line" | sed 's/### Task \([0-9]\+\):.*/\1/')
    task_name=$(echo "$line" | sed 's/### Task [0-9]\+: //')

    # Check if completed
    if echo "$completed_tasks" | grep -q "Task $task_num"; then
      echo "  ✅ Task $task_num: $task_name"
    elif [ "$current_task" = "Task $task_num" ]; then
      echo "  🔄 Task $task_num: $task_name (in progress)"
    else
      echo "  ⬜ Task $task_num: $task_name"
    fi
  done
fi
```

## Use Cases

### Scenario 1: View current status

```bash
/list-plan
# → Display active phases, suspended phases, progress, memory
```

### Scenario 2: Decide next action

```bash
/list-plan
# → View suggested actions
# → Execute corresponding commands based on suggestions
```

### Scenario 3: Understand status before resuming work

```bash
# New session starts
/list-plan
# → Understand last work progress
# → Decide which phase to continue
```

## Smart Features

### 1. Progress Visualization

Use progress bars or percentages to show completion:

```
Progress: ████████░░░░░░░░░░ 30% (3/10 tasks)
```

### 2. Priority Sorting

Sort suggested actions based on:
1. Active phases first
2. High-progress suspended phases next
3. New phases last

### 3. Timeline View

Display phase timeline:

```
Timeline:
  2026-02-22 10:00  Phase 4 started
  2026-02-22 14:30  Phase 4 suspended (60%)
  2026-02-22 15:00  Phase 5 started
  2026-02-22 18:00  Phase 5 in progress (30%)
```

### 4. Dependency Hints

If there are dependencies between phases, display hints:

```
⚠️ Dependencies:
  Phase 4 needs Phase 5 to complete before continuing
  Reason: Phase 4 needs to use MCP server
```

## Integration with Third-party Skills

**Does not modify third-party skills**, list-plan only handles:
1. Display phase status
2. Display execution progress
3. Display memory summary
4. Provide action suggestions

Does not involve superpowers skills.

## File Locations

- **Phase stack**: `docs/dev/.phase_stack.json`
- **Checkpoint**: `docs/plans/.checkpoint.json`
- **Plan files**: `docs/plans/YYYY-MM-DD-feature.md`
- **Session guide**: `docs/dev/NEXT_SESSION_GUIDE.md`
- **Work log**: `docs/dev/WORK_LOG.md`

## Notes

1. **Fault tolerance**: If some files don't exist, still display available information
2. **Performance**: Avoid reading oversized files, use grep/jq for efficient parsing
3. **Readability**: Use clear formatting and icons for quick understanding
4. **Actionability**: Provide specific next-step commands, not vague suggestions
