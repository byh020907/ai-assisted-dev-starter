param(
    [Parameter(Mandatory = $true)]
    [string]$AliasName,

    [Parameter(Mandatory = $true)]
    [string]$HostName,

    [Parameter(Mandatory = $true)]
    [string]$UserName,

    [int]$Port = 22,

    [string]$Distro
)

$ErrorActionPreference = "Stop"

$wslArgs = @()
if ($Distro) {
    $wslArgs = @("-d", $Distro)
}

$aliasPattern = [regex]::Escape($AliasName)
$block = @(
    ""
    "# Shared session for $AliasName"
    "Host $AliasName"
    "    HostName $HostName"
    "    User $UserName"
    "    Port $Port"
    "    ControlMaster auto"
    "    ControlPath ~/.ssh/ssh-%r@%h:%p"
    "    ControlPersist 10m"
    "    ServerAliveInterval 60"
    "    ServerAliveCountMax 3"
) -join "`n"

$scriptLines = @(
    "set -eu"
    "mkdir -p ~/.ssh"
    "touch ~/.ssh/config"
    "if grep -Eq '^[[:space:]]*Host[[:space:]]+$aliasPattern([[:space:]]|\$)' ~/.ssh/config; then"
    "  echo ""Host alias '$AliasName' already exists in ~/.ssh/config"" >&2"
    "  exit 1"
    "fi"
    "cp ~/.ssh/config ~/.ssh/config.bak.`$(date +%Y%m%d%H%M%S)"
    "cat >> ~/.ssh/config <<'EOF'"
    $block
    "EOF"
    "chmod 700 ~/.ssh"
    "chmod 600 ~/.ssh/config"
    "echo ""Added shared-session SSH alias '$AliasName' to ~/.ssh/config in WSL"""
    "echo ""Next step: from PowerShell, run 'wsl -d ${Distro:-<your-distro>} ssh $AliasName' and complete authentication locally."""
) -join "`n"

& wsl @wslArgs bash -lc $scriptLines
exit $LASTEXITCODE
