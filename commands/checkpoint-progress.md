---
description: Update execution progress to checkpoint
---

# Checkpoint Progress

Update checkpoint during execution, supporting pause and resume at any time.

## Use Cases

- Save progress after completing partial tasks
- Save before /clear when context approaches limit
- Save current state before switching to other work
- Create snapshot at any point during execution

## Execution Steps

### 1. Load Current Checkpoint

Read `docs/plans/.checkpoint.json`:

```bash
checkpoint_file="docs/plans/.checkpoint.json"

if [ ! -f "$checkpoint_file" ]; then
  echo "⚠️ Checkpoint file not found"
  echo ""
  echo "Please execute /checkpoint-plan first to create initial checkpoint"
  exit 1
fi
```

### 2. Collect Current Progress

Two methods to collect progress information:

#### Method A: Auto-detect (Recommended)

Auto-detect completed tasks from git log:

```bash
# Get recent commit messages
recent_commits=$(git log --oneline -20 --grep="Task" --grep="feat:" --grep="fix:")

# Parse task numbers
# Example: "feat: complete Task 3 - Implement handlers"
# Extract: Task 3
```

#### Method B: User Input

If auto-detection fails, ask user:

```
Please provide current progress information:

Completed tasks (comma-separated, e.g., Task 1, Task 2, Task 3):
>

Current task being executed (e.g., Task 4):
>

Execution mode (subagent-driven or executing-plans):
>
```

### 3. Update Checkpoint

Update `docs/plans/.checkpoint.json`:

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

**Updated fields**:
- `updated_at`: Current time
- `completed_tasks`: List of completed tasks
- `current_task`: Current task
- `execution_mode`: Execution mode (if previously null)
- `phase`: Update to `execution` if started
- `notes`: Update notes

### 4. Confirmation Output

Display updated progress:

```
✅ Progress saved

Completed: 3/10 tasks (30%)
  - Task 1: Setup MCP server structure
  - Task 2: Define tool interfaces
  - Task 3: Implement basic handlers

Current: Task 4 - Implement tool handlers
Execution mode: subagent-driven-development
Updated: 2026-02-22 18:15

Suggested next steps:
1. Continue current task
2. /clear - Clean context (if needed)
3. /resume-plan - Resume execution (after clear)
```

## Usage Examples

### Scenario 1: Periodic saves during execution

```bash
/resume-plan
/subagent-driven-development
# ... executed 3 tasks ...

/checkpoint-progress
# → Auto-detect: Completed Task 1, 2, 3
# → Save progress

# Continue execution
# ... executed 2 more tasks ...

/checkpoint-progress
# → Auto-detect: Completed Task 1, 2, 3, 4, 5
# → Update progress
```

### Scenario 2: Context approaching limit

```bash
# During execution...
# Claude warns: Context usage 85%

/checkpoint-progress
# → Save current progress
/clear
/resume-plan
# → Resume from saved progress
```

### Scenario 3: Switch work

```bash
# Working on Phase 5
/checkpoint-progress
# → Save Phase 5 progress

# Switch to urgent task
/start-phase "Hotfix - Critical Bug"
# ... handle urgent task ...
/end-phase

# Return to Phase 5
/resume-plan
# → Restore Phase 5 progress
```

## Smart Features

### 1. Auto-detect Completed Tasks

Intelligently parse tasks from git log:

```bash
# Supported commit message formats:
# - "feat: complete Task 3 - Implement handlers"
# - "Task 3: Implement handlers"
# - "Complete Task 3"
# - "feat(mcp): Task 3 - handlers"

# Extraction rules:
# 1. Find commits containing "Task N"
# 2. Extract task number N
# 3. Sort by number
# 4. Generate completed task list
```

### 2. Progress Validation

Validate progress reasonableness:

```
⚠️ Progress validation

Detected completed tasks: Task 1, Task 2, Task 4
Missing: Task 3

Possible reasons:
1. Task 3 commit message format is non-standard
2. Task 3 was actually skipped

Accept this progress? (y/n)
If n, will manually input progress
```

### 3. Phase Stack Integration

If phase stack exists, update corresponding phase progress:

```bash
# Update active phase in docs/dev/.phase_stack.json
{
  "active_phases": [
    {
      "name": "Phase 5 - MCP Server",
      "started_at": "2026-02-22T15:00:00+08:00",
      "checkpoint": "docs/plans/.checkpoint.json",
      "guide": "docs/dev/NEXT_SESSION_GUIDE.md",
      "progress": "30%",  # Added
      "last_updated": "2026-02-22T18:15:00+08:00"  # Added
    }
  ]
}
```

## Automation Suggestions

### Hook Integration (Optional)

Can create hooks to auto-prompt checkpoint at specific times:

```yaml
# hooks/auto-checkpoint-reminder.yaml
name: auto-checkpoint-reminder
event: PostToolUse
tool: Bash
prompt: |
  If git commit command executed successfully,
  and commit message contains "Task" or "feat:" or "fix:",
  prompt user to consider executing /checkpoint-progress to save progress.

  Prompt format:
  "💡 Tip: You can execute /checkpoint-progress to save current progress"
```

But this is **optional**, users can fully control when to checkpoint manually.

## Integration with Third-party Skills

**Does not modify third-party skills**, checkpoint-progress runs independently:

```
subagent-driven-development (superpowers)
  ↓ Execute tasks
  ↓ git commit
  ↓
checkpoint-progress (user-defined)
  ↓ Read git log
  ↓ Update checkpoint
  ↓
Continue execution or clear
```

## File Locations

- **Checkpoint file**: `docs/plans/.checkpoint.json`
- **Phase stack file**: `docs/dev/.phase_stack.json` (optional)

## Notes

1. **Auto-detect priority**: Prioritize git log auto-detection to reduce user input
2. **Validate reasonableness**: Detected progress should be continuous (Task 1, 2, 3...)
3. **Preserve history**: Consider saving checkpoint history to `.checkpoint.history.json`
4. **Idempotency**: Multiple calls should be safe, won't corrupt data
