#!/bin/bash

# Cursor AI Infrastructure - Project Initialization
# Adds AI coding infrastructure to any project

set -e

REPO_URL="https://raw.githubusercontent.com/gavinbmoore/cursor-session-state-template/main"

echo "🚀 Initializing Cursor AI Infrastructure..."

# Create directories
mkdir -p .cursor/rules

# Download core files
echo "📥 Downloading rule files..."

curl -sL "$REPO_URL/.cursor/rules/session-state.mdc" -o .cursor/rules/session-state.mdc
curl -sL "$REPO_URL/.cursor/rules/safety.mdc" -o .cursor/rules/safety.mdc
curl -sL "$REPO_URL/.cursor/rules/tool-mastery.mdc" -o .cursor/rules/tool-mastery.mdc
curl -sL "$REPO_URL/.cursor/rules/code-quality.mdc" -o .cursor/rules/code-quality.mdc
curl -sL "$REPO_URL/.cursor/rules/github-workflow.mdc" -o .cursor/rules/github-workflow.mdc

echo "📥 Downloading config files..."

curl -sL "$REPO_URL/PROJECT_STATE.md" -o PROJECT_STATE.md
curl -sL "$REPO_URL/SAFETY.md" -o SAFETY.md

# Optional: cursorignore
if [ ! -f .cursorignore ]; then
    curl -sL "$REPO_URL/.cursorignore" -o .cursorignore
    echo "📄 Created .cursorignore"
fi

echo ""
echo "✅ Cursor AI Infrastructure initialized!"
echo ""
echo "Files created:"
echo "  .cursor/rules/session-state.mdc"
echo "  .cursor/rules/safety.mdc"
echo "  .cursor/rules/tool-mastery.mdc"
echo "  .cursor/rules/code-quality.mdc"
echo "  .cursor/rules/github-workflow.mdc"
echo "  PROJECT_STATE.md"
echo "  SAFETY.md"
echo ""
echo "Next steps:"
echo "  1. Edit PROJECT_STATE.md with your project details"
echo "  2. Review SAFETY.md and set your preferred profile"
echo "  3. Start a Cursor chat and say: 'Let's continue working on the project'"
echo ""
