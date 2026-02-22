# GitHub Repository Setup Guide

## Repository Information

### About Section

**Description:**
```
Professional phase and checkpoint management system for Claude Code - enabling context-aware, multi-phase development workflows with intelligent state persistence
```

**Website:**
```
https://github.com/uukuguy/dev-phase-manager#readme
```

### Topics (Tags)

Add the following topics to your repository:

```
claude-code
claude-code-plugin
workflow-management
checkpoint-system
phase-management
development-tools
productivity
context-management
planning-tools
superpowers-integration
state-persistence
developer-workflow
```

## How to Configure

### Option 1: Using GitHub Web Interface

1. Go to https://github.com/uukuguy/dev-phase-manager
2. Click "⚙️ Settings" (top right, near the repository name)
3. In the "About" section (right sidebar on main page):
   - Click the ⚙️ gear icon
   - Add the description above
   - Add the website URL
   - Add all topics listed above
   - Check "Releases" and "Packages" if desired
   - Click "Save changes"

### Option 2: Using GitHub CLI

```bash
# Set repository description
gh repo edit uukuguy/dev-phase-manager \
  --description "Professional phase and checkpoint management system for Claude Code - enabling context-aware, multi-phase development workflows with intelligent state persistence" \
  --homepage "https://github.com/uukuguy/dev-phase-manager#readme"

# Add topics (run this command)
gh api repos/uukuguy/dev-phase-manager/topics \
  -X PUT \
  -H "Accept: application/vnd.github.mercy-preview+json" \
  -f names[]="claude-code" \
  -f names[]="claude-code-plugin" \
  -f names[]="workflow-management" \
  -f names[]="checkpoint-system" \
  -f names[]="phase-management" \
  -f names[]="development-tools" \
  -f names[]="productivity" \
  -f names[]="context-management" \
  -f names[]="planning-tools" \
  -f names[]="superpowers-integration" \
  -f names[]="state-persistence" \
  -f names[]="developer-workflow"
```

## Repository Settings Recommendations

### General Settings
- ✅ Enable Issues
- ✅ Enable Discussions (for community Q&A)
- ⚠️ Disable Wiki (use docs/ directory instead)
- ✅ Enable Sponsorships (optional)

### Features
- ✅ Preserve this repository (optional, for archival)
- ✅ Include in the GitHub Archive Program

### Pull Requests
- ✅ Allow squash merging
- ✅ Allow merge commits
- ✅ Allow rebase merging
- ✅ Automatically delete head branches

### Social Preview

Upload a social preview image (1280x640px) showing:
- Project name: "Dev Phase Manager"
- Tagline: "Context-Aware Development Workflows"
- Key features icons: Checkpoint, Phase Stack, Smart Recovery

## Verification

After setup, verify:

1. Repository appears in search: https://github.com/search?q=dev-phase-manager
2. Topics are clickable and lead to related projects
3. Description is visible on repository main page
4. Website link works correctly

## Additional Configuration

### Branch Protection (Optional)

For `main` branch:
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging

### Issue Templates

Create `.github/ISSUE_TEMPLATE/` with:
- `bug_report.md`
- `feature_request.md`
- `question.md`

### Pull Request Template

Create `.github/pull_request_template.md`

---

**Last Updated:** 2026-02-22
