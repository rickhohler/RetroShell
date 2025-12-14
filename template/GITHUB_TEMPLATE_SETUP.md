# Setting Up This Repository as a GitHub Template

## Overview

This document explains how to configure this repository as a GitHub template repository, following the [official GitHub documentation](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository).

## Prerequisites

- You must have **admin permissions** to the repository
- The repository should be set up with the desired structure and files
- Ensure no Git LFS files are included (templates cannot include LFS files)

## Steps to Enable Template Repository

1. **Navigate to your repository** on GitHub

2. **Go to Settings**
   - Click on the **Settings** tab (or use the dropdown menu if you don't see it)

3. **Enable Template Repository**
   - Scroll down to find **Template repository** section
   - Check the box to enable it

4. **Save Changes**
   - The repository is now a template!

## What Happens When Enabled

Once enabled as a template:

- A **"Use this template"** button appears on the repository page
- Anyone with access can generate a new repository from this template
- New repositories will have:
  - Same directory structure
  - Same files from the default branch
  - Option to include all branches (with unrelated histories)
  - No connection to the original template repository

## Creating a Repository from This Template

Users can create a new repository from this template by:

1. Clicking **"Use this template"** button on the repository page
2. Selecting **"Create a new repository"**
3. Choosing:
   - Repository name
   - Description
   - Visibility (public/private)
   - Whether to include all branches

## Template Usage

Once enabled as a template, users can:

1. Click the **"Use this template"** button on the repository page
2. Create a new private repository from this template
3. Add their project as a git submodule
4. Start organizing their private materials (AI docs, notes, etc.)

## Best Practices

1. **Keep templates clean** - Only include essential files and structure
2. **Document clearly** - Make sure README explains what the template provides
3. **Test the template** - Create a test repository from your template to verify it works
4. **Update regularly** - Keep templates current with best practices
5. **No Git LFS** - Remember, templates cannot include Git LFS files

## Template Description

The `.github/template-description.md` file provides a description that appears when users click "Use this template". Make sure it's clear and helpful!

## References

- [GitHub Docs: Creating a template repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)
- [GitHub Docs: Creating a repository from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)

