---
description: Complete phase with cleanup
---

# End Phase

Complete phase post-processing, supporting idempotency checks and suspended phase resume prompts.

## Execution Steps

### 1. Idempotency Check

Read `docs/dev/.phase_stack.json`:

```bash
if [ ! -f docs/dev/.phase_stack.json ]; then
  echo "⚠️ Phase stack file not found"
  echo "Will execute standard end-phase flow"
  # Continue to step 2
else
  # Check if there are active phases
  active_count=$(jq '.active_phases | length' docs/dev/.phase_stack.json)

  if [ "$active_count" -eq 0 ]; then
    echo "⚠️ No active phases"
    echo ""
    echo "Possible reasons:"
    echo "1. Already executed /end-phase"
    echo "2. Never executed /start-phase"
    echo ""

    # Check if there are suspended phases
    suspended_count=$(jq '.suspended_phases | length' docs/dev/.phase_stack.json)
    if [ "$suspended_count" -gt 0 ]; then
      echo "⏸️  Suspended phases:"
      jq -r '.suspended_phases[] | "  - \(.name) (\(.progress) completed)"' docs/dev/.phase_stack.json
      echo ""
      echo "Suggested actions:"
      echo "1. /start-phase --resume <phase_id>"
      echo "2. /list-plan"
    fi

    read -p "Still execute end-phase? (y/n) " answer
    if [ "$answer" != "y" ]; then
      exit 0
    fi
  fi
fi
```

### 2. Save Memory

Use MCP tools to save phase work summary:

#### 2.1 Save to claude-mem

```bash
# Get current phase name
phase_name=$(jq -r '.active_phases[0].name // "Current Phase"' docs/dev/.phase_stack.json 2>/dev/null)

# Save memory
mcp__plugin_claude-mem_mcp-search__save_memory \
  --title "[Ouroboros] ${phase_name} Completed - [Main Achievements]" \
  --text "Completed ${phase_name} implementation, main achievements include..."
```

**Memory content should include**:
- Main features completed
- Technology selection and architecture decisions
- Problems encountered and solutions
- Suggestions for next phase

#### 2.2 Save to memory Knowledge Graph

If there are new architecture decisions or technology selections:

```bash
# Add observations to entity
mcp__memory__add_observations \
  --entityName "Ouroboros" \
  --contents "${phase_name}: Implemented..., Adopted..., Resolved..."

# Or create new entity (if new technical component)
mcp__memory__create_entities \
  --entities '[{
    "name": "MCP Server",
    "entityType": "Component",
    "observations": ["Using FastMCP framework", "Expose vault skills as MCP tools"]
  }]'
```

### 3. Update Documentation

#### 3.1 Update WORK_LOG.md

Update `docs/dev/WORK_LOG.md`, recording detailed work for this phase:

```markdown
## Phase 5 - MCP Server Implementation (2026-02-22)

### Completed
- Implemented MCP server base architecture
- Exposed vault skills as MCP tools
- Added tool call validation and error handling

### Technical Changes
- Introduced FastMCP framework
- Implemented tool handler abstraction layer
- Added complete MCP protocol support

### Test Results
- Unit tests: 15/15 passed
- Integration tests: 5/5 passed
- MCP protocol validation: Passed

### Outstanding Issues
- None

### Next Steps
- Resume Phase 4 - Cognitive Layer
- Integrate MCP server into cognitive layer
```

#### 3.2 Create or Update NEXT_SESSION_GUIDE.md

Create or update `docs/dev/NEXT_SESSION_GUIDE.md`:

```markdown
# Ouroboros Next Session Guide

## Current Status
- Phase 5 (MCP Server) completed
- Phase 4 (Cognitive Layer) suspended, 60% progress

## Completion Checklist
- [x] Phase 0: Architecture Design
- [x] Phase 1: Execution Layer
- [x] Phase 2: Skill Vault
- [x] Phase 3: Cognitive Layer (partial)
- [x] Phase 5: MCP Server
- [ ] Phase 4: Cognitive Layer (remaining 40%)
- [ ] Phase 6: Integration Testing

## Next Step Priorities
1. Resume Phase 4 - Cognitive Layer
2. Complete FSM state transition logic
3. Integrate MCP server into cognitive layer

## Key Code Paths
- MCP Server: `mcp_server/src/`
- Cognitive Layer: `agent/src/ouroboros_agent/cognitive/`
- Skill Vault: `agent/src/ouroboros_agent/skills/`

## Notes
- MCP server completed, ready for integration
- Phase 4 checkpoint saved in `.checkpoint-phase4.json`
```

