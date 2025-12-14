# AI Agent Documentation

This document provides context and guidelines for AI coding assistants (like Cursor, GitHub Copilot, Claude, ChatGPT, etc.) working on **template development and maintenance**.

> **Important:** This document is in the `template/` directory and is for template maintainers only. It is NOT included in projects created from the template.

## Template Development Context

This is the **shell-template repository** - a GitHub template repository used to create shell projects. When working on template development:

- **Template Repository** (this repo): Contains template files, documentation, and maintenance scripts
- **Projects Created from Template**: Users create shell projects from this template, which then contain their own project submodules

**This document is for AI assistants working on template development**, not for working on projects created from the template.

## Project Structure

**Note:** This document is in the `template/` directory, which is for template maintenance only. It is NOT included in projects created from the template.

For projects created from the template, the structure is:
```
shell-project/
├── VERSION              # Template version (semantic versioning)
├── docs/                # Private project documentation
├── ai/                  # AI-generated documents and conversations
├── notes/               # Private notes
├── scripts/             # Build and deployment scripts
├── config/              # Configuration templates
└── {project-name}/      # Git submodule(s) - actual project code
                         # Directory name matches project repository name
                         # Can have multiple related projects
```

The template repository itself also includes:
```
template/                # Template maintenance (NOT in created projects)
├── AGENT.md            # This file - AI agent guidelines for template development
├── GITHUB_TEMPLATE_SETUP.md  # Template setup instructions
└── DEVELOPMENT.md      # Template development notes
```

## Key Concepts

### Shell vs Project Separation

- **Shell Repository**: Always private, contains **ALL AI documents related to the project** and private materials
- **Project Submodule**: Contains only clean code, can be public or private
- **AI Documents**: **ALL AI-related materials about the project MUST stay in the shell's `ai/` directory**, NEVER in the project submodule
- **Private Documentation**: All private docs stay in the shell's `docs/` directory
- **Critical Rule**: ALL AI conversations, prompts, and AI-generated documentation about the project code belong in the shell project, not in the submodule

## Version Management

This template uses semantic versioning (MAJOR.MINOR.PATCH) stored in the `VERSION` file.

### When to Upgrade the Version

**You MUST upgrade the version when making changes to the template itself** (not to projects created from the template). The version should be incremented based on the type of change:

1. **PATCH version (X.Y.Z → X.Y.Z+1)**: Increment for:
   - Bug fixes in template files
   - Documentation updates/clarifications
   - Minor script improvements
   - Typo corrections
   - Formatting changes

2. **MINOR version (X.Y.Z → X.Y+1.0)**: Increment for:
   - New features added to the template
   - New scripts or utilities
   - New documentation sections
   - New directory structures
   - Backward-compatible enhancements
   - New template files added

3. **MAJOR version (X.Y.Z → X+1.0.0)**: Increment for:
   - Breaking changes to template structure
   - Changes that require manual migration in existing projects
   - Removal of files or directories
   - Significant restructuring
   - Changes to required workflows

### Version Upgrade Process

When making changes to the template:

1. **Make your changes** to template files
2. **Determine the version bump** based on the change type above
3. **Update the VERSION file**:
   ```bash
   # For patch version
   echo "1.0.1" > VERSION

   # For minor version
   echo "1.1.0" > VERSION

   # For major version
   echo "2.0.0" > VERSION
   ```
4. **Commit the changes together**:
   ```bash
   git add .
   git commit -m "feat: Add new update script (v1.1.0)"
   # or
   git commit -m "fix: Correct typo in README (v1.0.1)"
   # or
   git commit -m "BREAKING: Restructure template directories (v2.0.0)"
   ```
5. **Create and push a git tag** for the new version:
   ```bash
   # Read the version from VERSION file
   VERSION=$(cat VERSION | tr -d '[:space:]')

   # Create an annotated tag
   git tag -a "v${VERSION}" -m "Release version ${VERSION}"

   # Push the commit and tag
   git push origin main
   git push origin "v${VERSION}"

   # Or push both at once
   git push origin main --tags
   ```

   **Or use the helper script** (recommended):
   ```bash
   # Bump patch version (1.0.0 → 1.0.1)
   ./scripts/bump-version.sh patch

   # Bump minor version (1.0.0 → 1.1.0)
   ./scripts/bump-version.sh minor

   # Bump major version (1.0.0 → 2.0.0)
   ./scripts/bump-version.sh major
   ```

