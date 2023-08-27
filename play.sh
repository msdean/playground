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

# Initialize variables
readonly rootdir=$(dirname "$(realpath $0)")
readonly template_dir="$rootdir/templates/$template"
readonly project_name=${1:-"go-playground"}
readonly project_dir="$rootdir/projects/$project_name"


# Check if requested template exists
if [ ! -d "$template_dir" ]; then
    echo "Template $template does not exist"
    exit 1
fi

# Make sure projects directory exists
mkdir -p "$rootdir/projects"

# Check if project already exists, if it's not create it
if [ ! -d "$project_dir" ]; then
        echo "Creating project $project_name"
        cp -ra $template_dir $project_dir
        sed -i "s/<PROJECT_NAME>/$project_name/g" "$project_dir/.devcontainer/docker-compose.yaml"
else
        echo "Project $project_name already exists. Will open it now."
fi


# Open project in VSCode
if [ -z "$LOCAL_PLAYGROUND" ]; then
  echo "Running project $project_name in VSCode, don't forget to run 'Dev Containers: Rebuild and Reopen in Container' after VSCode opens"
  code $project_dir
else
  echo "Running project $project_name in VSCode Dev Container."
  code --folder-uri vscode-remote://dev-container+$(echo -n $project_dir | xxd -p)/go/src
fi