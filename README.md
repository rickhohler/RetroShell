# Shell Template

A GitHub template for creating a **shell project** - a private git repository that wraps around your actual project repository (as a git submodule) to keep it clean and public-facing.

**Technology Agnostic:** This template works with any programming language, framework, or technology stack. It makes no assumptions about your project's technical stack.

## What is a Shell Project?

For detailed information about shell projects, their purpose, and usage, see [What is a Shell Project?](docs/shell.md).

## Purpose

This template helps maintain a clean separation between:
- **Shell Project** (this repo): Always private, contains private notes, AI documents, and project documentation
- **Project** (submodule): Clean, public or private git repository with the actual project code

## Important: AI Documents and Code Separation

**ALL AI-related documents, conversations, and materials related to the project (submodule) MUST be stored in the shell project**, never in the embedded submodule project itself. This includes:

- AI conversations about the project code
- AI-generated documentation for the project
- AI prompts and templates used for the project
- Design decisions documented through AI interactions
- Any AI-assisted development materials

This ensures:

- **Shell Project** (`{project-name}-shell/`):
  - Contains **all AI documents** in the `ai/` directory
  - Contains private documentation in `docs/`
  - Contains private notes in `notes/`
  - Should remain **private** to protect sensitive information

- **Embedded Submodule Project(s)** (`{project-name}/`):
  - Contains **clean, public-facing code** only
  - **NO AI documents, conversations, or private materials** - ALL AI documentation about the project belongs in the shell project's `ai/` directory
  - Can be safely made **public** without exposing AI interactions
  - Maintains its own independent git history
  - **Note:** Directory name matches the project repository name (not hardcoded as "project")
  - Supports one or more related projects as separate submodules

This separation allows you to keep your AI-assisted development work private while maintaining a clean, professional public codebase.

## Structure

```
{project-name}-shell/
├── README.md              # This file
├── SETUP.md               # Detailed setup instructions
├── VERSION                # Template version (semantic versioning)
├── .gitignore            # Git ignore rules
├── .gitmodules           # Git submodule configuration (add your project here)
├── docs/                 # Private project documentation
│   └── dependencies.md   # Submodule dependency graph
├── ai/                   # AI-generated documents, prompts, and conversations
├── notes/                # Private notes and thoughts
├── scripts/              # Utility scripts for build, deployment, etc.
├── config/               # Configuration files and templates
└── {project-name}/       # Git submodule(s) - your actual project repository(ies)
                         # Directory name matches the project repository name
                         # Can have multiple related projects as submodules
```

## Getting Started

> **Note:** This repository should be enabled as a GitHub template repository. See [GitHub Template Setup Guide](template/GITHUB_TEMPLATE_SETUP.md) for instructions.

### Naming Convention

When creating your shell repository, use the naming pattern: `{project-name}-shell`

**Example:**
- If your project repository is named `my-pet-store-app`
- Your shell repository should be named `my-pet-store-app-shell`

1. **Use this template** to create a new repository (make it private)
   - Click the **"Use this template"** button on GitHub
   - Create a new private repository from this template
   - Name it following the pattern: `{your-project-name}-shell`

2. **Run the setup script**:
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. **Add your project(s) as submodule(s)**:
   ```bash
   # Add your main project (use the project repository name as the directory name)
   git submodule add <your-project-repo-url> <project-name>

   # Example: If your repo is "my-pet-store-app"
   git submodule add https://github.com/username/my-pet-store-app.git my-pet-store-app

   # Initialize submodules
   git submodule update --init --recursive

   # Optional: Add additional related projects
   git submodule add https://github.com/username/my-pet-store-api.git my-pet-store-api
   git submodule add https://github.com/username/my-pet-store-admin.git my-pet-store-admin
   ```

4. **Start organizing your private materials**:
   - Add project-specific documentation to `docs/`
   - Store AI conversations and prompts in `ai/`
   - Keep private notes in `notes/`
   - Add build/deployment scripts to `scripts/`

5. **Work on your project(s)**:
   - Navigate to `{project-name}/` to work on your codebase
   - The project submodule maintains its own git history and can be public or private
   - If you have multiple related projects, each has its own directory

## Best Practices

- **Keep the shell repository private** to protect sensitive information, including all AI documents
- **Keep the project submodule public or private** (depending on your needs) - it contains only clean code
- **NEVER commit AI documents to the submodule project** - ALL AI materials related to the project (including AI conversations, prompts, and AI-generated documentation about the project code) MUST stay in the shell project's `ai/` directory
- Commit changes to the shell repo separately from the project submodule
- Use clear naming conventions in `docs/`, `ai/`, and `notes/` directories
- Document important decisions and context in the shell repo
- Never commit sensitive information like API keys, certificates, or passwords
- Use `config/` for configuration templates, not actual secrets

### Where Files Belong

**Shell Repository** (`{project-name}-shell/`):
- Private documentation (`docs/`)
- AI conversations and prompts (`ai/`)
- Private notes (`notes/`)
- Build/deployment scripts (`scripts/`)
- Configuration templates (`config/`)

**Project Submodule** (`{project-name}/`):
- Project source code
- **CONTRIBUTING.md** - Contribution guidelines
- **CODE_OF_CONDUCT.md** - Code of conduct
- **Style guides** - Coding standards and style documentation
- **LICENSE** - Project license (if applicable)
- Project-specific documentation
- All community and contribution-related files

## Updating Submodules

When a project submodule is updated:

```bash
# For a single project
cd <project-name>
git pull origin main  # or your default branch
cd ..
git add <project-name>
git commit -m "Update <project-name> submodule"

# For multiple projects, update each one
cd <project-name-1>
git pull origin main
cd ../<project-name-2>
git pull origin main
cd ..
git add <project-name-1> <project-name-2>
git commit -m "Update project submodules"
```

## Template Versioning and Updates

This template uses semantic versioning (see `VERSION` file). You can update your shell project to get the latest template improvements.

### Checking for Updates

To check if there are updates available:

```bash
./scripts/check-update.sh
```

This will compare your current version with the latest template version without making any changes.

### Updating Your Shell Project

To update your shell project to the latest template version:

```bash
./scripts/update.sh
```

The update script will:
1. Check your current version
2. Fetch the latest version from the template repository
3. Create a backup of your current files
4. Update template files (with confirmation for modified files)
5. Update the `VERSION` file
6. Optionally add new files from the template

**Important Notes:**
- The update script creates a backup before making changes (saved in `.update-backup-*`)
- Files you've modified will be detected, and you'll be asked before overwriting them
- Your project submodules and custom files are not affected
- Review changes with `git diff` before committing

### Setting Custom Template URL

If you're using a custom template repository, set the `SHELL_TEMPLATE_REPO_URL` environment variable:

```bash
export SHELL_TEMPLATE_REPO_URL="https://github.com/your-username/your-template-repo.git"
./scripts/update.sh
```

### Current Version

The current template version is stored in the `VERSION` file. This helps track which template version your shell project is based on.

## License

This template is provided as-is. Customize as needed for your projects.

