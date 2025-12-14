#!/bin/bash

# Setup script for shell project
# This script helps set up the project environment

set -e

echo "🚀 Setting up shell project..."

# Initialize submodule if project directory exists but is empty
if [ -d "project" ] && [ -z "$(ls -A project)" ]; then
    echo "📦 Initializing project submodule..."
    git submodule update --init --recursive
fi

# Check if project submodule is configured
if [ -f ".gitmodules" ]; then
    echo "✅ Git submodule(s) configured"
    # Check for any submodule directories
    SUBMODULE_COUNT=$(git config --file .gitmodules --get-regexp path | wc -l | tr -d ' ')
    if [ "$SUBMODULE_COUNT" -gt 0 ]; then
        echo "✅ Found $SUBMODULE_COUNT submodule(s)"
        echo "   Submodule directories:"
        git config --file .gitmodules --get-regexp path | sed 's/.*path = /   - /'
    else
        echo "ℹ️  No submodules found. Add your project(s) as submodule(s):"
        echo "   git submodule add <your-project-repo-url> <project-name>"
        echo "   (Use the project repository name as the directory name)"
    fi
else
    echo "ℹ️  No .gitmodules file found. Add your project(s) as submodule(s):"
    echo "   git submodule add <your-project-repo-url> <project-name>"
    echo "   (Use the project repository name as the directory name)"
    echo ""
    echo "   Example for multiple related projects:"
    echo "   git submodule add <repo-url-1> my-pet-store-app"
    echo "   git submodule add <repo-url-2> my-pet-store-api"
fi

# Check for template directory (template maintenance docs, not needed in projects)
if [ -d "template" ]; then
    echo "ℹ️  Note: The 'template/' directory contains template maintenance documentation."
    echo "   It's not needed for your project and can be safely deleted if desired."
fi

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Add your project as a submodule: git submodule add <repo-url> <project-name>"
echo "2. Add documentation to docs/"
echo "3. Store AI conversations in ai/"
echo "4. Keep private notes in notes/"
