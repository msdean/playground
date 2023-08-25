#!/bin/bash
set -e

readonly rootdir=$(dirname "$(realpath $0)")
readonly PROJECT_NAME=${1:-"testproj"}
readonly PROJECT_DIR="$rootdir/projects/$PROJECT_NAME"

# Make sure projects directory exists
mkdir -p "$rootdir/projects"


if [ ! -d "$PROJECT_DIR" ]; then
    echo "Creating project $PROJECT_NAME"
    cp -ra $rootdir/templates/go-dev $PROJECT_DIR
    sed -i "s/<PROJECT_NAME>/$PROJECT_NAME/g" "$PROJECT_DIR/.devcontainer/docker-compose.yaml"
else
    echo "Project $PROJECT_NAME already exists. Will open it now"
fi

code $PROJECT_DIR

# function install_devcontainer_cli() {
#     if command -v devcontainer &> /dev/null
#     then
#         return
#     fi

#     echo "devcontainer CLI could not be found, will install it now"
#     if ! command -v npm &> /dev/null
#     then
#         echo "npm could not be found, will install it now"
#         (
#             cd ~ && \
#             curl -sL https://deb.nodesource.com/setup_16.x | sudo bash - && \
#             sudo apt-get install -y nodejs
#         )
#     fi
#     sudo npm install -g @devcontainers/cli
# }

# install_devcontainer_cli

# containerID=$(devcontainer up --workspace-folder $PROJECT_DIR | jq ".containerId" -r)
# code --folder-uri "vscode-remote://dev-container+$containerID$PROJECT_DIR"

# Open code and manually rebuild and reopen containercode --folder-uri vscode-remote://dev-container+file://<path-to-folder>