**Important:** Always create a git tag when releasing a new version. This allows:
- Users to reference specific template versions
- The update scripts to detect and fetch specific versions
- Clear version history in the repository
- Easy rollback if needed

### Template Files That Require Version Updates

Any changes to these files require a version bump:
- `README.md`
- `SETUP.md`
- `VERSION` (obviously)
- `scripts/*.sh` (template scripts)
- `docs/*.md` (template documentation)
- `ai/TEMPLATE.md`
- `notes/TEMPLATE.md`
- Any new template files added

### What Does NOT Require Version Updates

- Changes to project-specific files in projects created from the template
- Changes to `.gitignore` that are project-specific
- Changes to project submodules
- Personal notes or AI conversations in the template repository itself

## AI Assistant Guidelines

When working with this project:

1. **Respect the shell/project separation**
   - Shell repo changes: documentation, scripts, config templates
   - Project submodule: actual code changes

2. **Version management for template changes**
   - **Always update VERSION file** when modifying template files
   - Determine appropriate version bump (PATCH/MINOR/MAJOR)
   - Include version in commit message when updating template
   - **Create and push a git tag** after committing version changes
   - Use format `vX.Y.Z` for tags (e.g., `v1.1.0`)
   - Never skip version updates or tag creation for template changes

3. **Project-specific files do NOT belong in template**
   - **DO NOT** add CONTRIBUTING.md, CODE_OF_CONDUCT.md, or style guides to the template
   - These files belong in the **project submodule** (the actual project repository)
   - The template is for shell project structure only, not project-specific community/contribution files
   - If asked to add these, redirect to the project submodule directory

2. **Project Management via GitHub Issues**
   - **Use the project repository's issues** for project management, not the shell repository's issues
   - When using `gh` command, navigate to the project submodule directory first:
     ```bash
     cd <project-name>
     gh issue list
     gh issue create
     gh issue view <number>
     ```
   - The shell repository is for private documentation only
   - All project management (issues, PRs, milestones) happens in the actual project repository

3. **Document decisions**
   - Add architecture decisions to `docs/`
   - Document build/deployment changes
   - Keep AI conversations in `ai/`

4. **Security**
   - Never suggest committing secrets, API keys, or credentials
   - Use configuration templates in `config/` directory
   - Document environment variables and secrets management

5. **Testing**
   - Suggest appropriate tests for the project type
   - Maintain test coverage documentation
   - Document testing procedures

6. **Technology Agnostic - Critical Rule**
   - **This template is completely technology-agnostic**
   - **DO NOT** include any references to specific programming languages, frameworks, or technology stacks
   - **DO NOT** assume Python, JavaScript, Go, Rust, iOS, web, mobile, etc.
   - The template should work for ANY project type
   - If you need to know the project type for a specific task, ask the user
   - Never add technology-specific examples or documentation to template files

## Common Tasks

### Working with Submodules

```bash
# Update a submodule (use the actual project name as directory)
cd <project-name>
git pull origin main
cd ..
git add <project-name>
git commit -m "Update <project-name> submodule"

# For multiple projects
cd <project-name-1>
git pull origin main
cd ../<project-name-2>
git pull origin main
cd ..
git add <project-name-1> <project-name-2>
git commit -m "Update project submodules"
```

### Managing Project Issues

**Important:** Use the project repository's issues, not the shell repository's issues.

```bash
# Navigate to project submodule (use the actual project name as directory)
cd <project-name>

# List issues in the project repository
gh issue list

# Create a new issue in the project repository
gh issue create --title "Feature: Add user authentication" --body "Description here"

# View an issue
gh issue view <number>

# Close an issue
gh issue close <number>

# Return to shell directory
cd ..
```

The shell repository should not be used for project management. All issues, PRs, and project tracking belong in the actual project repository. If you have multiple related projects, navigate to each project's directory to manage its issues separately.

### Adding Documentation

- Add to `docs/` directory
- Keep project-specific documentation organized
- Document important decisions
- **Note:** Template files should never contain technology-specific documentation

### AI Conversations

- Store in `ai/` directory
- Organize by date or topic
- Never commit to the project submodule

## Questions to Ask

When helping with template development, consider:
- Is this change technology-agnostic?
- Does this work for any project type?
- Are there any technology-specific assumptions?

**Important:** When working on the template itself, you should NOT ask about the project type in the submodule. The template must remain technology-agnostic. Only ask about project-specific details when working on a user's actual shell project (not the template).

## References

- [Git Submodules Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub Template Repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)

