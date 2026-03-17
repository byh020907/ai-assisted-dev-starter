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

Write-Host "Starting WSL shared SSH session for alias '$AliasName'"
& wsl @wslArgs ssh $AliasName
exit $LASTEXITCODE
