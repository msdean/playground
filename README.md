# Introduction
This repo allows the user to quickly spin up a vscode-devcontainer-based development environment to be used as a playground or as a project starter.
It copies a project template from the `templates` directory to the `projects` directory and then opens the project in a vscode devcontainer.
If the project already exists, it just opens it in a vscode devcontainer, without making any changes.

# Prerequisites
## Mandatory
- Git
- Docker
## Optional (recommended for the full experience)
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

#

- If running on a remote machine, after the new VScode session will open, run `Dev Containers: Rebuild and Reopen in Container`.
- If running on a local machine, set the variable `PLAYGROUND_LOCAL` to `true` before running the script, and it should open the devcontainer automatically.

## Windows
Source the script in a powershell session. Recommended to import it in your `$PROFILE`:
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
- `-template_name <template name>`: optional, which project template to use. Defaults to `go-dev`. Hit `tab` for auto-completion.
- `-project_name <project-name>`: optional, name of the project. Defaults to `testproj`. Hit `tab` for auto-completion.


# Templates
Templates are stored in the `templates` directory. Each template is a directory containing the following:
 - `.devcontainer` directory containing:
   - `devcontainer.json` file - used by vscode to configure the devcontainer. Mandatory.
   - `Dockerfile` and `docker-compose.yaml` files - used to build and run the devcontainer image.
   - `init.sh` script - used to initialize the project. Optional. For example, for `go-dev` template, it creates a `go.mod` file.
   - `.bashrc` file - used to customize the bash shell. Optional, but recommended for your preference.
   - The project name is embedded in `docker-compose.yaml` as `<PROJECT_NAME>` and is replaced by the script. Optional.
 - Any additional start-up source code. For example, for `go-dev` template, the `main.go` file is used to start the project, and it's inside the `cmd` subdirectory.

# Customization
You can customize the templates to your liking. Some examples:
 - Add a `Makefile` to your template, and add a `make` command to the `init.sh` script to run it.
 - Customize the default VSCode extensions installed in the devcontainer by editing the `devcontainer.json` file.
 - Customize the VSCode settings that will be used in the devcontainer by editing the `devcontainer.json` file.
 - Customize the devcontainer image by editing the `Dockerfile` and `docker-compose.yaml` files.
 - Set a different shell instead of bash by changing the `SHELL` environment variable in the `docker-compose.yaml` file. Make sure it's installed first by adding it to the `Dockerfile`.
 - Enhance an existing template, or create a new one. For example, you can create a `go-dev-cobra` template that uses the `go-dev` template as a base, and adds the `cobra` package to it, and the relevant code to the `main.go` file (or any other files you may feel are relevant). Alternatively create a `python-dev` template, or a `node-dev` template, or any other template you may need.