#### 3.3 Update Design Documents (if major changes)

If there are major architecture-level adjustments, update related design documents:

```bash
# For example, update MCP_SERVER_DESIGN.md
# Record new architecture decisions and implementation details
```

### 4. Commit Git

Check and commit changes:

```bash
# Check if there are uncommitted changes
if git diff --quiet && git diff --cached --quiet; then
  echo "⚠️ No uncommitted changes"
  echo "May have already executed /end-phase"
  read -p "Still commit? (y/n) " answer
  if [ "$answer" != "y" ]; then
    skip_commit=true
  fi
fi

if [ "$skip_commit" != "true" ]; then
  # Get phase name
  phase_name=$(jq -r '.active_phases[0].name // "Current Phase"' docs/dev/.phase_stack.json 2>/dev/null)

  # Commit documentation updates
  git add docs/
  git commit -m "docs: complete ${phase_name}

- Update WORK_LOG.md
- Update NEXT_SESSION_GUIDE.md
- Save phase completion memory

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
fi
```

### 5. Clean Phase Stack

Update `docs/dev/.phase_stack.json`:

```bash
# 1. Remove current phase from active_phases
# 2. Archive checkpoint
if [ -f docs/plans/.checkpoint.json ]; then
  mv docs/plans/.checkpoint.json docs/plans/.checkpoint.archive.json
fi

# 3. Update phase stack
jq '.active_phases = []' docs/dev/.phase_stack.json > docs/dev/.phase_stack.json.tmp
mv docs/dev/.phase_stack.json.tmp docs/dev/.phase_stack.json
```

### 6. Prompt Resume Suspended Phases

Check if there are suspended phases:

```bash
suspended_count=$(jq '.suspended_phases | length' docs/dev/.phase_stack.json 2>/dev/null)

if [ "$suspended_count" -gt 0 ]; then
  echo ""
  echo "✅ ${phase_name} completed"
  echo ""
  echo "Memory saved"
  echo "Documentation updated"
  echo "Git committed"
  echo ""
  echo "⏸️  Suspended phases detected:"

  jq -r '.suspended_phases[] | "  \(.name)\n  Suspended: \(.suspended_at)\n  Progress: \(.progress)\n  "' docs/dev/.phase_stack.json

  echo "Suggested actions:"
  echo "1. /start-phase --resume <phase_id> - Resume and continue"
  echo "2. /clear - Clean context then resume"
  echo "3. /list-plan - View all phase status"
  echo ""

  # Get first suspended phase ID
  first_suspended=$(jq -r '.suspended_phases[0].name' docs/dev/.phase_stack.json | sed 's/Phase \([0-9]\+\).*/phase\1/')

  read -p "Resume ${first_suspended} now? (y/n) " answer
  if [ "$answer" = "y" ]; then
    echo ""
    echo "Please execute: /start-phase --resume ${first_suspended}"
  fi
fi
```

## Use Cases

### Scenario 1: Normal phase completion

```bash
/start-phase "Phase 5"
# ... work ...
/end-phase
# → Save memory
# → Update documentation
# → Commit git
# → Clean phase stack
```

### Scenario 2: Resume suspended phase after completion

```bash
/end-phase
# → Phase 5 completed
# → Detect suspended Phase 4
# → Prompt: Resume Phase 4? (y)
# → Guide user to execute /start-phase --resume phase4
```

### Scenario 3: Accidental consecutive end-phase

```bash
/end-phase
# → Phase 5 completed

/end-phase
# → ⚠️ No active phases
# → Still execute? (n)
# → Exit, prevent duplicate operations
```

## Integration with Third-party Skills

**Does not modify third-party skills**, end-phase only handles:
1. Phase completion post-processing
2. Memory saving
3. Documentation updates
4. Git commits
5. Phase stack management

Does not involve modifying superpowers skills.

## File Management

- **Phase stack**: `docs/dev/.phase_stack.json`
- **Work log**: `docs/dev/WORK_LOG.md`
- **Session guide**: `docs/dev/NEXT_SESSION_GUIDE.md`
- **Checkpoint archive**: `docs/plans/.checkpoint.archive.json`

## Notes

1. **Idempotency**: Multiple calls should be safe, with check mechanisms
2. **Memory quality**: Saved memory should contain sufficient context
3. **Document sync**: Ensure WORK_LOG and NEXT_SESSION_GUIDE stay current
4. **Git commits**: Only commit documentation changes, not code (code should be committed during development)
