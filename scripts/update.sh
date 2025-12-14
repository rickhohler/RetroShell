#!/bin/bash

# Update script for shell-template projects
# This script helps update existing shell-template created projects to the latest template version

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
    echo -e "${YELLOW}   Creating VERSION file with default version...${NC}"
    echo "1.0.0" > "$PROJECT_ROOT/VERSION"
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
        fi
    else
        echo -e "${YELLOW}⚠️  Could not clone template repository${NC}"
        echo -e "${YELLOW}   Set SHELL_TEMPLATE_REPO_URL environment variable if using a custom template URL${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Could not access template repository${NC}"
    echo -e "${YELLOW}   Set SHELL_TEMPLATE_REPO_URL environment variable if using a custom template URL${NC}"
fi

# If we couldn't get latest version, ask user
if [ -z "$LATEST_VERSION" ]; then
    echo ""
    echo -e "${YELLOW}Could not automatically detect latest version.${NC}"
    read -p "Enter the latest template version to update to (or press Enter to skip): " LATEST_VERSION
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${YELLOW}Skipping update check.${NC}"
        exit 0
    fi
fi

# Compare versions
compare_versions "$CURRENT_VERSION" "$LATEST_VERSION"
COMPARE_RESULT=$?

if [ $COMPARE_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ You are already on the latest version (${CURRENT_VERSION})${NC}"
    exit 0
elif [ $COMPARE_RESULT -eq 1 ]; then
    echo -e "${YELLOW}⚠️  Your version (${CURRENT_VERSION}) is newer than the template version (${LATEST_VERSION})${NC}"
    echo -e "${YELLOW}   This is unusual. Proceeding with update anyway...${NC}"
else
    echo -e "${GREEN}📦 Update available: ${CURRENT_VERSION} → ${LATEST_VERSION}${NC}"
fi

# Confirm update
echo ""
read -p "Do you want to update to version ${LATEST_VERSION}? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Update cancelled.${NC}"
    exit 0
fi

# Backup current state
echo -e "${BLUE}💾 Creating backup...${NC}"
BACKUP_DIR="$PROJECT_ROOT/.update-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Files to potentially update (core template files)
TEMPLATE_FILES=(
    "README.md"
    "SETUP.md"
    "VERSION"
    "scripts/setup.sh"
    "scripts/update.sh"
    "scripts/check-update.sh"
    "scripts/bump-version.sh"
    "scripts/README.md"
    "docs/shell.md"
    "docs/README.md"
    "docs/AGENT.md"
    "ai/README.md"
    "ai/TEMPLATE.md"
    "notes/README.md"
    "notes/TEMPLATE.md"
    "config/README.md"
)

# Backup existing files
for file in "${TEMPLATE_FILES[@]}"; do
    if [ -f "$PROJECT_ROOT/$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp "$PROJECT_ROOT/$file" "$BACKUP_DIR/$file"
    fi
done

echo -e "${GREEN}✅ Backup created at: ${BACKUP_DIR}${NC}"

# Update files from template
echo -e "${BLUE}🔄 Updating files from template...${NC}"

if [ -d "$TEMP_DIR/template" ]; then
    for file in "${TEMPLATE_FILES[@]}"; do
        if [ -f "$TEMP_DIR/template/$file" ]; then
            # Check if file has been modified (simple check - compare with backup)
            if [ -f "$PROJECT_ROOT/$file" ] && [ -f "$BACKUP_DIR/$file" ]; then
                if ! diff -q "$PROJECT_ROOT/$file" "$BACKUP_DIR/$file" > /dev/null 2>&1; then
                    echo -e "${YELLOW}⚠️  ${file} has local modifications${NC}"
                    read -p "   Overwrite with template version? (y/N): " -n 1 -r
                    echo
                    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                        echo -e "${BLUE}   Skipping ${file}${NC}"
                        continue
                    fi
                fi
            fi
            
            # Copy file from template
            mkdir -p "$PROJECT_ROOT/$(dirname "$file")"
            cp "$TEMP_DIR/template/$file" "$PROJECT_ROOT/$file"
            echo -e "${GREEN}✅ Updated ${file}${NC}"
        fi
    done
    
    # Update VERSION file
    echo "$LATEST_VERSION" > "$PROJECT_ROOT/VERSION"
    echo -e "${GREEN}✅ Updated VERSION to ${LATEST_VERSION}${NC}"
else
    echo -e "${RED}❌ Template files not available. Manual update required.${NC}"
    echo -e "${YELLOW}   You can manually update VERSION file to: ${LATEST_VERSION}${NC}"
    exit 1
fi

# Check for new files in template
echo -e "${BLUE}🔍 Checking for new files in template...${NC}"
if [ -d "$TEMP_DIR/template" ]; then
    # Find all files in template (excluding .git and backup directories)
    while IFS= read -r -d '' file; do
        rel_path="${file#$TEMP_DIR/template/}"
        
        # Skip certain files/directories
        if [[ "$rel_path" == .git* ]] || \
           [[ "$rel_path" == */.git* ]] || \
           [[ "$rel_path" == */update-backup-* ]] || \
           [[ "$rel_path" == VERSION ]]; then
            continue
        fi
        
        # Skip if it's a directory
        if [ -d "$file" ]; then
            continue
        fi
        
        # Check if file exists in project
        if [ ! -f "$PROJECT_ROOT/$rel_path" ]; then
            echo -e "${YELLOW}📄 New file found: ${rel_path}${NC}"
            read -p "   Add this file? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mkdir -p "$PROJECT_ROOT/$(dirname "$rel_path")"
                cp "$file" "$PROJECT_ROOT/$rel_path"
                echo -e "${GREEN}✅ Added ${rel_path}${NC}"
            fi
        fi
    done < <(find "$TEMP_DIR/template" -type f -print0)
fi

echo ""
echo -e "${GREEN}✅ Update complete!${NC}"
echo -e "${BLUE}📝 Summary:${NC}"
echo -e "   - Updated from version ${CURRENT_VERSION} to ${LATEST_VERSION}"
echo -e "   - Backup saved at: ${BACKUP_DIR}"
echo ""
echo -e "${YELLOW}⚠️  Next steps:${NC}"
echo -e "   1. Review the changes: git diff"
echo -e "   2. Test your setup: ./scripts/setup.sh"
echo -e "   3. Commit the update: git add . && git commit -m 'Update shell-template to ${LATEST_VERSION}'"
echo -e "   4. If something went wrong, restore from backup: cp -r ${BACKUP_DIR}/* ."

