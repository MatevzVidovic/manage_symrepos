# #!/bin/bash

# # complete_setup.sh
# # Initial setup script for the project - run when opening project for first time
# # This script should be sourced from main_repo_wrapper/

# echo "Setting up project environment..."

# # Ensure we're in the right directory
# if [[ ! -d "Diplomska" ]]; then
#     echo 'Error: Required subdirectories are missing.'
#     return 1
# fi


# # Function to clone repo if it doesn't exist
# clone_if_missing() {
#     local repo_name="$1"
#     local repo_url="$2"
#     local target_branch="$3"
    
#     if [[ ! -d "$repo_name" ]]; then
#         echo "Cloning $repo_name..."
#         git clone "$repo_url" "$repo_name"
        
#         if [[ -n "$target_branch" ]] && [[ "$target_branch" != "main" ]] && [[ "$target_branch" != "master" ]]; then
#             pushd "$repo_name" > /dev/null
#             git checkout -b "$target_branch" 2>/dev/null || git checkout "$target_branch"
#             popd > /dev/null
#         fi
#         echo "  ✓ $repo_name cloned"
#     else
#         echo "  ✓ $repo_name already exists"
#     fi
# }

# # Clone symrepos if they don't exist
# # Note: You'll need to update these URLs with your actual repository URLs
# echo "Checking symlinked repositories..."

# # Example - update with your actual repo URLs:
# # clone_if_missing "sysrun" "https://github.com/yourusername/sysrun.git" "Diplomska"
# # clone_if_missing "python_logger" "https://github.com/yourusername/python_logger.git" "Diplomska"
# # clone_if_missing "CNN_kernel_pruning" "https://github.com/yourusername/CNN_kernel_pruning.git" "Diplomska"

# # For now, just check if they exist
# for repo in "sysrun" "python_logger" "CNN_kernel_pruning"; do
#     if [[ -d "$repo" ]]; then
#         echo "  ✓ $repo exists"
#     else
#         echo "  ⚠ $repo missing - you may need to clone it manually"
#         echo "    Or update this script with the correct repository URL"
#     fi
# done

# # Create symlinks in main repo if they don't exist
# echo "Creating symlinks in main repository..."

# pushd "Diplomska" > /dev/null

# # Create symlinks to the symrepos (adjust paths as needed)
# if [[ ! -L "sysrun" ]] && [[ -d "../sysrun" ]]; then
#     ln -sf "../sysrun" "sysrun"
#     echo "  ✓ Created symlink: Diplomska/sysrun -> ../sysrun"
# fi

# if [[ ! -L "python_logger" ]] && [[ -d "../python_logger" ]]; then
#     ln -sf "../python_logger" "python_logger"
#     echo "  ✓ Created symlink: Diplomska/python_logger -> ../python_logger"
# fi

# if [[ ! -L "CNN_kernel_pruning" ]] && [[ -d "../CNN_kernel_pruning" ]]; then
#     ln -sf "../CNN_kernel_pruning" "CNN_kernel_pruning"
#     echo "  ✓ Created symlink: Diplomska/CNN_kernel_pruning -> ../CNN_kernel_pruning"
# fi

# # Handle nested symlink (sysrun_wrapper/python_logger)
# if [[ -d "sysrun_wrapper" ]]; then
#     if [[ ! -L "sysrun_wrapper/python_logger" ]] && [[ -d "../python_logger" ]]; then
#         ln -sf "../../python_logger" "sysrun_wrapper/python_logger"
#         echo "  ✓ Created symlink: Diplomska/sysrun_wrapper/python_logger -> ../../python_logger"
#     fi
# fi

# popd > /dev/null

# # Handle conda environment
# echo "Setting up conda environment..."

# ENV_FILE="Diplomska/env.yml"
# ENV_NAME="diplomska"  # Change this to your preferred environment name

# if [[ -f "$ENV_FILE" ]]; then
#     # Check if conda env exists
#     if conda env list | grep -q "^$ENV_NAME "; then
#         echo "  ✓ Conda environment '$ENV_NAME' exists, updating..."
#         conda env update -n "$ENV_NAME" -f "$ENV_FILE"
#     else
#         echo "  → Creating conda environment '$ENV_NAME' from $ENV_FILE..."
#         conda env create -n "$ENV_NAME" -f "$ENV_FILE"
#     fi
    
#     # Activate the environment
#     echo "  → Activating conda environment '$ENV_NAME'..."
#     conda activate "$ENV_NAME"
# else
#     echo "  ⚠ No env.yml found at $ENV_FILE"
#     echo "    You may want to create one or activate your environment manually"
# fi

# # Navigate to main repo
# echo "Navigating to main repository..."
# cd Diplomska

# echo ""
# echo "✓ Setup complete!"
# echo "Current directory: $(pwd)"
# echo "Active conda environment: ${CONDA_DEFAULT_ENV:-none}"
# echo ""
# echo "Next steps:"
# echo "- Update repository URLs in this script if needed"
# echo "- Use 'source ../manage_projects/second.sh' for additional terminal tabs"
# echo "- Use 'source ../manage_projects/precommit.sh' before committing"