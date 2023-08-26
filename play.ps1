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

function Start-Playground() {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory = $false)]
        [string]$project_name = "testproj",
        [Parameter(Mandatory = $false)]
        [string]$template = "go-dev"
    )

    $project_dir = Join-Path $playground_projects_dir $project_name

    if (!(Test-Path $playground_template_dir -PathType Container)) {
        Write-Host "Template $template does not exist"
        exit 1
    }

    # Make sure projects directory exists
    New-Item -ItemType Directory -Path $playground_projects_dir -Force | Out-Null

    # Check if project already exists, if it's not create it
    if (!(Test-Path $project_dir -PathType Container)) {
        Write-Host "Creating project $project_name"
        Copy-Item -Path $playground_template_dir -Destination $project_dir -Recurse
  (Get-Content "$project_dir\.devcontainer\docker-compose.yaml") -replace "<PROJECT_NAME>", "$project_name" | Set-Content "$project_dir\.devcontainer\docker-compose.yaml"
    }
    else {
        Write-Host "Project $project_name already exists. Will open it now."
    }

    Write-Host "Opening project $project_name from directory $project_dir"

    # Open project in VSCode as a dev container
    $project_name_hex = ConvertTo-AsciiHex $project_dir
    & code --folder-uri vscode-remote://dev-container+$project_name_hex/go/src
}
New-Alias -Name play -Value Start-Playground
New-Alias -Name playground -Value Start-Playground

Register-ArgumentCompleter -CommandName Start-Playground -ParameterName project_name -ScriptBlock {
    param($commandName,$parameterName,$stringMatch)
    $projects = Get-ChildItem -Path $playground_projects_dir -Directory | Select-Object -ExpandProperty Name
    $projects | Where-Object { $_ -like "$stringMatch*" }
}

Register-ArgumentCompleter -CommandName Start-Playground -ParameterName template -ScriptBlock {
    param($commandName,$parameterName,$stringMatch)
    $projects = Get-ChildItem -Path $playground_template_dir -Directory | Select-Object -ExpandProperty Name
    $projects | Where-Object { $_ -like "$stringMatch*" }
}