# AI Agent Guidelines for Shell Projects

This document provides essential context and rules for AI coding assistants (Cursor, GitHub Copilot, Claude, ChatGPT, etc.) working with shell projects created from this template.

## Project Context

This is a **shell project** - a private git repository that wraps around another git repository (the actual project) as a submodule. The repository structure separates:

- **Shell Repository** (this repo): Always private, contains private notes, AI documents, and project documentation
- **Project Submodule** (`{project-name}/`): Clean, public or private git repository with the actual project code

## Critical Rules

### 1. AI Documents MUST Stay in Shell Project

**ALL AI-related documents, conversations, and materials related to the project (submodule) MUST be stored in the shell project**, never in the embedded submodule project itself.

This includes:
- **ALL AI conversations** about the project code
- **ALL AI-generated documentation** for the project
- **ALL AI prompts and templates** used for the project
- **ALL design decisions** documented through AI interactions
- **ANY AI-assisted development materials** about the project

**Location:** All AI documents go in the `ai/` directory of the shell project.

**NEVER:**
- Commit AI documents to the project submodule
- Store AI conversations in the submodule repository
- Put AI-generated documentation in the submodule

**ALWAYS:**
- Store ALL AI materials in `shell-project/ai/`
- Commit AI documents to the shell repository only
- Keep the project submodule completely free of AI artifacts

### 2. Technology Agnostic

**This template is completely technology-agnostic:**
- Works with ANY programming language (Python, JavaScript, Go, Rust, etc.)
- Works with ANY framework (React, Django, Spring, etc.)
- Works with ANY platform (web, mobile, desktop, etc.)
- Makes NO assumptions about the project's technical stack

When working on the template or shell project structure:
- Do NOT add technology-specific examples
- Do NOT assume specific languages or frameworks
- Keep all documentation and scripts technology-agnostic

### 3. File Organization

#### Shell Repository (`{project-name}-shell/`)

**Contains:**
- Private documentation (`docs/`)
- **ALL AI conversations and prompts** (`ai/`)
- Private notes (`notes/`)
- Build/deployment scripts (`scripts/`)
- Configuration templates (`config/`)
- **Project Submodule** (`{project-name}/`)

**Does NOT contain:**
- CONTRIBUTING.md
- CODE_OF_CONDUCT.md
- Style guides
- LICENSE (unless template-specific)
- Project source code

#### Project Submodule (`{project-name}/`)

**Contains:**
- Project source code
- CONTRIBUTING.md - Contribution guidelines
- CODE_OF_CONDUCT.md - Code of conduct
- Style guides - Coding standards and style documentation
- LICENSE - Project license (if applicable)
- Project-specific documentation
- All community and contribution-related files

**Does NOT contain:**
- AI documents, conversations, or private materials
- Private notes
- AI-generated documentation
- Any AI artifacts

### 4. Project Management

**Use the project repository's GitHub issues** for project management, not the shell repository's issues.

When using `gh` command:
```bash
cd <project-name>  # Navigate to project submodule
gh issue list
gh issue create
gh issue view <number>
cd ..  # Return to shell directory
```

The shell repository is for private documentation only. All project management (issues, PRs, milestones, project boards) happens in the actual project repository.

### 5. Git Workflow

**Working on the project:**
```bash
cd <project-name>  # Navigate to project submodule
# Make changes, commit, push
git add .
git commit -m "Your changes"
git push origin main
cd ..  # Return to shell directory
```

**Updating submodule reference:**
```bash
cd ..
git add <project-name>
git commit -m "Update <project-name> submodule"
git push origin main
```

**Adding AI documents:**
```bash
# In shell project root (NOT in submodule)
# Create files in ai/ directory
echo "# AI Conversation - Feature Design" > ai/2024-01-15-feature-design.md
git add ai/
git commit -m "Add AI conversation about feature design"
git push origin main
```

### 6. Security

- **Never commit secrets** - API keys, certificates, passwords, tokens, or credentials
- Use `config/` for configuration templates only, not actual secrets
- Use environment variables or secure storage for sensitive data
- Keep the shell repository private to protect sensitive information

### 7. Version Management

This shell project is based on a template that uses semantic versioning. The version is stored in the `VERSION` file.

**To check for template updates:**
```bash
./scripts/check-update.sh
```

**To update to latest template version:**
```bash
./scripts/update.sh
```

## Project Structure

```text
{project-name}-shell/
├── README.md              # Main project description
├── SETUP.md               # Setup instructions
├── VERSION                # Template version
├── .gitignore            # Git ignore rules
├── .gitmodules           # Git submodule configuration
├── docs/                 # Private project documentation
│   └── AGENT.md         # This file (moved to docs/agents/AGENT.md)
├── ai/                   # ALL AI documents (conversations, prompts, etc.)
├── notes/                # Private notes
├── scripts/              # Utility scripts
├── config/               # Configuration templates
└── {project-name}/       # Git submodule - actual project code
                          # Directory name matches project repository name
```

## Key Principles

1. **Separation of Concerns**
   - Code changes happen in the project submodule
   - Documentation and AI materials stay in the shell
   - Clear boundaries between public and private work

2. **Privacy**
   - Shell repository: Always private
   - Project repository: Public or private, your choice
   - All AI interactions stay in the private shell repository

3. **Clean Public Repositories**
   - Project repository stays professional and focused
   - No AI artifacts, private notes, or internal documentation
   - Easier for collaborators and open-source contributors

## Common Tasks

### Working with Submodules
```bash
# Update a submodule
cd <project-name>
git pull origin main
cd ..
git add <project-name>
git commit -m "Update <project-name> submodule"
```

### Adding Documentation
- Add to `docs/` directory (private project documentation)
- Keep project-specific documentation organized
- Document important decisions

### Storing AI Conversations
- Store in `ai/` directory
- Organize by date or topic
- **NEVER commit to the project submodule**

## Questions to Consider

When helping with this project:
- Am I storing AI documents in the correct location (shell project `ai/` directory)?
- Am I keeping the project submodule free of AI artifacts?
- Am I maintaining the separation between shell and project?
- Am I following the technology-agnostic principle?

## References

- [What is a Shell Project?](shell.md) - Detailed explanation of shell projects
- [Setup Instructions](../SETUP.md) - How to set up a shell project
- [Main README](../README.md) - Overview and getting started guide

## Summary

**Remember:**
- ✅ ALL AI documents about the project → `ai/` directory in shell project
- ✅ Project code → project submodule
- ✅ Community files (CONTRIBUTING, CODE_OF_CONDUCT) → project submodule
- ❌ NEVER put AI documents in the project submodule
- ❌ NEVER put project code in the shell repository
- ❌ NEVER commit secrets or sensitive information
