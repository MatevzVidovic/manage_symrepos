## get_symrepo_commit_hashes.sh

**Header & validation**
- Sets up script and checks we're in main_repo_wrapper/

**Create output file**
- Makes symrepo_commit_hashes.txt with timestamp header

**get_repo_info function**
- Goes into a repo directory
- Gets current commit hash, branch, commit message
- Checks if repo has uncommitted changes (dirty)
- Writes all info to the output file

**Main execution**
- Calls get_repo_info for each symlinked repo (sysrun, python_logger, etc.)
- Shows summary of what was captured

## complete_setup.sh

**Header & validation**
- Checks we're in main_repo_wrapper/

**clone_if_missing function**
- Clones a git repo if it doesn't exist locally
- Optionally switches to a specific branch

**Clone repos section**
- Lists repo URLs to clone (commented out - you need to add real URLs)
- Checks if repos exist, warns if missing

**Create symlinks section**
- Goes into main Diplomska/ repo
- Creates symlinks pointing to the separate repos
- Handles the nested sysrun_wrapper/python_logger symlink

**Conda environment section**
- Looks for env.yml file
- Creates or updates conda environment from it
- Activates the environment

**Final steps**
- Navigates to main repo directory
- Shows completion summary

## second.sh

**Header & validation**
- Checks we're in main_repo_wrapper/

**Activate conda**
- Activates the project's conda environment
- Shows warning if environment doesn't exist

**Navigate & status**
- Goes to main repo directory
- Shows current git status (first 5 modified files)

## precommit.sh

**Header & validation**
- Checks we're in main_repo_wrapper/
- Navigates to main Diplomska/ repo

**Capture commit hashes**
- Runs get_symrepo_commit_hashes.sh to record current symrepo states

**Update conda env**
- Exports current conda environment to env.yml
- Removes local paths from the file

**Git status check**
- Shows current git status
- Warns about uncommitted changes
- Indicates if repo is clean

**File summary**
- Lists staged files (ready to commit)
- Lists modified but unstaged files
- Lists new untracked files

**Guidance**
- Provides next steps for committing

## README.md

**Architecture section**
- Shows the directory structure with symlinks

**Scripts section**
- Explains what each script does and when to use it

**Workflow section**
- Step-by-step instructions for initial setup and daily use

**Configuration section**
- How to customize repo URLs and environment names

**Benefits & troubleshooting**
- Why this approach works and common fixes