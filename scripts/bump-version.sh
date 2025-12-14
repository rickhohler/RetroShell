#!/bin/bash

# Version bump and tag creation script
# This script helps bump the version and create a git tag

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION_FILE="$PROJECT_ROOT/VERSION"

# Check if VERSION file exists
if [ ! -f "$VERSION_FILE" ]; then
    echo -e "${RED}❌ VERSION file not found at ${VERSION_FILE}${NC}"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

if [ -z "$CURRENT_VERSION" ]; then
    echo -e "${RED}❌ Could not read version from VERSION file${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Current version: ${CURRENT_VERSION}${NC}"

# Parse version components
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

if [ -z "$MAJOR" ] || [ -z "$MINOR" ] || [ -z "$PATCH" ]; then
    echo -e "${RED}❌ Invalid version format. Expected MAJOR.MINOR.PATCH (e.g., 1.0.0)${NC}"
    exit 1
fi

# Determine bump type
BUMP_TYPE=""
if [ "$1" == "major" ] || [ "$1" == "minor" ] || [ "$1" == "patch" ]; then
    BUMP_TYPE="$1"
elif [ "$1" == "M" ] || [ "$1" == "maj" ]; then
    BUMP_TYPE="major"
elif [ "$1" == "m" ] || [ "$1" == "min" ]; then
    BUMP_TYPE="minor"
elif [ "$1" == "p" ]; then
    BUMP_TYPE="patch"
else
    echo -e "${YELLOW}Usage: $0 [major|minor|patch] [--no-tag] [--no-commit]${NC}"
    echo ""
    echo "Bump types:"
    echo "  major, M, maj  - Increment major version (${MAJOR}.${MINOR}.${PATCH} → $((MAJOR + 1)).0.0)"
    echo "  minor, m, min  - Increment minor version (${MAJOR}.${MINOR}.${PATCH} → ${MAJOR}.$((MINOR + 1)).0)"
    echo "  patch, p       - Increment patch version (${MAJOR}.${MINOR}.${PATCH} → ${MAJOR}.${MINOR}.$((PATCH + 1)))"
    echo ""
    echo "Options:"
    echo "  --no-tag        - Don't create a git tag"
    echo "  --no-commit     - Don't commit the version change"
    exit 1
fi

# Calculate new version
case "$BUMP_TYPE" in
    major)
        NEW_VERSION="$((MAJOR + 1)).0.0"
        ;;
    minor)
        NEW_VERSION="${MAJOR}.$((MINOR + 1)).0"
        ;;
    patch)
        NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))"
        ;;
esac

echo -e "${BLUE}🔄 Bumping ${BUMP_TYPE} version: ${CURRENT_VERSION} → ${NEW_VERSION}${NC}"

# Check for uncommitted changes
if [ -z "$2" ] || [ "$2" != "--no-commit" ] && [ -z "$3" ] || [ "$3" != "--no-commit" ]; then
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}⚠️  You have uncommitted changes.${NC}"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Cancelled.${NC}"
            exit 0
        fi
    fi
fi

# Update VERSION file
echo "$NEW_VERSION" > "$VERSION_FILE"
echo -e "${GREEN}✅ Updated VERSION file to ${NEW_VERSION}${NC}"

# Check if we should commit
SHOULD_COMMIT=true
SHOULD_TAG=true

for arg in "$@"; do
    if [ "$arg" == "--no-commit" ]; then
        SHOULD_COMMIT=false
    fi
    if [ "$arg" == "--no-tag" ]; then
        SHOULD_TAG=false
    fi
done

# Commit the version change
if [ "$SHOULD_COMMIT" = true ]; then
    echo -e "${BLUE}📝 Committing version change...${NC}"
    
    # Ask for commit message
    DEFAULT_MSG="chore: Bump version to ${NEW_VERSION}"
    read -p "Commit message (default: '${DEFAULT_MSG}'): " COMMIT_MSG
    COMMIT_MSG=${COMMIT_MSG:-$DEFAULT_MSG}
    
    git add "$VERSION_FILE"
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}✅ Committed version change${NC}"
else
    echo -e "${YELLOW}⏭️  Skipping commit (--no-commit flag)${NC}"
fi

# Create and push tag
if [ "$SHOULD_TAG" = true ]; then
    TAG_NAME="v${NEW_VERSION}"
    
    # Check if tag already exists
    if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
        echo -e "${RED}❌ Tag ${TAG_NAME} already exists${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🏷️  Creating git tag ${TAG_NAME}...${NC}"
    
    # Ask for tag message
    DEFAULT_TAG_MSG="Release version ${NEW_VERSION}"
    read -p "Tag message (default: '${DEFAULT_TAG_MSG}'): " TAG_MSG
    TAG_MSG=${TAG_MSG:-$DEFAULT_TAG_MSG}
    
    git tag -a "$TAG_NAME" -m "$TAG_MSG"
    echo -e "${GREEN}✅ Created tag ${TAG_NAME}${NC}"
    
    # Ask if we should push
    if [ "$SHOULD_COMMIT" = true ]; then
        read -p "Push commit and tag to remote? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            echo -e "${BLUE}📤 Pushing to remote...${NC}"
            git push origin HEAD
            git push origin "$TAG_NAME"
            echo -e "${GREEN}✅ Pushed commit and tag to remote${NC}"
        else
            echo -e "${YELLOW}⏭️  Skipping push. Run manually:${NC}"
            echo -e "   git push origin HEAD"
            echo -e "   git push origin ${TAG_NAME}"
        fi
    else
        echo -e "${YELLOW}⏭️  Skipping push (no commit was made)${NC}"
    fi
else
    echo -e "${YELLOW}⏭️  Skipping tag creation (--no-tag flag)${NC}"
fi

echo ""
echo -e "${GREEN}✅ Version bump complete!${NC}"
echo -e "${BLUE}📝 Summary:${NC}"
echo -e "   - Version: ${CURRENT_VERSION} → ${NEW_VERSION}"
if [ "$SHOULD_COMMIT" = true ]; then
    echo -e "   - Committed: Yes"
else
    echo -e "   - Committed: No (--no-commit)"
fi
if [ "$SHOULD_TAG" = true ]; then
    echo -e "   - Tag created: v${NEW_VERSION}"
else
    echo -e "   - Tag created: No (--no-tag)"
fi

