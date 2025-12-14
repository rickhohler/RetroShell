# Scripts

This directory contains utility scripts for your shell project.

## Available Scripts

### Template Scripts

- `setup.sh` - Initial shell project setup and submodule initialization
- `check-update.sh` - Check if template updates are available (read-only)
- `update.sh` - Update your shell project to the latest template version
- `bump-version.sh` - Bump template version and create git tag (for template maintainers)

### Template Update Scripts

#### `check-update.sh`

Checks if there are updates available from the template repository without making any changes.

```bash
./scripts/check-update.sh
```

**What it does:**
- Compares your current version (from `VERSION` file) with the latest template version
- Fetches the latest version from the template repository
- Reports if an update is available

**Environment Variables:**
- `SHELL_TEMPLATE_REPO_URL` - Custom template repository URL (optional)

#### `update.sh`

Updates your shell project to the latest template version.

```bash
./scripts/update.sh
```

**What it does:**
1. Checks your current version
2. Fetches the latest version from the template repository
3. Creates a backup of your current files (in `.update-backup-*`)
4. Updates template files (with confirmation for modified files)
5. Updates the `VERSION` file
6. Optionally adds new files from the template

**Features:**
- **Safe updates**: Creates backups before making changes
- **Smart detection**: Detects files you've modified and asks before overwriting
- **Selective updates**: You can choose which files to update
- **New file detection**: Prompts to add new files from the template

**Environment Variables:**
- `SHELL_TEMPLATE_REPO_URL` - Custom template repository URL (optional)

**Example:**
```bash
# Use default template URL
./scripts/update.sh

# Use custom template URL
export SHELL_TEMPLATE_REPO_URL="https://github.com/your-username/your-template.git"
./scripts/update.sh
```

**After updating:**
1. Review changes: `git diff`
2. Test your setup: `./scripts/setup.sh`
3. Commit the update: `git add . && git commit -m "Update shell-template to X.Y.Z"`

#### `bump-version.sh`

Bumps the template version and creates a git tag. **This script is for template maintainers only.**

```bash
# Bump patch version (1.0.0 → 1.0.1)
./scripts/bump-version.sh patch

# Bump minor version (1.0.0 → 1.1.0)
./scripts/bump-version.sh minor

# Bump major version (1.0.0 → 2.0.0)
./scripts/bump-version.sh major

# Short forms also work
./scripts/bump-version.sh p    # patch
./scripts/bump-version.sh m    # minor
./scripts/bump-version.sh M    # major
```

**What it does:**
1. Reads current version from `VERSION` file
2. Calculates new version based on bump type
3. Updates `VERSION` file
4. Commits the version change (optional)
5. Creates an annotated git tag (optional)
6. Optionally pushes to remote

**Options:**
- `--no-commit` - Don't commit the version change
- `--no-tag` - Don't create a git tag

**Examples:**
```bash
# Standard bump with commit and tag
./scripts/bump-version.sh patch

# Bump version without committing (for manual commit)
./scripts/bump-version.sh minor --no-commit

# Bump version without creating tag
./scripts/bump-version.sh patch --no-tag

# Bump version without commit or tag (just update VERSION file)
./scripts/bump-version.sh patch --no-commit --no-tag
```

**Note:** This script is intended for use in the template repository itself, not in projects created from the template.

### Setup Script

#### `setup.sh`

Initializes and verifies your shell project setup.

```bash
./scripts/setup.sh
```

**What it does:**
- Initializes submodules if needed
- Checks for configured submodules
- Provides guidance on adding projects as submodules

## Adding Your Own Scripts

Add project-specific scripts here for:
- Build automation
- Deployment workflows
- Development utilities
- Any other automation needs

## Usage

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

Run scripts:
```bash
./scripts/script-name.sh
```

## Script Permissions

All scripts should be executable. If they're not, make them executable:

```bash
chmod +x scripts/*.sh
```

