#!/bin/bash

# get_symrepo_commit_hashes.sh
# Captures commit hashes of all symlinked repositories
# This script should be sourced from main_repo_wrapper/

PROJECT_ROOT_DIR="Diplomska/Framework/Work"
MAIN_REPO_OUTERMOST_DIR="Diplomska"
HASH_FILE="${MAIN_REPO_OUTERMOST_DIR}/symrepo_commit_hashes.txt"




echo "Capturing symrepo commit hashes..."

# Ensure we're in the main_repo_wrapper directory
# (the wrapper doesn't have to be called main_repo_wrapper, so we just check if the necessary directories are in place)
if [[ ! -d "Diplomska" ]] || [[ ! -d "manage_symrepos" ]] || [[ ! -d "sysrun" ]] || [[ ! -d "python_logger" ]] || [[ ! -d "CNN_kernel_pruning" ]] || [[ ! -d "sysrun_python_logger" ]]; then
    echo 'Error: Required subdirectories are missing. Look at top of get_symrepo_commit_hashes.sh for more information.'
    return 1
fi

echo "✅ Starting script from inside main_repo_wrapper"





# Create/clear the commit hashes file in main repo
echo "# Symlinked Repository Commit Hashes" > "$HASH_FILE"
echo "# Generated on: $(date)" >> "$HASH_FILE"
echo "" >> "$HASH_FILE"

# Function to get commit hash and info
get_repo_info() {
    local repo_path="$1"
    local repo_name="$2"
    
    if [[ -d "$repo_path" ]]; then
        pushd "$repo_path" > /dev/null
    
        local commit_hash=$(git rev-parse HEAD)
        local commit_msg=$(git log -1 --pretty=format:"%s")
        local branch=$(git branch --show-current)
        local dirty=""
        local added=0 deleted=0
        
        # Check if repo has uncommitted changes
        if ! git diff-index --quiet HEAD --; then
            dirty=" (DIRTY - has uncommitted changes)"

            # Get added/deleted lines count
            read added deleted < <(
                git diff --shortstat HEAD |
                awk '/changed/ { added=$4; deleted=$6 } END { print added+0, deleted+0 }'
            )
        fi
        
        popd > /dev/null
        
        # block writes to $HASH_FILE
        {
            echo "[$repo_name]"
            echo "commit_hash = $commit_hash"
            echo "branch = $branch"
            echo "commit_message = $commit_msg"
            if [[ -n "$dirty" ]]; then
                echo "status = dirty ( +$added/−$deleted )"
            else
                echo "status = clean"
            fi
            echo ""
        } >> "$HASH_FILE"



        if [[ -n "$dirty" ]]; then
            echo "  ✗ $repo_name: $commit_hash ($branch) $dirty — +$added/−$deleted lines"
        else
            echo "  ✓ $repo_name: $commit_hash ($branch) clean"
        fi
        
    else
        echo "  ✗ $repo_name: Directory not found at $repo_path"
    fi
}

# Capture hashes for all symrepos
get_repo_info "manage_symrepos" "manage_symrepos"
get_repo_info "sysrun" "sysrun"
get_repo_info "python_logger" "python_logger" 
get_repo_info "sysrun_python_logger/python_logger" "python_logger"
get_repo_info "CNN_kernel_pruning" "CNN_kernel_pruning"

echo ""
echo "Commit hashes saved to: $HASH_FILE"
echo "Review the file before committing to ensure all symrepos are in desired state."