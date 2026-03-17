param(
    [Parameter(Mandatory = $true)]
    [string]$AliasName,

    [string]$Distro
)

$ErrorActionPreference = "Stop"

$wslArgs = @()
if ($Distro) {
    $wslArgs = @("-d", $Distro)
}

Write-Host "Checking WSL shared SSH session for alias '$AliasName'"
$output = & wsl @wslArgs ssh -O check $AliasName 2>&1
$exitCode = $LASTEXITCODE
$startHint = "pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-sessions.ps1 -AliasNames $AliasName"
if ($Distro) {
    $startHint += " -Distro $Distro"
}

if ($exitCode -eq 0) {
    $output | Write-Output
    exit 0
}

$text = ($output | Out-String).Trim()
if ($text -match "No ControlPath specified") {
    throw "Alias '$AliasName' is missing shared-session settings in WSL. Configure ControlMaster, ControlPath, and ControlPersist first."
}

if ($text -match "No such file or directory") {
    throw "No active shared SSH session for alias '$AliasName' in WSL. From PowerShell, run '$startHint' and complete authentication first."
}

if ($text) {
    throw $text
}

throw "Shared SSH session check failed for alias '$AliasName' in WSL."
