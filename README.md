# Introduction
This repo allows the user to quickly spin up a vscode-devcontainer-based development environment to be used as a playground or as a project starter.
It copies a project template from the `templates` directory to the `projects` directory and then opens the project in a vscode devcontainer.
If the project already exists, it just opens it in a vscode devcontainer, without making any changes.

# Prerequisites
- Docker
- VSCode
- VSCode Remote Containers extension

# Usage
Clone this repo.

## Start playground
### Linux (remote session, or WSL)
Link the script to your path. Recommended to add it to your `~/.bashrc`:
```
ln -s ./play.sh ~/bin/play
```
Run the script:
```
play [-t <template name>] [<project-name>]
```
- `-t <template name>`: optional, which project template to use. Defaults to `go-dev`.
- `<project-name>`: optional, name of the project. Defaults to `testproj`.

## Windows
Source the script in a powershell session. Recommended to import it in your `$PROFILE``:
```
. ./play.ps1
```
or
```
Import-Module -Force "./play.ps1"
```

Run the playground:
```
play [-template_name <template name>] [<project-name>]
```
or
```
play [-template_name <template name>] [-project_name <project-name>]
```
- `-template_name <template name>`: optional, which project template to use. Defaults to `go-dev`.
- `-project_name <project-name>`: optional, name of the project. Defaults to `testproj`.

# Templates
Templates are stored in the `templates` directory. Each template is a directory containing the following:
 - `.devcontainer` directory containing:
   - `devcontainer.json` file - used by vscode to configure the devcontainer. Mandatory.
   - `Dockerfile` and `docker-compose.yaml` files - used to build and run the devcontainer image.
   - `init.sh` script - used to initialize the project. Optional. For example, for `go-dev` template, it creates a `go.mod` file.
   - `.bashrc` file - used to customize the bash shell. Optional, but recommended for your preference.
   - The project name is embedded in `docker-compose.yaml` as `<PROJECT_NAME>` and is replaced by the script. Optional.
 - Any additional start-up source code. For example, for `go-dev` template, the `main.go` file is used to start the project, and it's inside the `cmd` subdirectory.