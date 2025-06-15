#!/bin/bash

# second.sh
# Quick setup script for additional terminal tabs
# This script should be sourced from main_repo_wrapper/

PROJECT_ROOT_DIR="Diplomska/Framework/Work"
ENV_NAME="ipad"

echo "Setting up additional terminal tab..."

# Activate conda environment
if conda env list | grep -q "^$ENV_NAME "; then
    echo "Activating conda environment '$ENV_NAME'..."
    conda activate "$ENV_NAME"
else
    echo "⚠ Conda environment '$ENV_NAME' not found"
    echo "You may need to run setup.sh first to create the environment"
    return 1
fi

# Navigate to main repo
echo "Navigating to project root..."
cd "$PROJECT_ROOT_DIR"

echo ""
echo "✓ Terminal tab ready!"
echo "Current directory: $(pwd)"
echo "Active conda environment: ${CONDA_DEFAULT_ENV:-none}"

# Optional: Show git status
if git status &>/dev/null; then
    echo ""
    echo "Git status:"
    git status --porcelain | head -5
    if [[ $(git status --porcelain | wc -l) -gt 5 ]]; then
        echo "... and $(( $(git status --porcelain | wc -l) - 5 )) more files"
    fi
fi