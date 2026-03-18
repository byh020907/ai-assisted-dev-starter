param(
    [string]$ProjectRoot = ".",
    [Alias("SharedCoreRelativePath")]
    [string]$CoreRelativePath = "ai-assisted-dev-starter",
    [string]$ProjectResourcesRoot = ".ai-assisted-dev-starter"
)

$ErrorActionPreference = "Stop"

function Ensure-Directory {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Ensure-FileFromTemplate {
    param(
        [string]$Path,
        [string]$TemplatePath,
        [hashtable]$Replacements = @{}
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        $content = Get-Content -LiteralPath $TemplatePath -Raw

        foreach ($key in $Replacements.Keys) {
            $content = $content.Replace($key, $Replacements[$key])
        }

        Set-Content -LiteralPath $Path -Value $content
    }
}

$resolvedProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot

$docsRoot = Join-Path $resolvedProjectRoot $ProjectResourcesRoot
$projectDocsRoot = Join-Path $docsRoot "project"
$tasksDocsRoot = Join-Path $docsRoot "tasks"
$adrDocsRoot = Join-Path $docsRoot "adr"

Ensure-Directory -Path $docsRoot
Ensure-Directory -Path $projectDocsRoot
Ensure-Directory -Path $tasksDocsRoot
Ensure-Directory -Path $adrDocsRoot

$projectAgentsTemplate = Join-Path $repoRoot "templates/PROJECT_AGENTS.md"
$projectBriefTemplate = Join-Path $repoRoot "templates/PROJECT_BRIEF.md"
$projectTemplateRoot = Join-Path $repoRoot "project-template/.ai-assisted-dev-starter"

$agentsPath = Join-Path $resolvedProjectRoot "AGENTS.md"
$briefPath = Join-Path $projectDocsRoot "brief.md"
$aiCollaborationPath = Join-Path $projectDocsRoot "ai-collaboration.md"
$docsReadmePath = Join-Path $docsRoot "README.md"
$projectReadmePath = Join-Path $projectDocsRoot "README.md"
$tasksReadmePath = Join-Path $tasksDocsRoot "README.md"
$adrReadmePath = Join-Path $adrDocsRoot "README.md"

$coreReference = $CoreRelativePath -replace "\\", "/"
$projectResourcesReference = $ProjectResourcesRoot -replace "\\", "/"

Ensure-FileFromTemplate -Path $agentsPath -TemplatePath $projectAgentsTemplate -Replacements @{
    "{{CORE_PATH}}" = $coreReference
    "{{PROJECT_RESOURCES_ROOT}}" = $projectResourcesReference
}
Ensure-FileFromTemplate -Path $briefPath -TemplatePath $projectBriefTemplate
Ensure-FileFromTemplate -Path $docsReadmePath -TemplatePath (Join-Path $projectTemplateRoot "README.md")
Ensure-FileFromTemplate -Path $projectReadmePath -TemplatePath (Join-Path $projectTemplateRoot "project/README.md")
Ensure-FileFromTemplate -Path $aiCollaborationPath -TemplatePath (Join-Path $projectTemplateRoot "project/ai-collaboration.md") -Replacements @{
    "{{CORE_PATH}}" = $coreReference
    "{{PROJECT_RESOURCES_ROOT}}" = $projectResourcesReference
}
Ensure-FileFromTemplate -Path $tasksReadmePath -TemplatePath (Join-Path $projectTemplateRoot "tasks/README.md")
Ensure-FileFromTemplate -Path $adrReadmePath -TemplatePath (Join-Path $projectTemplateRoot "adr/README.md")

Write-Output "Initialized project structure at $resolvedProjectRoot"
Write-Output "Created missing directories: $projectResourcesReference/, $projectResourcesReference/project/, $projectResourcesReference/tasks/, $projectResourcesReference/adr/"
Write-Output "Created missing files: AGENTS.md, $projectResourcesReference/project/brief.md, $projectResourcesReference/project/ai-collaboration.md, $projectResourcesReference/README.md, $projectResourcesReference/project/README.md, $projectResourcesReference/tasks/README.md, $projectResourcesReference/adr/README.md"
