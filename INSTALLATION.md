# Dev Phase Manager - Installation Guide

## Current Status

The plugin is **ready** but not yet pushed to GitHub due to SSH authentication issues.

## Installation Methods

### Method 1: From GitHub (Recommended - After Push)

Once the code is pushed to GitHub:

```bash
# Add GitHub repo as marketplace (one-time)
claude plugin marketplace add uukuguy/dev-phase-manager

# Install the plugin
claude plugin install dev-phase-manager
```

### Method 2: Local Development Installation

For local development and testing:

#### Step 1: Validate Plugin

```bash
cd /path/to/dev-phase-manager
claude plugin validate .
```

Expected output:
```
✔ Validation passed
```

#### Step 2: Create Local Marketplace

Create a marketplace directory structure:

```bash
mkdir -p ~/dev-phase-manager-marketplace/.claude-plugin
```

Create `~/dev-phase-manager-marketplace/.claude-plugin/marketplace.json`:

```json
{
  "name": "local-dev",
  "description": "Local development marketplace",
  "version": "1.0.0",
  "owner": {
    "name": "local"
  },
  "plugins": [
    {
      "name": "dev-phase-manager",
      "description": "Professional phase and checkpoint management system",
      "version": "1.0.0",
      "source": {
        "type": "local",
        "path": "/Users/sujiangwen/sandbox/LLM/speechless.ai/Autonomous-Agents/Ouroboros/dev-phase-manager"
      }
    }
  ]
}
```

#### Step 3: Add Local Marketplace

```bash
claude plugin marketplace add ~/dev-phase-manager-marketplace
```

#### Step 4: Install Plugin

```bash
claude plugin install dev-phase-manager@local-dev
```

### Method 3: Direct GitHub Installation (After Push)

```bash
# Install directly from GitHub URL
claude plugin install https://github.com/uukuguy/dev-phase-manager
```

## Troubleshooting

### Plugin Not Showing Up

1. **Check validation**:
   ```bash
   cd /path/to/dev-phase-manager
   claude plugin validate .
   ```

2. **Check installed plugins**:
   ```bash
   claude plugin list
   ```

3. **Check marketplaces**:
   ```bash
   claude plugin marketplace list
   ```

### Validation Errors

Common issues:

1. **Missing `name` field in SKILL.md**:
   ```yaml
   ---
   name: skill-name          # REQUIRED
   description: Description  # REQUIRED
   ---
   ```

2. **Wrong author format**:
   ```json
   {
     "author": {
       "name": "uukuguy"     // Correct: object
     }
   }
   ```

   NOT:
   ```json
   {
     "author": "uukuguy"     // Wrong: string
   }
   ```

3. **Wrong directory structure**:
   ```
   plugin/
   ├── .claude-plugin/
   │   └── plugin.json       // Must be here
   └── skills/
       └── skill-name/
           └── SKILL.md      // Must be SKILL.md (uppercase)
   ```

## Current Plugin Status

✅ **Validation**: Passes `claude plugin validate .`
✅ **Structure**: Correct directory structure
✅ **Skills**: All 6 skills have required `name` field
✅ **plugin.json**: Valid format with correct author object

❌ **GitHub**: Not yet pushed (SSH authentication issue)

## Next Steps

1. **Fix SSH authentication** or use HTTPS:
   ```bash
   git remote set-url origin https://github.com/uukuguy/dev-phase-manager.git
   git push -u origin main
   ```

2. **Create GitHub Release**:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

3. **Install from GitHub**:
   ```bash
   claude plugin install uukuguy/dev-phase-manager
   ```

## Testing After Installation

```bash
# Restart Claude Code
exit
claude --continue .

# Test commands (type / and press Tab)
/list-plan
/start-phase "Test Phase"
/checkpoint-plan
```

## References

- [Claude Code Plugin Documentation](https://docs.anthropic.com/claude-code/plugins)
- [Plugin Validation](https://docs.anthropic.com/claude-code/plugins/validation)
- [Marketplace Management](https://docs.anthropic.com/claude-code/plugins/marketplaces)

---

**Last Updated**: 2026-02-22
**Plugin Version**: 1.0.0
**Claude Code Version**: 2.1.39
