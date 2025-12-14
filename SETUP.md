# Setup Instructions

Follow these steps to set up your shell project from this template.

> **Reference:** [GitHub Documentation - Creating a repository from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)

## 1. Create Repository from Template

### Naming Convention

When creating your shell repository, use the naming pattern: `{project-name}-shell`

**Example:**
- If your project repository is named `my-pet-store-app`
- Your shell repository should be named `my-pet-store-app-shell`

1. Click **"Use this template"** button on the GitHub repository page
2. Select **"Create a new repository"**
3. Choose:
   - Repository name: `{your-project-name}-shell` (e.g., `my-pet-store-app-shell`)
   - Description (optional)
   - Visibility: **Private** (required for shell projects)
   - Include all branches: Usually **No** (unless you need them)
4. Click **"Create repository from template"**
5. Clone your new repository

## 2. Add Your Project(s) as Submodule(s)

**Important:** Use the project repository name as the directory name (not a hardcoded "project" directory).

```bash
# Navigate to your cloned shell repository
cd your-shell-project

# Add your project as a submodule (use the project repository name as directory name)
git submodule add <your-project-repo-url> <project-name>

# Example: If your repository is "my-pet-store-app"
git submodule add https://github.com/username/my-pet-store-app.git my-pet-store-app

# Initialize the submodule
git submodule update --init --recursive

# Optional: Add additional related projects
git submodule add https://github.com/username/my-pet-store-api.git my-pet-store-api
git submodule add https://github.com/username/my-pet-store-admin.git my-pet-store-admin
```

Replace `<your-project-repo-url>` with your actual project repository URL and `<project-name>` with your project repository name.

## 3. Configure Git Submodules (Optional)

If you need to specify a specific branch:

1. Edit `.gitmodules` file
2. Update the URL and branch as needed
3. Run `git submodule update --remote` to fetch the specified branch

## 4. Start Organizing

- Add documentation to `docs/`
- Store AI conversations in `ai/`
- Keep private notes in `notes/`
- Work on your project(s) in `{project-name}/` directory(ies)

**Note:** The `template/` directory (if present) contains template maintenance documentation and is not needed for your project. You can safely ignore or delete it.

## 5. Initial Commit

```bash
git add .
git commit -m "Initial shell project setup"
git push origin main
```

## 6. Template Versioning

This template uses semantic versioning. The version is stored in the `VERSION` file. When you create a project from this template, it will include the template version at the time of creation.

### Checking for Template Updates

You can check if there are updates available to the template:

```bash
./scripts/check-update.sh
```

### Updating Your Shell Project

To update your shell project to get the latest template improvements:

```bash
./scripts/update.sh
```

See the [README.md](README.md#template-versioning-and-updates) for more details about the update process.

## Working with Submodules

### Daily Workflow

1. **Work on a project**:
   ```bash
   cd <project-name>
   # Make changes, commit, push
   git add .
   git commit -m "Your changes"
   git push origin main
   ```

2. **Update submodule reference**:
   ```bash
   cd ..
   git add <project-name>
   git commit -m "Update <project-name> submodule"
   git push origin main
   ```

3. **Working with multiple projects**:
   ```bash
   # Work on first project
   cd <project-name-1>
   # ... make changes ...
   git push origin main
   cd ..

   # Work on second project
   cd <project-name-2>
   # ... make changes ...
   git push origin main
   cd ..

   # Update all submodule references
   git add <project-name-1> <project-name-2>
   git commit -m "Update project submodules"
   git push origin main
   ```

### Cloning a Repository with Submodules

If someone clones your shell repository:

```bash
git clone --recursive <your-shell-repo-url>
```

Or if already cloned:

```bash
git submodule update --init --recursive
```

### Updating Submodule to Latest

```bash
# For a single project
cd <project-name>
git pull origin main
cd ..
git add <project-name>
git commit -m "Update <project-name> submodule to latest"
git push origin main

# For multiple projects
cd <project-name-1>
git pull origin main
cd ../<project-name-2>
git pull origin main
cd ..
git add <project-name-1> <project-name-2>
git commit -m "Update project submodules to latest"
git push origin main
```

## Troubleshooting

### Submodule shows as modified but no changes

This usually means the submodule is pointing to a different commit. Update it:

```bash
cd <project-name>
git checkout main  # or your default branch
git pull origin main
cd ..
git add <project-name>
git commit -m "Sync <project-name> submodule"
```

### Need to change submodule URL

1. Edit `.gitmodules` file
2. Run `git submodule sync`
3. Update the submodule: `git submodule update --init --recursive`

