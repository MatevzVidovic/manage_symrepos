#!/bin/bash

# precommit.sh
# Pre-commit tasks - run before committing and when closing project
# This script should be sourced from main_repo_wrapper/

MAIN_REPO_OUTERMOST_DIR="Diplomska"
PROJECT_ROOT_DIR="Diplomska/Framework/Work"
ENV_NAME="ipad"

echo "Running pre-commit tasks..."

# Ensure we're in the right directory
if [[ ! -d "$MAIN_REPO_OUTERMOST_DIR" ]]; then
        echo 'Error: Required subdirectories are missing.'
    return 1
fi


echo "1. Capturing symrepo commit hashes..."
source "${PROJECT_ROOT_DIR}/manage_project/get_symrepo_commit_hashes.sh"




echo ""
echo "2. Updating conda environment file..."
ENV_FILE="env.yml"


# Just in case we don't have it activated.
# Activate conda environment
if conda env list | grep -q "^$ENV_NAME "; then
    echo "Activating conda environment '$ENV_NAME'..."
    conda activate "$ENV_NAME"
else
    echo "⚠ Conda environment '$ENV_NAME' not found"
    echo "You may need to run setup.sh first to create the environment"
    return 1
fi

if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    echo "  → Exporting '$CONDA_DEFAULT_ENV' to $ENV_FILE..."
    conda env export -n "$CONDA_DEFAULT_ENV" > "$ENV_FILE"

    # would remove prfix lines with abspaths. We comment this out for simplicity.
    # grep -v "^prefix:" "$ENV_FILE" > "${ENV_FILE}.tmp" && mv "${ENV_FILE}.tmp" "$ENV_FILE"
    echo "  ✓ Environment saved"
else
    echo "  ⚠ No active conda environment"
fi





echo ""
echo "3. Repository status:"

# Navigate to main repo
pushd "$MAIN_REPO_OUTERMOST_DIR" > /dev/null

if git status &>/dev/null; then
    git status --short
    
    if ! git diff-index --quiet HEAD --; then
        echo "  ⚠ Uncommitted changes detected"
    else
        echo "  ✓ Repository is clean"
    fi
else
    echo "  ⚠ Not in a git repository"
fi

popd > /dev/null

echo ""
echo "✓ Pre-commit tasks complete!"
echo "Next: Review symrepo_commit_hashes.txt → git add . → git commit → git push"