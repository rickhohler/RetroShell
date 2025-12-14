# Template Development

This document tracks development notes, decisions, and considerations for the shell-template itself.

## Development Guidelines

### Version Management

- Always update `VERSION` file when making template changes
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Create git tags for each release
- See `AGENT.md` for detailed version management guidelines

### Template Structure

The template should maintain a clear separation between:
- **Template-specific files**: Documentation and scripts for template maintenance
- **Project files**: Files that will be included in projects created from the template

### Technology Agnostic Requirement

**Critical:** The template must remain completely technology-agnostic:
- No references to specific programming languages (Python, JavaScript, Go, Rust, etc.)
- No references to specific frameworks (React, Django, Spring, etc.)
- No references to specific platforms (iOS, Android, web, etc.)
- No technology-specific examples or documentation
- The template should work for ANY project type

When adding features or documentation, always ask: "Does this work for any technology stack?"

### Testing Changes

Before releasing a new version:
1. Test creating a repository from the template
2. Verify all scripts work correctly
3. Check that documentation is clear and accurate
4. Ensure version bumping and tagging works

### Template Files

Files that are part of the template (included in new projects):
- `README.md` - Main template description
- `SETUP.md` - Setup instructions for users
- `VERSION` - Template version
- `docs/` - Project documentation templates
- `ai/` - AI document templates
- `notes/` - Notes templates
- `scripts/` - User scripts (setup.sh, update.sh, check-update.sh)
- `config/` - Configuration templates

Files that are NOT part of the template (template-only):
- `template/` - This directory (template maintenance docs)
- `.git/` - Git repository data
- Any development notes or temporary files

### Project-Specific Files (NOT in Template)

The following files belong in the **project submodule** (the actual project repository), NOT in the shell template:
- `CONTRIBUTING.md` - Contribution guidelines
- `CODE_OF_CONDUCT.md` - Code of conduct
- Style guides (e.g., `STYLE_GUIDE.md`, `.editorconfig`, etc.)
- License files (unless template-specific)
- Project-specific documentation
- Any files related to the project's codebase, community, or contribution process

**Rationale:** These files are specific to each project's codebase, community standards, and contribution workflow. They should live in the project repository (submodule), not in the shell template.

## Changelog

### Version 1.0.0
- Initial template release
- Basic shell project structure
- Setup and update scripts
- Version management system
- Template directory for template-specific concerns
- **Technology-agnostic design**: Template works with any programming language, framework, or technology stack
- **Clear file separation**: CONTRIBUTING.md, CODE_OF_CONDUCT.md, and style guides belong in project submodules, not in the shell template

