---
name: mem-save
description: Save current work memory to MCP and local index
---

# Mem Save

Save current work memory to multiple backends with local MEMORY_INDEX.md tracking.

## Execution Steps

### 1. Summarize Current Progress

Review the current session (or since the last memory save) and create a concise summary:

- What was accomplished (2-3 sentences)
- Key decisions made
- Current status (completed / in progress / blocked)

### 2. Save to claude-mem

Use `mcp__plugin_claude-mem_mcp-search__save_memory` to save a structured memory:

```bash
mcp__plugin_claude-mem_mcp-search__save_memory \
  --title "[ProjectName] Memory Save - [Main Achievement]" \
  --text "Progress: ... Key decisions: ... Next steps: ..." \
  --project "ProjectName"
```

**Memory content should include**:
- Current progress summary
- Key technical decisions (if any)
- Unfinished items and blockers
- Suggested next steps

### 3. Save to Memory Knowledge Graph

Use `mcp__memory__create_entities` or `mcp__memory__add_observations` to save:

```bash
# Add observations to existing project entity
mcp__memory__add_observations \
  --entityName "ProjectName" \
  --contents "Progress: implemented X, decided to use Y, next step is Z"

# Or create new entity for new technical component
mcp__memory__create_entities \
  --entities '[{
    "name": "ComponentName",
    "entityType": "Component",
    "observations": ["Description of the component and decisions"]
  }]'
```

Save only if there are:
- New architecture decisions
- New patterns or conventions discovered
- Key technology selections

### 4. Append to MEMORY_INDEX.md

Update `docs/dev/MEMORY_INDEX.md` in the consuming project:

#### 4.1 If file does not exist, create initial structure:

```markdown
# Memory Index

Project: [ProjectName]
Created: [YYYY-MM-DD]

---

## [Active Work]

```

#### 4.2 Insert new entry at the TOP of `[Active Work]` section:

Format: `- HH:MM | Description` (same day) or `- YYYY-MM-DD HH:MM | Description` (cross-day)

Example:
```markdown
## [Active Work]

- 15:30 | Completed mem-save skill implementation with MEMORY_INDEX.md support
- 14:00 | Started dev-phase-manager v1.1.0 implementation
```

**Rules**:
- New entries always go at the **top** of `[Active Work]` (newest first)
- Keep entries concise (one line each)
- Include the most important achievement or status change
- Do NOT modify archived phase sections

### 5. Output Summary

Display a concise summary:

```
✅ Memory saved

Saved to:
- claude-mem: "[ProjectName] Memory Save - [Achievement]"
- knowledge graph: Updated [EntityName] observations
- MEMORY_INDEX.md: Added entry to [Active Work]

Summary:
- ✅ Completed: [what was done]
- 🔄 In progress: [current work]
- 📋 Next steps: [what to do next]

💡 Tip: Use /mem-search to browse saved memories
```

## Use Cases

### Scenario 1: Periodic save during long session

```bash
# Working on implementation...
# After completing a significant chunk:
/mem-save
# → Summarizes progress
# → Saves to all backends
# → Updates MEMORY_INDEX.md
```

### Scenario 2: Before context clear

```bash
# Context approaching limit
/mem-save
/checkpoint-progress
/clear
# → Memory preserved across clear
```

### Scenario 3: After key decision

```bash
# Made important architecture decision
/mem-save
# → Decision recorded in knowledge graph
# → Indexed in MEMORY_INDEX.md
```

## Notes

1. **No file creation beyond MEMORY_INDEX.md**: Only creates/updates `docs/dev/MEMORY_INDEX.md`
2. **No git commits**: Memory save does not commit to git
3. **Idempotent**: Safe to call multiple times, each call adds a new entry
4. **Project detection**: Auto-detect project name from git remote, directory name, or phase stack
5. **Timestamp**: Use current local time for entries
