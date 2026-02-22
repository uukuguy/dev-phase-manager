# Migration Guide

## For Users with Existing Phase Management Skills

If you already have custom `start-phase`, `end-phase`, or similar skills in your `~/.claude/skills/` directory, this guide explains how Dev Phase Manager coexists with them.

## No Breaking Changes

**Good news:** Installing Dev Phase Manager **will not break** your existing skills. They use different namespaces:

| Type | Location | Command Format | Example |
|------|----------|----------------|---------|
| **Your custom skills** | `~/.claude/skills/` | `/skill-name` | `/start-phase` |
| **Dev Phase Manager** | `~/.claude/plugins/dev-phase-manager/` | `/dev-phase-manager:skill-name` | `/dev-phase-manager:start-phase` |

## Coexistence Strategies

### Strategy 1: Keep Both (Recommended)

Use your existing skills for simple workflows and Dev Phase Manager for complex, long-running projects:

```bash
# Simple project - use your custom skills
/start-phase "Quick Fix"
# ... work ...
/end-phase

# Complex project - use Dev Phase Manager
/dev-phase-manager:start-phase "Phase 1 - Architecture"
/brainstorming
/writing-plans
/dev-phase-manager:checkpoint-plan
/clear
/dev-phase-manager:resume-plan
/subagent-driven-development
```

### Strategy 2: Gradual Migration

Migrate project-by-project:

1. **New projects**: Use Dev Phase Manager from the start
2. **Existing projects**: Continue with your custom skills
3. **Complex projects**: Switch to Dev Phase Manager when you need checkpoint features

### Strategy 3: Selective Features

Use Dev Phase Manager only for specific features:

```bash
# Use your custom start-phase
/start-phase "My Phase"

# Use Dev Phase Manager's checkpoint system
/dev-phase-manager:checkpoint-plan
/clear
/dev-phase-manager:resume-plan

# Use your custom end-phase
/end-phase
```

## Feature Comparison

### Your Custom Skills (Typical)
- ✅ Simple phase start/end
- ✅ Basic progress tracking
- ✅ Lightweight and fast
- ❌ No checkpoint system
- ❌ No phase stack management
- ❌ No superpowers integration

### Dev Phase Manager
- ✅ Full checkpoint system
- ✅ Phase stack with suspend/resume
- ✅ Superpowers integration
- ✅ Automatic progress detection from git
- ✅ MCP memory integration
- ✅ Idempotency and safety checks
- ⚠️ More complex (but more powerful)

## Migration Steps (Optional)

If you decide to fully migrate to Dev Phase Manager:

### Step 1: Backup Your Custom Skills

```bash
# Backup your existing skills
cp -r ~/.claude/skills/start-phase ~/.claude/skills/start-phase.backup
cp -r ~/.claude/skills/end-phase ~/.claude/skills/end-phase.backup
cp -r ~/.claude/skills/list-plan ~/.claude/skills/list-plan.backup
```

### Step 2: Test Dev Phase Manager

```bash
# Install Dev Phase Manager
claude-code plugin install https://github.com/uukuguy/dev-phase-manager

# Test in a sample project
cd /path/to/test-project
/dev-phase-manager:start-phase "Test Phase"
/dev-phase-manager:list-plan
/dev-phase-manager:end-phase
```

### Step 3: Update Your Workflow

Update your workflow documentation to use namespaced commands:

```diff
- /start-phase "Phase 1"
+ /dev-phase-manager:start-phase "Phase 1"

- /checkpoint-plan
+ /dev-phase-manager:checkpoint-plan

- /end-phase
+ /dev-phase-manager:end-phase
```

### Step 4: Remove Old Skills (Optional)

Only after you're confident Dev Phase Manager meets your needs:

```bash
# Remove old skills (CAREFUL!)
rm -rf ~/.claude/skills/start-phase
rm -rf ~/.claude/skills/end-phase
rm -rf ~/.claude/skills/list-plan
```

## Rollback Plan

If you need to rollback:

```bash
# Uninstall Dev Phase Manager
claude-code plugin uninstall dev-phase-manager

# Restore backups (if you removed old skills)
cp -r ~/.claude/skills/start-phase.backup ~/.claude/skills/start-phase
cp -r ~/.claude/skills/end-phase.backup ~/.claude/skills/end-phase
cp -r ~/.claude/skills/list-plan.backup ~/.claude/skills/list-plan
```

## Recommended Approach

**For most users:**

1. **Install Dev Phase Manager** without removing your existing skills
2. **Try it on a new project** to see if you like the checkpoint features
3. **Keep both** and use whichever fits your current workflow
4. **Migrate gradually** as you discover which features you prefer

## Questions?

- **Issue**: [Report problems](https://github.com/uukuguy/dev-phase-manager/issues)
- **Discussion**: [Ask questions](https://github.com/uukuguy/dev-phase-manager/discussions)
- **FAQ**: [Read FAQ in README](https://github.com/uukuguy/dev-phase-manager#-faq)

---

**Remember:** There's no pressure to migrate. Both approaches work, and you can use them side-by-side indefinitely.
