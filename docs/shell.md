# What is a Shell Project?

A **shell project** is a git repository that acts as a "shell" or wrapper around another git repository (your actual project). This architectural pattern helps maintain a clean separation between your public-facing code and your private development materials.

## Core Concept

The shell project pattern creates two distinct repositories:

1. **Shell Repository** (`{project-name}-shell`)
   - Always private
   - Contains **ALL AI documents related to the project**, private notes, and sensitive documentation
   - Wraps your actual project as a git submodule
   - **Critical:** ALL AI conversations, prompts, and AI-generated documentation about the project code MUST be stored here, never in the project submodule

2. **Project Repository** (`{project-name}`)
   - Can be public or private
   - Contains only clean, production-ready code
   - **NO AI documents** - ALL AI documentation about this project belongs in the shell repository
   - Maintains its own independent git history

## Why Use a Shell Project?

### Problem It Solves

When developing with AI assistants (like Cursor, GitHub Copilot, Claude, etc.), you generate:
- AI conversation logs
- Prompt templates
- Design decisions documented through AI interactions
- Private notes and thoughts
- Internal documentation

These materials are valuable for your development process but shouldn't be in your public codebase.

### Benefits

1. **Clean Public Repositories**
   - Your actual project repository stays professional and focused
   - No AI artifacts, private notes, or internal documentation
   - Easier for collaborators and open-source contributors

2. **Private Development Materials**
   - All AI conversations and prompts stay private
   - Internal documentation and notes remain secure
   - Sensitive information never leaks to public repos

3. **Separation of Concerns**
   - Code changes happen in the project submodule
   - Documentation and AI materials stay in the shell
   - Clear boundaries between public and private work

4. **Flexible Repository Visibility**
   - Shell repository: Always private
   - Project repository: Public or private, your choice
   - Independent access control

## How It Works

### Repository Structure

```
{project-name}-shell/          # Shell repository (private)
├── README.md                  # Links to this documentation
├── SETUP.md                   # Setup instructions
├── .gitignore
├── .gitmodules                # Points to your project repo(s)
├── docs/                      # Private documentation
│   └── shell.md              # This file
├── ai/                        # AI documents and conversations
├── notes/                     # Private notes
├── scripts/                   # Utility scripts
├── config/                    # Configuration templates
└── {project-name}/            # Git submodule → your actual project
    └── [your actual code]

# Example with multiple related projects:
{project-name}-shell/
├── ...
├── my-pet-store-app/          # First project submodule
├── my-pet-store-api/          # Second project submodule (optional)
└── my-pet-store-admin/        # Third project submodule (optional)
```

**Important:** The directory name matches the project repository name (not hardcoded as "project"). This allows for multiple related projects as separate submodules.

### Git Submodule Relationship

The shell repository uses git submodules to reference your actual project(s). **Use the project repository name as the directory name:**

```bash
# In the shell repository - single project
git submodule add https://github.com/username/my-pet-store-app.git my-pet-store-app

# Multiple related projects
git submodule add https://github.com/username/my-pet-store-app.git my-pet-store-app
git submodule add https://github.com/username/my-pet-store-api.git my-pet-store-api
git submodule add https://github.com/username/my-pet-store-admin.git my-pet-store-admin
```

This creates a link to your project repository without duplicating the code. Each submodule directory contains a reference to a specific commit in its respective project repository. The directory name matches the project repository name, making it clear which project is which.

## Usage

### Creating a Shell Project

1. **Use this template** to create your shell repository:
   - Click "Use this template" on GitHub
   - Name it: `{your-project-name}-shell`
   - Make it **private**

2. **Add your project(s) as submodule(s)**:
   ```bash
   # Use the project repository name as the directory name
   git submodule add <your-project-repo-url> <project-name>

   # Example: Single project
   git submodule add https://github.com/username/my-pet-store-app.git my-pet-store-app
   git submodule update --init --recursive

   # Optional: Add additional related projects
   git submodule add https://github.com/username/my-pet-store-api.git my-pet-store-api
   git submodule add https://github.com/username/my-pet-store-admin.git my-pet-store-admin
   ```

3. **Start organizing**:
   - Store AI conversations in `ai/`
   - Keep private notes in `notes/`
   - Add documentation to `docs/`

### Daily Workflow

#### Working on Your Project(s)

```bash
# Navigate to a project submodule (use the actual project name)
cd <project-name>

# Make changes, commit, push (as normal)
git add .
git commit -m "Add new feature"
git push origin main
```

#### Updating Shell Repository

```bash
# After pushing changes to project, update submodule reference
cd ..
git add <project-name>
git commit -m "Update <project-name> submodule to latest"
git push origin main

# For multiple projects
cd <project-name-1>
# ... make changes and push ...
cd ../<project-name-2>
# ... make changes and push ...
cd ..
git add <project-name-1> <project-name-2>
git commit -m "Update project submodules"
git push origin main
```

