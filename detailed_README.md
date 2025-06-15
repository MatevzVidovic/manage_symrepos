# Project Management Scripts

This directory contains scripts for managing a project with symlinked submodules. The approach uses symlinks to avoid Git submodule complications while maintaining clean separation between repositories.

## Architecture

```
main_repo_wrapper/
├── Diplomska/                    # Main repository (MAIN_REPO_OUTERMOST_DIR)
│   ├── Framework/Work/           # Project root (PROJECT_ROOT_DIR)  
│   ├── manage_projects/          # This directory with scripts
│   ├── sysrun -> ../sysrun       # Symlink to sysrun repo
│   ├── python_logger -> ../python_logger
│   ├── CNN_kernel_pruning -> ../CNN_kernel_pruning
│   ├── sysrun_wrapper/
│   │   └── python_logger -> ../../python_logger
│   ├── symrepo_commit_hashes.txt # Generated file tracking symrepo states
│   └── env.yml                   # Conda environment file
├── sysrun/                       # Separate git repository
├── python_logger/                # Separate git repository
└── CNN_kernel_pruning/           # Separate git repository
```

## Configuration

All scripts use these hardcoded variables at the top:
- `MAIN_REPO_OUTERMOST_DIR="Diplomska"` - Main repository directory name
- `ENV_NAME="ipad"` - Conda environment name
- `PROJECT_ROOT_DIR="Diplomska/Framework/Work"` - Used in precommit.sh

## Scripts

All scripts should be **sourced** (not executed) from the `main_repo_wrapper/` directory.

### `setup.sh`
**Usage**: `source Diplomska/manage_projects/setup.sh`

For the first terminal tab when opening the project.

**What it does**:
- Creates or updates conda environment from `env.yml`
- Activates the conda environment
- Navigates to the main repository root

### `second.sh`
**Usage**: `source Diplomska/manage_projects/second.sh`

For additional terminal tabs after the initial setup.

**What it does**:
- Activates the conda environment
- Navigates to the main repository root
- Shows current git status

### `get_symrepo_commit_hashes.sh`
**Usage**: `source Diplomska/manage_projects/get_symrepo_commit_hashes.sh`

Captures the current state of all symlinked repositories.

**What it does**:
- Records commit hashes, branches, and status of all symrepos
- Creates `symrepo_commit_hashes.txt` in the main repository
- Helps track which versions of symrepos were used with each main repo commit

### `precommit.sh`
**Usage**: `source Diplomska/manage_projects/precommit.sh`

Run before committing changes and when closing the project.

**What it does**:
- Captures symrepo commit hashes
- Updates `env.yml` with current conda environment
- Shows repository status
- Provides commit guidance

## Workflow

### Initial Setup
1. Clone the main repository into `main_repo_wrapper/Diplomska/`
2. Navigate to `main_repo_wrapper/`
3. Run: `source Diplomska/manage_projects/setup.sh`

### Daily Workflow
1. Open terminal, navigate to `main_repo_wrapper/`
2. Run: `source Diplomska/manage_projects/setup.sh`
3. For additional terminals: `source Diplomska/manage_projects/second.sh`
4. Do your work...
5. Before committing: `source Diplomska/manage_projects/precommit.sh`
6. Review `symrepo_commit_hashes.txt` and commit normally

### Creating Convenience Symlinks

Create symlinks in `main_repo_wrapper/` for easier access:

```bash
cd main_repo_wrapper/
ln -sf Diplomska/manage_projects/setup.sh setup
ln -sf Diplomska/manage_projects/second.sh second  
ln -sf Diplomska/manage_projects/precommit.sh precommit
```

Then simply run: `source setup`, `source second`, `source precommit`

## Customization

### For Different Projects
Update these variables in each script:
- `MAIN_REPO_OUTERMOST_DIR` - Change "Diplomska" to your main repo name
- `ENV_NAME` - Change "ipad" to your conda environment name
- `PROJECT_ROOT_DIR` - Update path if needed (used in precommit.sh)

### Repository Tracking
In `get_symrepo_commit_hashes.sh`, modify the repository calls:
```bash
get_repo_info "your_repo_name" "display_name"
```

## Benefits of This Approach

1. **No Git Submodule Complexity**: Each repository remains independent
2. **Clean Development**: Symlinks appear as normal directories to your code
3. **Version Tracking**: `symrepo_commit_hashes.txt` tracks exact versions used
4. **Environment Management**: Automatic conda environment handling
5. **Simple Workflow**: Clear scripts for common tasks

## Troubleshooting

### "Must be run from main_repo_wrapper/ directory"
- Ensure you're in the correct directory when sourcing scripts
- The scripts expect to find the main repository directory

### "Conda environment not found"
- Run `setup.sh` first to create the environment
- Check that `ENV_NAME` matches your actual environment name
- Ensure `env.yml` exists and is valid

### Symlinks not working
- Ensure the target repositories exist in `main_repo_wrapper/`
- Check that symlinks point to the correct relative paths
- On Windows, ensure you have symlink permissions or use Git Bash