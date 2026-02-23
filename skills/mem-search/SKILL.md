---
name: mem-search
description: Search and browse work memories with local index priority
args:
  - name: query
    description: Search keyword (optional, shows recent entries if not provided)
    required: false
---

# Mem Search

Search and browse work memories with local MEMORY_INDEX.md as the primary source.

## Execution Steps

### 1. Read Local Memory Index (Priority)

Read `docs/dev/MEMORY_INDEX.md` first:

```bash
if [ -f docs/dev/MEMORY_INDEX.md ]; then
  # File exists - use as primary source
  cat docs/dev/MEMORY_INDEX.md
fi
```

#### 1.1 No search query provided → Show recent entries

Display the most recent 20 entries from MEMORY_INDEX.md:
- Show all entries from `[Active Work]` section
- Show recent entries from the latest completed phase section
- Format: time-descending order

```
📋 Memory Index (Recent 20 entries)

## [Active Work]
- 15:30 | Completed mem-save skill implementation
- 14:00 | Started dev-phase-manager v1.1.0

## Phase 4 - MCP Tool Server [COMPLETED 2026-02-22]
- 18:30 | Phase 4 complete: MCP server 30 tests all pass
- 16:45 | Architecture decision: spawn_blocking wraps Wasm sync execution
...
```

#### 1.2 Search query provided → Filter matching entries

Search for entries containing the query keyword in MEMORY_INDEX.md:
- Case-insensitive matching
- Search across all sections (active + archived phases)
- Highlight matching keywords in output

```
🔍 Search results for "architecture" in MEMORY_INDEX.md:

- [Phase 4] 16:45 | Architecture decision: spawn_blocking wraps Wasm sync execution
- [Phase 0] 10:00 | Architecture design completed: bilingual Python + TypeScript
```

### 2. Search claude-mem

Use `mcp__plugin_claude-mem_mcp-search__search` to search MCP memory:

```bash
# If query provided
mcp__plugin_claude-mem_mcp-search__search \
  --query "$ARGUMENTS" \
  --limit 10

# If no query, search recent project memories
mcp__plugin_claude-mem_mcp-search__search \
  --query "[ProjectName]" \
  --limit 10
```

### 3. Search Memory Knowledge Graph

Use `mcp__memory__search_nodes` to search the knowledge graph:

```bash
# If query provided
mcp__memory__search_nodes \
  --query "$ARGUMENTS"

# If no query, search project entity
mcp__memory__search_nodes \
  --query "[ProjectName]"
```

### 4. Merge and Display Results

Present results in a unified view with local index first:

```
📋 Memory Search Results

━━━ Local Index (MEMORY_INDEX.md) ━━━
[Results from step 1]

━━━ claude-mem ━━━
📝 [2026-02-22 18:30] [memory] Phase 4 completed - MCP server all tests pass
📝 [2026-02-22 15:00] [memory] Phase 4 architecture decision - spawn_blocking

━━━ Knowledge Graph ━━━
🔗 Ouroboros
   - Adopted bilingual architecture (Python + TypeScript)
   - Using FastMCP as MCP server framework
🔗 MCP Server
   - Using FastMCP framework
   - Expose vault skills as MCP tools

💡 Tips:
- Use /mem-search <keyword> to search specific topics
- Use /mem-save to save current progress
- For full details on a memory, ask me to fetch it
```

### 5. Offer Detail Retrieval

If user wants more details on a specific memory:

```bash
# Fetch full observation details
mcp__plugin_claude-mem_mcp-search__get_observations \
  --ids [id1, id2]
```

## Use Cases

### Scenario 1: Browse all recent memories

```bash
/mem-search
# → Shows MEMORY_INDEX.md recent 20 entries
# → Shows claude-mem recent memories
# → Shows knowledge graph entities
```

### Scenario 2: Search specific topic

```bash
/mem-search architecture
# → Filters MEMORY_INDEX.md for "architecture" entries
# → Searches claude-mem for "architecture"
# → Searches knowledge graph for "architecture"
```

### Scenario 3: New session context recovery

```bash
# New session starts
/mem-search
# → Quickly see what happened in recent work
# → Understand current state without reading all files
```

## Smart Features

### 1. Local Index Priority

MEMORY_INDEX.md is the **primary** source because:
- It's structured by phase with timestamps
- It's browsable without semantic search
- It provides a chronological overview
- It works offline without MCP servers

### 2. Deduplication

When merging results from multiple sources:
- Local index entries are always shown first
- claude-mem results that match local entries are marked as `(indexed)`
- Knowledge graph results supplement with entity relationships

### 3. Graceful Degradation

If MEMORY_INDEX.md doesn't exist:
- Skip local index display
- Fall back to claude-mem and knowledge graph
- Suggest running `/mem-save` to create the index

## Notes

1. **Read-only**: This skill only reads data, never modifies files
2. **Performance**: Local index is fast; MCP searches may take longer
3. **Fallback**: If MCP servers unavailable, still shows local index
4. **Project detection**: Auto-detect project name from git remote or directory