#### Adding AI Documents

**Critical Rule:** ALL AI documentation related to the project (submodule) MUST be stored in the shell project's `ai/` directory, NEVER in the project submodule itself.

This includes:
- AI conversations about the project code
- AI-generated documentation for the project
- AI prompts and templates used for the project
- Design decisions documented through AI interactions
- Any AI-assisted development materials

```bash
# Store AI conversations about the project
# Create files in ai/ directory (in the shell project, NOT in the submodule)
echo "# AI Conversation - Feature Design" > ai/2024-01-15-feature-design.md

# Commit to shell repository (not project submodule)
git add ai/
git commit -m "Add AI conversation about feature design"
git push origin main
```

### Managing Project Issues

**Important:** Use the project repository's GitHub issues for project management, not the shell repository's issues.

```bash
# Navigate to project submodule (use the actual project name)
cd <project-name>

# List issues in the project repository
gh issue list

# Create a new issue in the project repository
gh issue create --title "Feature: Add user authentication" --body "Description here"

# View an issue
gh issue view <number>

# Return to shell directory
cd ..
```

The shell repository is for private documentation only. All project management (issues, PRs, milestones, project boards) should happen in the actual project repository.

### Cloning a Shell Project

If someone needs to clone your shell repository:

```bash
# Clone with submodules
git clone --recursive <shell-repo-url>

# Or if already cloned
git submodule update --init --recursive
```

## Best Practices

### Shell Repository

- ✅ **Always keep it private** - Contains sensitive information
- ✅ **Store ALL AI documents here** - ALL AI conversations, prompts, and AI-generated documentation about the project MUST be in the `ai/` directory
- ✅ **Commit AI documents regularly** - Track your development process
- ✅ **Document decisions** - Use `docs/` for internal documentation
- ✅ **Never commit secrets** - Use `config/` for templates only
- ✅ **Project-specific community files** - CONTRIBUTING.md, CODE_OF_CONDUCT.md, and style guides belong in the project submodule, not here

### Project Submodule

- ✅ **Keep it clean** - Only production-ready code
- ✅ **NO AI artifacts** - ALL AI documentation about the project belongs in the shell repository, NEVER in the submodule
- ✅ **No private notes** - Keep internal thoughts in the shell
- ✅ **No AI conversations** - All AI interactions about the project code must be documented in the shell project
- ✅ **Public or private** - Your choice based on project needs
- ✅ **Community files** - CONTRIBUTING.md, CODE_OF_CONDUCT.md, style guides, and license files belong here

### Naming Convention

- **Project repository**: `my-pet-store-app`
- **Shell repository**: `my-pet-store-app-shell`

This makes it clear which is which and maintains consistency.

## Common Use Cases

### Open Source Projects

- **Project repo**: Public, clean code for contributors
- **Shell repo**: Private, contains your development process and AI-assisted work

### Commercial Projects

- **Project repo**: Private, your actual codebase
- **Shell repo**: Private, your development materials and AI interactions

### Personal Projects

- **Project repo**: Public or private, your code
- **Shell repo**: Private, your notes and AI conversations

## Troubleshooting

### Submodule Shows as Modified

If the submodule appears modified but you haven't changed anything:

```bash
cd <project-name>
git checkout main  # or your default branch
git pull origin main
cd ..
git add <project-name>
git commit -m "Sync <project-name> submodule"
```

### Changing Submodule URL

If you need to point to a different repository:

1. Edit `.gitmodules` file
2. Run `git submodule sync`
3. Update: `git submodule update --init --recursive`

### Working with Multiple Branches

```bash
# Update submodule to specific branch
cd <project-name>
git checkout feature-branch
git pull origin feature-branch
cd ..
git add <project-name>
git commit -m "Update <project-name> submodule to feature-branch"
```

## Advanced Topics

### Multiple Related Projects

You can have multiple related projects as submodules in one shell. Use each project's repository name as the directory name:

```bash
# Add multiple related projects
git submodule add https://github.com/username/my-pet-store-app.git my-pet-store-app
git submodule add https://github.com/username/my-pet-store-api.git my-pet-store-api
git submodule add https://github.com/username/my-pet-store-admin.git my-pet-store-admin

# Or with different naming if preferred
git submodule add <frontend-repo> frontend
git submodule add <backend-repo> backend
git submodule add <mobile-repo> mobile
```

Each submodule maintains its own independent git history and can be managed separately.

### CI/CD Considerations

When setting up CI/CD:
- Build from the `project/` submodule
- Don't expose shell repository contents
- Use project repository for deployments

### Team Collaboration

- **Shell repository**: Share with team members who need access to development materials
- **Project repository**: Standard collaboration, code reviews, etc.
- Clear separation helps maintain focus

## References

- [Git Submodules Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub Template Repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)
- [Git Submodule Best Practices](https://www.atlassian.com/git/tutorials/git-submodule)

