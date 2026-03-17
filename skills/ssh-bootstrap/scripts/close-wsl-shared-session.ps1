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

Write-Host "Closing WSL shared SSH session for alias '$AliasName'"
& wsl @wslArgs ssh -O exit $AliasName
exit $LASTEXITCODE
