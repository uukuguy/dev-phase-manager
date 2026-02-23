---
name: resume-plan
description: Resume plan execution from checkpoint
---

# Resume Plan

Resume plan execution from saved checkpoint, enabling seamless continuation after /clear.

## Use Cases

- Resume work after clearing context
- Continue execution from saved progress
- Switch between different execution modes
- Recover from interrupted sessions

## Execution Steps

### 1. Load Checkpoint

Read `docs/plans/.checkpoint.json`:

```bash
checkpoint_file="docs/plans/.checkpoint.json"

if [ ! -f "$checkpoint_file" ]; then
  echo "⚠️ Checkpoint file not found"
  echo ""
  echo "Possible reasons:"
  echo "1. /checkpoint-plan was never executed"
  echo "2. Checkpoint has been cleaned up"
  echo ""
  echo "Suggested actions:"
  echo "1. /list-plan - View current plan"
  echo "2. /writing-plans - Create new plan"
  exit 1
fi
```

### 2. Load Plan File

Read the plan file path from checkpoint and load plan content into context.

### 3. Display Progress Summary

Show detailed progress information based on checkpoint content:

```
📋 Resuming Plan Execution

Phase: Phase 5 - MCP Server
Plan: docs/plans/2026-02-22-mcp-server.md
Status: design → execution
Created: 2026-02-22 17:30
Updated: 2026-02-22 17:30

Progress: 0/10 tasks completed
Next: Task 1 - Setup MCP server structure

Notes: Design phase completed, ready for execution
```

**Progress Calculation**:
- If `completed_tasks` is empty → `0/N tasks completed`
- If tasks are completed → `X/N tasks completed (X/N * 100%)`
- Parse total task count N from plan file

### 4. Select Execution Mode

If `execution_mode` in checkpoint is null, ask user to choose:

```
Please select execution mode:

1. subagent-driven-development
   - Execute in current session
   - Spawn new subagent per task
   - Automatic review (spec + code quality)
   - Fast continuous execution
   - Best for: Independent tasks, auto-verifiable

2. executing-plans
   - Execute in current session
   - Batch execution (default 3 tasks)
   - Manual checkpoints
   - Best for: Scenarios requiring manual review

Enter 1 or 2:
```

If checkpoint already has `execution_mode`, display and ask whether to continue:

```
Last execution mode: subagent-driven-development

Continue with same mode? (y/n)
If n, will re-select execution mode
```

### 5. Prepare Execution Context

Load the following information into context:

1. **Plan file content**: Complete plan document
2. **Progress info**: List of completed tasks
3. **Current task**: Next task to execute
4. **Execution suggestions**: Specific recommendations based on progress

### 6. Prompt User to Start Execution

Based on user selection, prompt to invoke the appropriate superpowers skill:

```
✅ Ready to execute

Plan file loaded into context.

Execute the following command to start:

/subagent-driven-development

The skill will automatically read the plan and start from Task 1.
```

Or if there are completed tasks:

```
✅ Ready to continue execution

Completed: Task 1, Task 2, Task 3
Next: Task 4 - Implement tool handlers

Execute the following command to continue:

/subagent-driven-development

The skill will automatically skip completed tasks and start from Task 4.
```

## Usage Examples

### Scenario 1: First execution after design completion

```bash
/checkpoint-plan    # Save design phase
/clear
/resume-plan        # Display progress, select execution mode
# Select: 1 (subagent-driven-development)
/subagent-driven-development
```

### Scenario 2: Resume during execution

```bash
# After executing 3 tasks
/checkpoint-plan    # Save progress
/clear
/resume-plan        # Display progress: 3/10 completed
# Continue with same mode: y
/subagent-driven-development
```

### Scenario 3: Switch execution mode

```bash
/resume-plan
# Last used: subagent-driven-development
# Continue with same mode? n
# Select: 2 (executing-plans)
/executing-plans
```

## Smart Features

### 1. Auto-detect Plan Changes

If plan file was modified after checkpoint:

```
⚠️ Plan file has been updated

Checkpoint time: 2026-02-22 17:30
Plan modified: 2026-02-22 18:00

Suggested actions:
1. View plan changes: cat docs/plans/2026-02-22-mcp-server.md
2. Update checkpoint: /checkpoint-plan
3. Continue execution: /resume-plan

Still use old checkpoint? (y/n)
```

### 2. Multiple Plan Detection

If multiple plan files exist in `docs/plans/`:

```
⚠️ Multiple plan files detected

Checkpoint points to: docs/plans/2026-02-22-mcp-server.md
Other plans:
  - docs/plans/2026-02-21-cognitive-layer.md
  - docs/plans/2026-02-20-skill-vault.md

Use plan from checkpoint? (y/n)
If n, will list all plans for selection
```

### 3. Phase Stack Integration

If phase stack file `docs/dev/.phase_stack.json` exists, display phase info:

```
📋 Resuming Plan Execution

Phase: Phase 5 - MCP Server (active)
Plan: docs/plans/2026-02-22-mcp-server.md
...

⏸️  Suspended phases:
  Phase 4 - Cognitive Layer (60% completed)

Tip: After completing current phase, use /start-phase --resume phase4 to restore
```

## Integration with Third-party Skills

**Does not modify third-party skills**, integrates through:

1. **Context passing**: resume-plan loads plan content into context
2. **Progress hints**: Shows completed tasks, hints where to continue
3. **User invocation**: Prompts user to manually invoke superpowers skills

```
resume-plan (user-defined)
  ↓ Load plan into context
  ↓ Display progress summary
  ↓ Prompt user to invoke
  ↓
subagent-driven-development (superpowers)
  or
executing-plans (superpowers)
```

## File Locations

- **Checkpoint file**: `docs/plans/.checkpoint.json`
- **Plan files**: `docs/plans/YYYY-MM-DD-feature.md`
- **Phase stack file**: `docs/dev/.phase_stack.json` (optional)

## Notes

1. **No direct invocation**: resume-plan doesn't directly call superpowers skills, but prompts user to invoke
2. **Context preparation**: Ensure plan content is fully loaded into context
3. **Progress sync**: Displayed progress should match actual git history
4. **Flexible selection**: Allow users to switch execution modes
