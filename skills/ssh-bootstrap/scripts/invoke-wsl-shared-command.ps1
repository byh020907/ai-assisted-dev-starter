param(
    [Parameter(Mandatory = $true)]
    [string]$AliasName,

    [Parameter(Mandatory = $true)]
    [string]$RemoteCommand,

    [string]$Distro
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RemoteCommand)) {
    throw "Provide a remote command in -RemoteCommand."
}

$wslArgs = @()
if ($Distro) {
    $wslArgs = @("-d", $Distro)
}

$checkOutput = & wsl @wslArgs ssh -O check $AliasName 2>&1
if ($LASTEXITCODE -ne 0) {
    $text = ($checkOutput | Out-String).Trim()
    if ($text -match "No ControlPath specified") {
        throw "Alias '$AliasName' is missing shared-session settings in WSL. Configure ControlMaster, ControlPath, and ControlPersist first."
    }
    throw "No active shared SSH session for alias '$AliasName' in WSL. Ask the user to open one locally first."
}

Write-Host "Running command on '$AliasName' through the existing WSL shared session"
& wsl @wslArgs ssh $AliasName $RemoteCommand
exit $LASTEXITCODE
