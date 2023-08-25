#!/bin/bash
set -e



#!/bin/bash
set -e

template="go-dev"
# Loop over options
while getopts "t:" opt; do
  case $opt in
    t) # Option t expects an argument
      # Check if the argument is missing or another option
      if [[ -z $OPTARG || $OPTARG == -* ]]; then
        echo "Option -t requires an argument" >&2
        exit 1
      else
        # Assign the argument to the variable
        template=$OPTARG
      fi
      ;;
    \?) # Invalid option
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :) # Missing option argument
      echo "Option -$OPTARG requires an argument" >&2
      exit 1
      ;;
  esac
done

# Shift the positional parameters to skip the options
shift $((OPTIND - 1))

readonly rootdir=$(dirname "$(realpath $0)")
readonly template_dir="$rootdir/templates/$template"
readonly project_name=${1:-"testproj"}
readonly project_dir="$rootdir/projects/$project_name"


if [ ! -d "$template_dir" ]; then
    echo "Template $template does not exist"
    exit 1
fi

# Make sure projects directory exists
mkdir -p "$rootdir/projects"

if [ ! -d "$project_dir" ]; then
        echo "Creating project $project_name"
        cp -ra $template_dir $project_dir
        sed -i "s/<PROJECT_NAME>/$project_name/g" "$project_dir/.devcontainer/docker-compose.yaml"
else
        echo "Project $project_name already exists. Will open it now."
fi

code "$project_dir"


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

# containerID=$(devcontainer up --workspace-folder $project_dir | jq ".containerId" -r)
# code --folder-uri "vscode-remote://dev-container+$containerID$project_dir"

# Open code and manually rebuild and reopen containercode --folder-uri vscode-remote://dev-container+file://<path-to-folder>