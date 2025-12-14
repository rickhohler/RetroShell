#!/bin/bash

# Check for template updates script
# This script checks if there are updates available without applying them

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

# Template repository URL (update this to your template repository URL)
TEMPLATE_REPO_URL="${SHELL_TEMPLATE_REPO_URL:-https://github.com/your-username/project-shell-template.git}"

# Check if VERSION file exists
if [ ! -f "$PROJECT_ROOT/VERSION" ]; then
    echo -e "${YELLOW}⚠️  No VERSION file found. This might not be a shell-template project.${NC}"
    exit 1
fi

CURRENT_VERSION=$(cat "$PROJECT_ROOT/VERSION" | tr -d '[:space:]')

echo -e "${BLUE}🔍 Checking for template updates...${NC}"
echo -e "${BLUE}   Current version: ${CURRENT_VERSION}${NC}"

# Function to compare semantic versions
# Returns: 0 if versions are equal, 1 if v1 > v2, 2 if v1 < v2
compare_versions() {
    local v1=$1
    local v2=$2
    
    if [ "$v1" = "$v2" ]; then
        return 0
    fi
    
    local IFS=.
    local i ver1=($v1) ver2=($v2)
    
    # Fill empty fields with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=${#ver2[@]}; i<${#ver1[@]}; i++)); do
        ver2[i]=0
    done
    
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

# Try to fetch latest version from template repository
LATEST_VERSION=""
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${BLUE}📡 Fetching latest template version...${NC}"

# Try to get version from template repo
if git ls-remote --heads "$TEMPLATE_REPO_URL" main &>/dev/null || \
   git ls-remote --heads "$TEMPLATE_REPO_URL" master &>/dev/null; then
    # Clone template repo to temp directory
    if git clone --depth 1 "$TEMPLATE_REPO_URL" "$TEMP_DIR/template" &>/dev/null; then
        if [ -f "$TEMP_DIR/template/VERSION" ]; then
            LATEST_VERSION=$(cat "$TEMP_DIR/template/VERSION" | tr -d '[:space:]')
            echo -e "${GREEN}✅ Found latest version: ${LATEST_VERSION}${NC}"
        else
            echo -e "${YELLOW}⚠️  Template repository doesn't have a VERSION file${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Could not clone template repository${NC}"
        echo -e "${YELLOW}   Set SHELL_TEMPLATE_REPO_URL environment variable if using a custom template URL${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Could not access template repository${NC}"
    echo -e "${YELLOW}   Set SHELL_TEMPLATE_REPO_URL environment variable if using a custom template URL${NC}"
    exit 1
fi

# Compare versions
compare_versions "$CURRENT_VERSION" "$LATEST_VERSION"
COMPARE_RESULT=$?

echo ""
if [ $COMPARE_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ You are on the latest version (${CURRENT_VERSION})${NC}"
    exit 0
elif [ $COMPARE_RESULT -eq 1 ]; then
    echo -e "${YELLOW}⚠️  Your version (${CURRENT_VERSION}) is newer than the template version (${LATEST_VERSION})${NC}"
    echo -e "${YELLOW}   This is unusual - you may have a custom version.${NC}"
    exit 0
else
    echo -e "${GREEN}📦 Update available!${NC}"
    echo -e "   Current version: ${CURRENT_VERSION}"
    echo -e "   Latest version:  ${LATEST_VERSION}"
    echo ""
    echo -e "${BLUE}To update, run:${NC}"
    echo -e "   ./scripts/update.sh"
    exit 0
fi

