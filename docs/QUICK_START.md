# Quick Start Guide

Get started with Phase Manager in 5 minutes.

## Installation

```bash
# Install from GitHub
claude-code plugin install https://github.com/uukuguy/dev-phase-manager
```

## Basic Usage

### 1. Start Your First Phase

```bash
/dev-phase-manager:start-phase "My First Feature"
```

### 2. Design and Plan

```bash
# Brainstorm your approach
/brainstorming

# Create implementation plan
/writing-plans
```

### 3. Save Checkpoint

```bash
# Save state before clearing context
/dev-phase-manager:checkpoint-plan

# Clear context
/clear
```

### 4. Resume and Execute

```bash
# Resume from checkpoint
/dev-phase-manager:resume-plan

# Execute the plan
/subagent-driven-development
```

### 5. Complete Phase

```bash
# Finish the phase
/dev-phase-manager:end-phase
```

## Common Workflows

### Handling Interruptions

```bash
# Working on Feature A
/dev-phase-manager:start-phase "Feature A"
# ... 60% complete ...

# Urgent bug appears
/dev-phase-manager:start-phase "Critical Bugfix"
# → Suspend Feature A? (y)
# ... fix bug ...
/dev-phase-manager:end-phase

# Resume Feature A
/dev-phase-manager:start-phase --resume featurea
```

### Managing Context

```bash
# Context getting full
/dev-phase-manager:checkpoint-progress
/clear
/dev-phase-manager:resume-plan
# Continue seamlessly
```

### Checking Status

```bash
# View all phases and progress
/dev-phase-manager:list-plan
```

## Tips

1. **Save Often**: Use `/dev-phase-manager:checkpoint-plan` before `/clear`
2. **Check Status**: Use `/dev-phase-manager:list-plan` to see what's active
3. **Name Phases**: Use descriptive phase names
4. **Resume Suspended**: Don't forget suspended phases

## Next Steps

- Read the [full documentation](README.md)
- Check out [use cases](README.md#-use-cases)
- Learn about [architecture](README.md#-architecture)

## Need Help?

- [GitHub Issues](https://github.com/uukuguy/dev-phase-manager/issues)
- [Discussions](https://github.com/uukuguy/dev-phase-manager/discussions)
