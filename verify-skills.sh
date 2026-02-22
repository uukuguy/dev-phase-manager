#!/bin/bash

# Verify all SKILL.md files have required 'name' field

echo "Checking SKILL.md files for required 'name' field..."
echo ""

all_valid=true

for skill_dir in skills/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    if [ ! -f "$skill_file" ]; then
        echo "❌ $skill_name: SKILL.md not found"
        all_valid=false
        continue
    fi

    # Extract YAML frontmatter
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file" | head -n -1 | tail -n +2)

    # Check for name field
    if echo "$frontmatter" | grep -q "^name:"; then
        name_value=$(echo "$frontmatter" | grep "^name:" | sed 's/name: *//')
        if [ "$name_value" = "$skill_name" ]; then
            echo "✅ $skill_name: name field correct"
        else
            echo "⚠️  $skill_name: name field mismatch (expected: $skill_name, got: $name_value)"
            all_valid=false
        fi
    else
        echo "❌ $skill_name: missing 'name' field"
        all_valid=false
    fi

    # Check for description field
    if echo "$frontmatter" | grep -q "^description:"; then
        echo "   ✓ has description"
    else
        echo "   ⚠️  missing description"
    fi
done

echo ""
if [ "$all_valid" = true ]; then
    echo "✅ All skills valid!"
    exit 0
else
    echo "❌ Some skills have issues"
    exit 1
fi
