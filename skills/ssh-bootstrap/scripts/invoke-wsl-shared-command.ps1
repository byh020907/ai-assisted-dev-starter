[CmdletBinding(DefaultParameterSetName = "Command")]
param(
    [Parameter(Mandatory = $true)]
    [string]$AliasName,

    [Parameter(Mandatory = $true, ParameterSetName = "Command")]
    [string]$RemoteCommand,

    [Parameter(Mandatory = $true, ParameterSetName = "ScriptPath")]
    [string]$LocalScriptPath,

    [Parameter(Mandatory = $true, ParameterSetName = "ScriptBase64")]
    [string]$RemoteScriptBase64,

    [string[]]$ScriptArguments,

    [string]$Distro
)

$ErrorActionPreference = "Stop"

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

function Invoke-RemoteScript {
    param(
        [string]$TargetAlias,
        [string]$ScriptContent,
        [string[]]$Args
    )

    if ([string]::IsNullOrWhiteSpace($ScriptContent)) {
        throw "The script content to send to '$TargetAlias' is empty."
    }

    $sshArgs = @("ssh", $TargetAlias, "bash", "-s", "--")
    if ($Args) {
        $sshArgs += $Args
    }

    $tmpFile = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($tmpFile, $ScriptContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "Running script on '$TargetAlias' through the existing WSL shared session"
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = "wsl"
        foreach ($arg in $wslArgs + $sshArgs) {
            [void]$processInfo.ArgumentList.Add($arg)
        }
        $processInfo.RedirectStandardInput = $true
        $processInfo.RedirectStandardOutput = $false
        $processInfo.RedirectStandardError = $false
        $processInfo.UseShellExecute = $false

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $processInfo
        [void]$process.Start()

        $writer = $process.StandardInput
        try {
            Get-Content -Raw $tmpFile | ForEach-Object { $writer.Write($_) }
        } finally {
            $writer.Close()
        }

        $process.WaitForExit()
        exit $process.ExitCode
    } finally {
        if (Test-Path $tmpFile) {
            Remove-Item $tmpFile -Force
        }
    }
}

switch ($PSCmdlet.ParameterSetName) {
    "Command" {
        if ([string]::IsNullOrWhiteSpace($RemoteCommand)) {
            throw "Provide a remote command in -RemoteCommand."
        }

        Write-Host "Running command on '$AliasName' through the existing WSL shared session"
        & wsl @wslArgs ssh $AliasName $RemoteCommand
        exit $LASTEXITCODE
    }
    "ScriptPath" {
        if (-not (Test-Path -LiteralPath $LocalScriptPath)) {
            throw "Local script path '$LocalScriptPath' does not exist."
        }

        $scriptContent = Get-Content -LiteralPath $LocalScriptPath -Raw
        Invoke-RemoteScript -TargetAlias $AliasName -ScriptContent $scriptContent -Args $ScriptArguments
    }
    "ScriptBase64" {
        try {
            $scriptBytes = [Convert]::FromBase64String($RemoteScriptBase64)
        } catch {
            throw "Provide valid base64 in -RemoteScriptBase64."
        }

        $scriptContent = [System.Text.Encoding]::UTF8.GetString($scriptBytes)
        Invoke-RemoteScript -TargetAlias $AliasName -ScriptContent $scriptContent -Args $ScriptArguments
    }
    default {
        throw "Choose one of -RemoteCommand, -LocalScriptPath, or -RemoteScriptBase64."
    }
}
