$playground_rootdir = Split-Path -Parent $MyInvocation.MyCommand.Path
$playground_template_dir = Join-Path $playground_rootdir "templates" $template
$playground_projects_dir = Join-Path $playground_rootdir "projects"

function ConvertTo-AsciiHex {
    param (
        [Parameter(Mandatory = $true)]
        [string]$inputString
    )

    $hexString = ""

    foreach ($char in $inputString.ToCharArray()) {
        $hexString += [System.Convert]::ToByte($char).ToString("X2")
    }

    return $hexString
}

function Playground() {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory = $false)]
        [string]$project_name = "go-playground",
        [Parameter(Mandatory = $false)]
        [ValidateScript(
            { $_ -in (Get-PlaygroundTemplates) },
            ErrorMessage = "Invalid template name. Use Tab autocompletion or Get-PlaygroundTemplates to see available templates."
        )]
        [string]$template = "go-dev"
    )

    $project_dir = Join-Path $playground_projects_dir $project_name

    if (!(Test-Path $playground_template_dir -PathType Container)) {
        throw "Template $template does not exist"
        exit 1
    }

    # Make sure projects directory exists
    New-Item -ItemType Directory -Path $playground_projects_dir -Force | Out-Null

    # Check if project already exists, if it's not create it
    if (!(Test-Path $project_dir -PathType Container)) {
        Write-Host "Creating project $project_name"

        Copy-Item -Path "$playground_template_dir\*" -Destination $project_dir -Recurse

        # Replace project name in relevant files in .devcontainer directory
        foreach ($file in @("docker-compose.yaml", "devcontainer.json")) {
            # Do something with the file
            Replace-In-File -path "$project_dir\.devcontainer\$file" -pattern "<PROJECT_NAME>" -replacement "$project_name"
        }
    } else {
        Write-Host "Project $project_name already exists. Will open it now."
    }

    Write-Host "Opening project $project_name from directory $project_dir"

    # Open project in VSCode as a dev container
    $project_name_hex = ConvertTo-AsciiHex $project_dir
    & code --folder-uri vscode-remote://dev-container+$project_name_hex/go/src
}
New-Alias -Name play -Value Playground

Function Replace-In-File {
    param (
        [Parameter(Mandatory = $true)]
        [string]$path,
        [Parameter(Mandatory = $true)]
        [string]$pattern,
        [Parameter(Mandatory = $true)]
        [string]$replacement
    )

    (Get-Content $path) -replace $pattern, $replacement | Set-Content $path
}

Function Get-Subdirs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$path
    )

    Get-ChildItem -Path $path -Directory | Select-Object -ExpandProperty Name
}

Function Get-PlaygroundProjects {
    Get-Subdirs $playground_projects_dir
}

Function Get-PlaygroundTemplates {
    Get-Subdirs $playground_template_dir
}

Register-ArgumentCompleter -CommandName Playground -ParameterName project_name -ScriptBlock {
    param($commandName, $parameterName, $stringMatch)
    Get-PlaygroundProjects | Where-Object { $_ -like "$stringMatch*" }
}

Register-ArgumentCompleter -CommandName Playground -ParameterName template -ScriptBlock {
    param($commandName, $parameterName, $stringMatch)
    Get-PlaygroundTemplates | Where-Object { $_ -like "$stringMatch*" }
}