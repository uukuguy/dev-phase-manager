#!/bin/bash

# Dev Phase Manager - Local Installation Test Script

echo "=========================================="
echo "Dev Phase Manager - Installation Test"
echo "=========================================="
echo ""

# Check if plugin is installed
echo "1. Checking plugin installation..."
if [ -L ~/.claude/plugins/dev-phase-manager ]; then
    echo "   ✅ Plugin symlink exists"
    echo "   Location: $(readlink ~/.claude/plugins/dev-phase-manager)"
else
    echo "   ❌ Plugin symlink not found"
    exit 1
fi

# Verify plugin.json
echo ""
echo "2. Verifying plugin.json..."
if [ -f ~/.claude/plugins/dev-phase-manager/.claude-plugin/plugin.json ]; then
    echo "   ✅ plugin.json found"
    NAME=$(cat ~/.claude/plugins/dev-phase-manager/.claude-plugin/plugin.json | python3 -c "import sys, json; print(json.load(sys.stdin)['name'])")
    VERSION=$(cat ~/.claude/plugins/dev-phase-manager/.claude-plugin/plugin.json | python3 -c "import sys, json; print(json.load(sys.stdin)['version'])")
    echo "   Name: $NAME"
    echo "   Version: $VERSION"
else
    echo "   ❌ plugin.json not found"
    exit 1
fi

# Check skills directory
echo ""
echo "3. Checking skills directory..."
if [ -d ~/.claude/plugins/dev-phase-manager/skills ]; then
    SKILL_COUNT=$(find ~/.claude/plugins/dev-phase-manager/skills -name "SKILL.md" 2>/dev/null | wc -l)
    echo "   ✅ Skills directory found"
    echo "   Skills count: $SKILL_COUNT"
    echo "   Skills:"
    find ~/.claude/plugins/dev-phase-manager/skills -name "SKILL.md" | xargs -n1 dirname | xargs -n1 basename | sed 's/^/      - /'
else
    echo "   ❌ Skills directory not found"
    exit 1
fi

# Check documentation
echo ""
echo "4. Checking documentation..."
DOCS=("README.md" "CHANGELOG.md" "LICENSE" "docs/QUICK_START.md" "docs/ARCHITECTURE.md")
for doc in "${DOCS[@]}"; do
    if [ -f ~/.claude/plugins/dev-phase-manager/$doc ]; then
        echo "   ✅ $doc"
    else
        echo "   ❌ $doc (missing)"
    fi
done

# Test skill file structure
echo ""
echo "5. Validating skill file structure..."
for skill_dir in ~/.claude/plugins/dev-phase-manager/skills/*/; do
    SKILL_NAME=$(basename "$skill_dir")
    SKILL_FILE="$skill_dir/SKILL.md"
    if [ -f "$SKILL_FILE" ]; then
        if head -5 "$SKILL_FILE" | grep -q "^---$"; then
            echo "   ✅ $SKILL_NAME (has YAML frontmatter)"
        else
            echo "   ⚠️  $SKILL_NAME (missing YAML frontmatter)"
        fi
    else
        echo "   ❌ $SKILL_NAME (SKILL.md not found)"
    fi
done

# Summary
echo ""
echo "=========================================="
echo "Installation Test Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Restart Claude Code CLI (if running)"
echo "2. Test commands:"
echo "   /dev-phase-manager:list-plan"
echo "   /dev-phase-manager:start-phase \"Test Phase\""
echo ""
echo "For uninstallation:"
echo "   rm ~/.claude/plugins/dev-phase-manager"
echo ""
