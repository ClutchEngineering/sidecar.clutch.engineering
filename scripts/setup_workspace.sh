#!/bin/bash
set -e

# Function to clone or update a git repository
clone_or_update_repo() {
    repo_url=$1
    local_path=$2

    if [ -d "$local_path" ]; then
        echo "Updating repository at $local_path"
        cd "$local_path"
        git fetch
        git pull
        cd - > /dev/null
    else
        echo "Cloning repository $repo_url to $local_path"
        git clone "$repo_url" "$local_path"
    fi
}

# Clone or update required repositories
clone_or_update_repo "https://github.com/OBDb/.meta.git" ".meta"
clone_or_update_repo "https://github.com/OBDb/.schemas.git" ".schemas"

# Determine which Python command is available (python or python3)
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "Error: Neither python nor python3 command was found"
    exit 1
fi

echo "Creating workspace..."

# Generate the workspace
./.meta/repo-tools/create_workspace.py --workspace workspace/

echo "Extracting all Connectables..."

# Extract all Connectables
"$PYTHON_CMD" .schemas/python/dump_connectables.py workspace --output=.cache/connectables.json
