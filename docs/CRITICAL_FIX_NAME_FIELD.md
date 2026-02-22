# CRITICAL FIX: Missing 'name' Field in SKILL.md

## Problem
Plugin was not being recognized by Claude Code even after correct directory structure.

## Root Cause
**All SKILL.md files were missing the required `name` field in YAML frontmatter.**

Claude Code requires BOTH `name` and `description` fields for skill discovery:

### Before (Incorrect)
```yaml
---
description: Save plan execution state for recovery after clear
---
```

### After (Correct)
```yaml
---
name: checkpoint-plan
description: Save plan execution state for recovery after clear
---
```

## Fix Applied

Added `name` field to all 6 SKILL.md files:

```bash
skills/checkpoint-plan/SKILL.md       → name: checkpoint-plan
skills/checkpoint-progress/SKILL.md   → name: checkpoint-progress
skills/end-phase/SKILL.md             → name: end-phase
skills/list-plan/SKILL.md             → name: list-plan
skills/resume-plan/SKILL.md           → name: resume-plan
skills/start-phase/SKILL.md           → name: start-phase
```

## Verification

Run the verification script:
```bash
./verify-skills.sh
```

Or manually check:
```bash
for skill_dir in skills/*/; do
  skill_name=$(basename "$skill_dir")
  echo "=== $skill_name ==="
  head -4 "$skill_dir/SKILL.md"
done
```

Expected output:
```
=== checkpoint-plan ===
---
name: checkpoint-plan
description: Save plan execution state for recovery after clear
---
```

## Testing

1. **Restart Claude Code** (REQUIRED)
   ```bash
   # In the other terminal
   exit
   claude --continue .
   ```

2. **Test skill invocation**
   ```bash
   # Type / and press Tab to see available skills
   /dev-phase-manager:checkpoint-plan
   /dev-phase-manager:list-plan
   /dev-phase-manager:start-phase "Test"
   ```

3. **Check if skills are loaded**
   - Skills should appear in autocomplete after typing `/`
   - Should see `dev-phase-manager:` prefix
   - All 6 skills should be available

## Complete Fix History

### Commit 1: ba99cca
```
fix: add required 'name' field to all SKILL.md frontmatter
```
- Added `name` field to all 6 SKILL.md files
- This is the CRITICAL fix

### Commit 2: f00b40c
```
chore: add skill verification script
```
- Added verify-skills.sh for validation

## Why This Was Missed

1. **Documentation gap**: The initial plugin structure guide didn't emphasize the `name` field requirement
2. **YAML frontmatter looked valid**: Having `description` alone didn't trigger syntax errors
3. **Silent failure**: Claude Code doesn't show clear error messages for missing required fields

## Key Learnings

### Required YAML Frontmatter Fields
```yaml
---
name: skill-name          # REQUIRED - must match directory name
description: Brief desc   # REQUIRED - for skill discovery
---
```

### Optional Fields
```yaml
---
name: skill-name
description: Brief description
user-invocable: true      # Makes skill directly invocable by users
version: "1.0.0"          # Track skill versions
args:                     # Define arguments
  - name: arg_name
    description: Arg description
    required: false
---
```

## References

- Plugin validation report from plugin-dev:plugin-validator
- Claude Code skill documentation
- Superpowers plugin examples

---

**Status**: CRITICAL FIX APPLIED
**Date**: 2026-02-22
**Commit**: ba99cca

**Next Step**: Restart Claude Code in the other terminal to test
