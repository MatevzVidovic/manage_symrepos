# Project Management Scripts - Quick Reference


## Main idea
You use other git repos inside your main repo. You could use git submodules, but they complicate things.
So instead you make:
```
main_repo_wrapper/
├── Diplomska/                    # Main repository (MAIN_REPO_OUTERMOST_DIR)
│   ├── Framework/Work/           # Project root (PROJECT_ROOT_DIR)  
│   ├── ├── manage_project/      # This directory with scripts
│   ├── ├── manage_subrepos       # symlink
│   ├── ├── sysrun                # symlink
│   ├── ├── python_logger         # symlink
│   ├── ├── CNN_kernel_pruning    # symlink
│   └── env.yml                   # Conda environment file
├── manage_subrepos/               # Separate git repository (symrepo)
├── sysrun/                       # Separate git repository (symrepo)
├── python_logger/                # Separate git repository (symrepo)
└── CNN_kernel_pruning/           # Separate git repository (symrepo)
├── sysrun_python_logger/
├── ├── python_logger/            # Separate git repo, used as a symrepo in sysrun/

```

The symlinks are simply ignored by git, but they nicely work with code, which is awesome.
But, as you make commits in your main repo, you would like to keep track of 
what commits the symrepos are currently using, so we can set up with exact commit later.

This is what happens in precommit.sh - the commit hasheds get stored to: manage_project/symrepo_commit_hashes.txt

Also,
completely separate from what we describe above,
we want to make conda env management easier.
So inside precommit.sh we automatically save the current conda env to env.yml 
(keeping track of what we might have installed).

And when we open up our project, we run setup.sh, 
where we update the current env based on env.yml.
We also activate it, and cd into our project root.

And when we open up other tabs in the terminal, we run second.sh,
where we only activate the conda env, and cd to project root.


## Adapting to your project
- Clone this repo into main_repo_wrapper/
- Make new branch named {your_main_repo_name}
- Make symlink like so:
ln -s YOUR_PROJECT_ROOT ../../(as many .. to get to main_repo_wrapper/)/manage_symrepos/manage_project
- Change the global vars and get_repo_info and possibly other things.
- Commit this. You are good to go.


## How to Use

**Run from `main_repo_wrapper/` directory:**
```bash
source Diplomska/Framework/Work/manage_project/setup.sh     # First terminal tab you open
source Diplomska/Framework/Work/manage_project/second.sh    # Additional tabs  
source Diplomska/Framework/Work/manage_project/precommit.sh # Before committing
```

**Or create symlink for convenience:**
```bash
ln -s Diplomska/Framework/Work/manage_project/    # symlink to symlink, works fine

# Then use:
source manage_project/setup.sh
source manage_project/second.sh
source manage_project/precommit.sh
```

## What Each Script Does

### `setup.sh`
- Creates/updates conda environment from env.yml
- Activates conda environment
- Navigates to main repo

### `second.sh`  
- Activates conda environment
- Navigates to main repo
- Shows git status

### `precommit.sh`
- Captures symrepo commit hashes
- Updates env.yml from current conda environment
- Shows repository status

### `get_symrepo_commit_hashes.sh`
- Records commit states of all symlinked repositories
- Creates symrepo_commit_hashes.txt for version tracking

## Configuration for Other Projects

### Global Variables to Change
Update these at the top of each script:

```bash
MAIN_REPO_OUTERMOST_DIR="YourRepoName"  # Change "Diplomska"
ENV_NAME="your_env_name"                # Change "ipad"  
PROJECT_ROOT_DIR="YourRepo/Your/Path"   # Change path
```

### Repository Tracking to Modify
In `get_symrepo_commit_hashes.sh`, update these lines:

```bash
get_repo_info "your_repo1" "display_name1"
get_repo_info "your_repo2" "display_name2"
get_repo_info "nested/repo" "nested_repo_name"
```

**Current tracked repos:**
- `get_repo_info "sysrun" "sysrun"`
- `get_repo_info "python_logger" "python_logger"`
- `get_repo_info "sysrun_wrapper/python_logger" "sysrun_wrapper_python_logger"`
- `get_repo_info "CNN_kernel_pruning" "CNN_kernel_pruning"`

## Essential Files
- `env.yml` - Must exist in main repo root
- All scripts must be sourced from `main_repo_wrapper/`
- Symlinked repos should exist as separate directories in `main_repo_wrapper/`