# Architecture Documentation

This document describes the architecture and design principles of Phase Manager.

## Design Principles

### 1. Non-Invasive Integration

**Principle**: Never modify third-party plugins.

**Implementation**:
- File-based state transfer
- User-controlled skill composition
- Clear responsibility boundaries

**Benefits**:
- No conflicts with plugin updates
- Easy to maintain
- Flexible integration

### 2. State Persistence

**Principle**: Preserve state across context clearing.

**Implementation**:
- Checkpoint files in `docs/plans/.checkpoint.json`
- Phase stack in `docs/dev/.phase_stack.json`
- Automatic state detection from git history

**Benefits**:
- Seamless workflow continuation
- No manual state tracking
- Context overflow prevention

### 3. Idempotency

**Principle**: Commands can be safely executed multiple times.

**Implementation**:
- State checks before operations
- User confirmations for destructive actions
- Graceful degradation when files missing

**Benefits**:
- Prevents accidental data loss
- Safe to retry operations
- Robust error handling

## Component Architecture

```
┌─────────────────────────────────────────────────────────┐
│  User Interface (Claude Code CLI)                       │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Phase Manager Commands                                  │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │ checkpoint- │  │ start-phase  │  │ list-plan      │ │
│  │ plan        │  │ end-phase    │  │                │ │
│  │ resume-plan │  │              │  │                │ │
│  └─────────────┘  └──────────────┘  └────────────────┘ │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  State Management Layer                                  │
│  ┌──────────────────┐  ┌──────────────────────────────┐ │
│  │ Checkpoint       │  │ Phase Stack                  │ │
│  │ System           │  │ Manager                      │ │
│  └──────────────────┘  └──────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Filesystem Storage                                      │
│  ┌──────────────────┐  ┌──────────────────────────────┐ │
│  │ .checkpoint.json │  │ .phase_stack.json            │ │
│  │ Plan files       │  │ Session guides               │ │
│  └──────────────────┘  └──────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Integration Layer                                       │
│  ┌──────────────────┐  ┌──────────────────────────────┐ │
│  │ Superpowers      │  │ MCP Servers                  │ │
│  │ Skills           │  │ (claude-mem, memory)         │ │
│  └──────────────────┘  └──────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Data Flow

### Checkpoint Creation Flow

```
User executes /checkpoint-plan
  ↓
Locate latest plan file
  ↓
Collect state information
  - Phase (design/execution/review)
  - Completed tasks (from git log)
  - Current task
  - Execution mode
  ↓
Create/update .checkpoint.json
  ↓
Display confirmation
```

### Resume Flow

```
User executes /resume-plan
  ↓
Load .checkpoint.json
  ↓
Validate checkpoint data
  ↓
Load plan file content
  ↓
Display progress summary
  ↓
Prompt for execution mode
  ↓
Load context for execution
  ↓
Suggest next command
```

### Phase Stack Flow

```
User executes /start-phase "Phase X"
  ↓
Load .phase_stack.json
  ↓
Check for active phases
  ↓
If conflict detected:
  - Prompt user: Continue/Suspend/Cancel
  - If suspend: Move to suspended_phases
  ↓
Add new phase to active_phases
  ↓
Load session guide
  ↓
Load memory from MCP
  ↓
Display startup summary
```

## File Formats

### Checkpoint File

**Location**: `docs/plans/.checkpoint.json`

**Schema**:
```json
{
  "plan_file": "string",           // Path to plan file
  "phase": "string",               // design|execution|review
  "created_at": "string",          // ISO 8601 timestamp
  "updated_at": "string",          // ISO 8601 timestamp
  "completed_tasks": ["string"],   // Array of task names
  "current_task": "string|null",   // Current task name
  "execution_mode": "string|null", // subagent-driven|executing-plans
  "phase_name": "string",          // Display name
  "notes": "string"                // Optional notes
}
```

### Phase Stack File

**Location**: `docs/dev/.phase_stack.json`

**Schema**:
```json
{
  "active_phases": [
    {
      "name": "string",            // Phase name
      "started_at": "string",      // ISO 8601 timestamp
      "checkpoint": "string",      // Path to checkpoint
      "guide": "string",           // Path to session guide
      "progress": "string"         // Progress percentage
    }
  ],
  "suspended_phases": [
    {
      "name": "string",
      "started_at": "string",
      "suspended_at": "string",    // Suspension timestamp
      "checkpoint": "string",
      "guide": "string",
      "progress": "string",
      "reason": "string"           // Suspension reason
    }
  ]
}
```

## Integration Points

### With Superpowers

**Integration Type**: Workflow composition

**Flow**:
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
  ↓
checkpoint-progress (Phase Manager)
  ↓
end-phase (Phase Manager)
```

**State Transfer**: Via filesystem (checkpoint files)

### With MCP Servers

**Required**: No (optional enhancement)

**Recommended Servers**:
- `claude-mem`: Cross-session memory storage
- `memory`: Knowledge graph for architecture decisions

**Usage**:
- `start-phase`: Loads memory for context
- `end-phase`: Saves phase completion memory

## Error Handling

### Missing Files

**Strategy**: Graceful degradation

**Example**:
```bash
# If .checkpoint.json missing
→ Display warning
→ Suggest creating checkpoint
→ Continue with available data
```

### Corrupted Data

**Strategy**: Validation and recovery

**Example**:
```bash
# If checkpoint data invalid
→ Display error with details
→ Suggest manual inspection
→ Offer to create new checkpoint
```

### Conflicts

**Strategy**: User confirmation

**Example**:
```bash
# If active phase exists
→ Display conflict details
→ Offer options: Continue/Suspend/Cancel
→ Execute user choice
```

## Performance Considerations

### File I/O

- Checkpoint files are small (<1KB typically)
- Phase stack files are minimal (<2KB)
- No performance impact on normal operations

### Git Operations

- Auto-detection uses `git log` with limits
- Fallback to manual input if slow
- No blocking operations

### Memory Usage

- All state in JSON files
- No in-memory caching needed
- Minimal memory footprint

## Security Considerations

### File Permissions

- Checkpoint files: User read/write only
- No sensitive data stored
- Git-ignored by default

### Input Validation

- JSON schema validation
- Path traversal prevention
- Safe file operations

## Future Enhancements

### Planned Features

1. **Progress Visualization**
   - Terminal progress bars
   - Colored output
   - ASCII art diagrams

2. **Phase Dependencies**
   - Define phase prerequisites
   - Automatic dependency checking
   - Dependency graph visualization

3. **Timeline View**
   - Historical phase timeline
   - Duration tracking
   - Performance analytics

4. **Web UI**
   - Browser-based phase management
   - Real-time status updates
   - Interactive phase graph

### Extension Points

- Custom checkpoint formats
- Plugin hooks for state changes
- External storage backends
- API for programmatic access

## Testing Strategy

### Manual Testing

- Test each command individually
- Test complete workflows
- Test error conditions
- Test edge cases

### Integration Testing

- Test with superpowers
- Test with MCP servers
- Test file system operations
- Test git operations

### Regression Testing

- Maintain test scenarios
- Document expected behavior
- Verify after changes

## Maintenance

### Version Updates

- Follow semantic versioning
- Update CHANGELOG.md
- Tag releases in git
- Update documentation

### Backward Compatibility

- Maintain checkpoint format compatibility
- Provide migration scripts if needed
- Document breaking changes

### Deprecation Policy

- Announce deprecations early
- Provide migration path
- Support old format for 2 versions
- Remove after grace period
