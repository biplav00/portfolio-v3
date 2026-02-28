#!/bin/bash

# AI-powered conventional commit helper
# Usage: ./scripts/ai-commit.sh

echo "🤖 AI Conventional Commit Helper"
echo "================================"
echo ""

# Check for unstaged changes
if [ -z "$(git status --porcelain)" ]; then
    echo "No changes to commit."
    exit 1
fi

# Get git diff for context
echo "Analyzing changes..."
DIFF=$(git diff --cached --stat 2>/dev/null || git diff --stat)

# Use AI to generate commit message
PROMPT="Analyze the following git diff and generate a conventional commit message according to https://www.conventionalcommits.org/

Rules:
- Use format: type(scope): description
- Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
- Keep description under 50 characters
- If breaking changes, start with 'feat!:'

Git diff:
$DIFF

Respond with ONLY the commit message, nothing else:"

# Try using Claude CLI if available, otherwise use a simple approach
if command -v &>/dev/null; then
    # For now, generate a simple commit based on changed files
    CHANGED_FILES=$(git diff --name-only | head -5)
    
    # Determine type based on files changed
    case "$CHANGED_FILES" in
        *.md|docs/*)
            TYPE="docs"
            ;;
        src/styles/*|*.css)
            TYPE="style"
            ;;
        src/pages/*|src/components/*)
            if echo "$CHANGED_FILES" | grep -q "test"; then
                TYPE="test"
            else
                TYPE="feat"
            fi
            ;;
        .github/*)
            TYPE="ci"
            ;;
        package.json|biome.json)
            TYPE="build"
            ;;
        *)
            TYPE="chore"
            ;;
    esac
    
    # Get first changed file as description
    FIRST_FILE=$(git diff --name-only | head -1)
    DESCRIPTION=$(echo "$FIRST_FILE" | sed 's/src\///' | sed 's/\//: /' | sed 's/-/ /g' | sed 's/_/ /g')
    
    # Capitalize first letter
    DESCRIPTION="$(echo $DESCRIPTION | sed 's/.*/\u&/')"
    
    # Limit to 50 chars
    DESCRIPTION=$(echo "$DESCRIPTION" | cut -c1-50)
    
    COMMIT_MSG="$TYPE: $DESCRIPTION"
else
    COMMIT_MSG="chore: update files"
fi

echo "Suggested commit message:"
echo ""
echo "  $COMMIT_MSG"
echo ""

read -p "Use this message? (y/n/q): " choice

case "$choice" in
    y|Y)
        git commit -m "$COMMIT_MSG"
        echo "✅ Committed!"
        ;;
    n|N)
        read -p "Enter custom message (type: description): " CUSTOM_MSG
        if [ -n "$CUSTOM_MSG" ]; then
            git commit -m "$CUSTOM_MSG"
            echo "✅ Committed!"
        else
            echo "Cancelled."
        fi
        ;;
    *)
        echo "Cancelled."
        ;;
esac
