param(
    [Parameter(Mandatory = $true)]
    [string]$AliasName,

    [string]$Distro,

    [switch]$Background
)

$ErrorActionPreference = "Stop"

$wslArgs = @()
if ($Distro) {
    $wslArgs = @("-d", $Distro)
}

Write-Host "Starting WSL shared SSH session for alias '$AliasName'"
if ($Background) {
    & wsl @wslArgs ssh -MNf $AliasName
} else {
    & wsl @wslArgs ssh $AliasName
}
exit $LASTEXITCODE
