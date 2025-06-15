#!/bin/bash

# setup.sh
# Setup script for first terminal tab - handles conda environment and navigation
# This script should be sourced from main_repo_wrapper/

MAIN_REPO_OUTERMOST_DIR="Diplomska"
PROJECT_ROOT_DIR="Diplomska/Framework/Work"
ENV_NAME="ipad"

echo "Setting up first terminal tab..."

# Ensure we're in the right directory
if [[ ! -d "$MAIN_REPO_OUTERMOST_DIR" ]]; then
    echo 'Error: Required subdirectories are missing.'
    return 1
fi

# Handle conda environment
echo "Setting up conda environment..."

ENV_FILE="$MAIN_REPO_OUTERMOST_DIR/env.yml"

if [[ -f "$ENV_FILE" ]]; then
    # Check if conda env exists
    if conda env list | grep -q "^$ENV_NAME "; then
        echo "  ✓ Conda environment '$ENV_NAME' exists, updating..."
        conda env update -n "$ENV_NAME" -f "$ENV_FILE"
    else
        echo "  → Creating conda environment '$ENV_NAME' from $ENV_FILE..."
        conda env create -n "$ENV_NAME" -f "$ENV_FILE"
    fi
    
else
    echo "  ⚠ No env.yml found at $ENV_FILE"
    echo "    Cannot set up conda environment"
    return 1
fi



# Simply do what second.sh already does
source "${PROJECT_ROOT_DIR}/manage_projects/second.sh"


echo "For additional terminal tabs, use: source /manage_projects/second.sh"