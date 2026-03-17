---
name: ssh-bootstrap
description: Reuse an already-authenticated SSH shared session from WSL without exposing passwords, private keys, MFA codes, or raw connection details to the AI agent. Use when Codex needs to operate on a remote server through a WSL SSH alias, verify whether a shared ControlMaster session is active in WSL, run remote commands through that session, or instruct the user how to open or close the shared session safely.
---

# SSH Bootstrap

Guide AI-driven remote work through a user-opened shared SSH session in WSL, not through direct secret handling.

## What This Skill Standardizes

- Detect available WSL distros before asking the user to choose one.
- Register WSL SSH aliases from non-secret inputs only.
- Start one or many shared SSH sessions from PowerShell.
- Let the user complete password or MFA prompts directly.
- Reuse opened sessions for AI-driven remote commands.
- Close one or many shared sessions when work is done.
- Use script-based remote execution for complex shell work so nested quotes and heredocs do not break in PowerShell.

## Required Preconditions

- PowerShell is the working shell.
- WSL is installed and the target distro already exists.
- The distro has `ssh` available.
- The user can authenticate to the target server from WSL.
- The user must enter passwords, MFA codes, or passphrases themselves.
- AI must never be asked to read or store secrets.

## Ask only for non-secret inputs

- Ask the user only for values the agent can safely handle:
  - optional alias name such as `10.0.0.12`
  - host or IP
  - SSH username
  - optional port
  - optional WSL distro name if it is already known
- If the user does not provide an alias, default the alias to the `host` or IP value, and prefer the literal IP form when available.
- Do not ask the user to paste passwords, MFA codes, private keys, or full secret files.
- If the user provides the non-secret connection values, prefer configuring the WSL alias for them with the bundled setup script rather than asking them to hand-edit WSL `~/.ssh/config`.
- If the user does not know the distro name, list WSL distros first and suggest the closest match instead of blocking.

## Enforce safety boundaries

- Treat WSL `~/.ssh/config`, private keys, passwords, MFA codes, socket paths, and raw host connection values as sensitive.
- Do not read WSL `~/.ssh/config`, WSL `~/.ssh/keys/`, shell rc files, password stores, or copied key material unless the user explicitly asks for that exact inspection.
- For any new SSH work request, always start from `start-wsl-shared-sessions.ps1` instead of suggesting a raw `ssh` command first.
- Use only alias-based commands through the bundled wrapper scripts for session start, validation, remote execution, and cleanup.
- If no shared session exists, stop and ask the user to open one from PowerShell with `start-wsl-shared-sessions.ps1` first.

## Follow the default workflow

1. Identify the user's target outcome.
2. Choose one of these paths:
   - WSL shared-session prerequisite setup
   - WSL shared-session health check
   - Remote command execution through an active WSL session
   - Session shutdown after work is complete
3. If the distro is unknown, list WSL distros and choose the best matching distro with the user.
4. If the alias does not exist yet and the user gave non-secret values, create it with the WSL setup script.
5. Ask the user to authenticate by running `start-wsl-shared-sessions.ps1` from PowerShell once.
6. Check whether the shared session is active before running remote work.
7. Use alias-only commands and wrapper scripts.
8. Remind the user to keep secrets and raw connection values outside the repository and outside shared AI-readable files.

## Default Runbook

1. If alias info is missing, ask only for `host`, `user`, optional `alias`, optional `port`, and optional `distro`.
2. If distro is missing or vague, run `list-wsl-distros.ps1` and propose the closest available distro.
3. If alias is not configured, run `setup-wsl-shared-session-alias.ps1`, letting the alias default to the host or IP when the user omitted it.
4. If the user wants one session, always suggest `start-wsl-shared-sessions.ps1` with one alias.
5. If the user wants many sessions, use `start-wsl-shared-sessions.ps1 -OpenInNewWindows -Background`.
6. Before remote work, verify the session with `check-wsl-shared-session.ps1`.
7. For simple one-line commands, use `invoke-wsl-shared-command.ps1 -RemoteCommand`.
8. For multiline shell, heredocs, nested quotes, redirection, or background jobs, prefer `invoke-wsl-shared-command.ps1 -LocalScriptPath` or `-RemoteScriptBase64`.
9. After work, close sessions with `close-wsl-shared-sessions.ps1`.

## Standard pattern for complex remote work

1. Create a full bash script body locally instead of composing a long shell string.
2. If generating the script inline in PowerShell, use a single-quoted here-string so `$HOME`, `$(...)`, and inner quotes are preserved for the remote shell.
3. Replace only explicit placeholders such as `__RUN_ID__` after the here-string is created.
4. Send the script with `invoke-wsl-shared-command.ps1 -LocalScriptPath` or `-RemoteScriptBase64`.
5. For background jobs, have the remote script itself create the run directory, script file, log file, and PID file, then print those paths back.
6. Immediately run a second verification step through the same script transport to confirm:
   - run directory exists
   - script/log/PID files exist
   - PID is populated
   - process is still running
   - first few log lines look correct

## Failure patterns to avoid

- Do not build complex remote commands in `-RemoteCommand` when they contain heredocs, `nohup`, command substitution, or multiple redirections.
- Do not generate base64 payloads from a double-quoted PowerShell here-string when the script contains `$HOME`, `$!`, `$(...)`, or embedded shell quotes. PowerShell will expand them locally and corrupt the remote script.
- Do not mix execution transport styles in one workflow. If the start step used script transport, the validation step should also use script transport.
- Do not treat a background launch as complete until the follow-up verification confirms the PID file and live process.

## Use the bundled reference

- Read [references/setup-guide.md](references/setup-guide.md) when you need the WSL shared-session architecture, `ControlMaster` config block, security checklist, or end-to-end workflow.
- Prefer these bundled scripts for repeatable operations:
  - [scripts/list-wsl-distros.ps1](scripts/list-wsl-distros.ps1)
  - [scripts/setup-wsl-shared-session-alias.ps1](scripts/setup-wsl-shared-session-alias.ps1)
  - [scripts/start-wsl-shared-sessions.ps1](scripts/start-wsl-shared-sessions.ps1)
  - [scripts/check-wsl-shared-session.ps1](scripts/check-wsl-shared-session.ps1)
  - [scripts/invoke-wsl-shared-command.ps1](scripts/invoke-wsl-shared-command.ps1)
  - [scripts/close-wsl-shared-sessions.ps1](scripts/close-wsl-shared-sessions.ps1)
- Reuse command patterns with placeholders only for alias names and non-sensitive paths.

## Produce answers in this shape

Keep responses short and operational:

1. State what the agent can do directly and what the user must still do from PowerShell.
2. If enough non-secret inputs are available, provide or run the exact WSL setup script command for the alias.
3. Provide the exact alias-based command or wrapper script the agent should use next.
4. End with one validation or cleanup command such as `check-wsl-shared-session.ps1` or `close-wsl-shared-sessions.ps1`.

## Apply command rules

- To create a shared-session alias from user-supplied non-secret values, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/setup-wsl-shared-session-alias.ps1 [-AliasName <alias>] -HostName <host> -UserName <user> [-Port <port>] [-Distro <name>]`.
- If `-AliasName` is omitted, the script defaults it to `-HostName`, so an IP host naturally becomes the default session alias.
- If the alias already exists in WSL `~/.ssh/config`, stop and tell the user to reuse the existing alias or choose a different alias instead of overwriting it.
- If the same alias appears more than once in `-AliasNames`, `start-wsl-shared-sessions.ps1` and `close-wsl-shared-sessions.ps1` must fail fast.
- To detect available distros before setup, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/list-wsl-distros.ps1`.
- For any new SSH work request, always start one or many shared sessions with `pwsh -File ./skills/ssh-bootstrap/scripts/start-wsl-shared-sessions.ps1 -AliasNames <alias1>,<alias2> [-Distro <name>] [-OpenInNewWindows] [-Background]`.
- To verify a shared session, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/check-wsl-shared-session.ps1 -AliasName <alias> [-Distro <name>]`.
- To run remote commands, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/invoke-wsl-shared-command.ps1 -AliasName <alias> -RemoteCommand "<command>" [-Distro <name>]`.
- For complex remote operations, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/invoke-wsl-shared-command.ps1 -AliasName <alias> -LocalScriptPath <local-script> [-ScriptArguments <arg1>,<arg2>] [-Distro <name>]`.
- If the script content is already generated in memory, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/invoke-wsl-shared-command.ps1 -AliasName <alias> -RemoteScriptBase64 <base64> [-ScriptArguments <arg1>,<arg2>] [-Distro <name>]`.
- To close one or many shared sessions after work, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/close-wsl-shared-sessions.ps1 -AliasNames <alias1>,<alias2> [-Distro <name>]`.
- When showing prerequisite setup, either run the WSL setup script for the user or instruct them to configure `ControlMaster`, `ControlPath`, and `ControlPersist` inside WSL.
- The user must still authenticate in the PowerShell session that `start-wsl-shared-sessions.ps1` opens or runs in.
- If multiple servers need password or MFA prompts, prefer launching separate PowerShell windows with `start-wsl-shared-sessions.ps1 -OpenInNewWindows -Background` so the user can authenticate each session independently and each window closes after authentication completes.
- When running remote commands, always use the alias and avoid expanding it into raw connection details.
- Do not use `-RemoteCommand` for heredocs, multiline shell fragments, nested quotes, command substitution chains, or long background-job setup commands. Use script transport instead.
- When generating a script inline in PowerShell, prefer a single-quoted here-string plus explicit placeholder replacement. This avoids local expansion of shell variables like `$HOME` before the script reaches the remote host.
- For background jobs, prefer a two-step flow: launch with script transport, then verify with script transport.

## Reject unsafe patterns

- Do not suggest storing SSH secrets in repository files.
- Do not suggest pasting private keys into chat.
- Do not suggest commands that echo passwords into shell history.
- Do not read secret stores or shell startup files to extract credentials for the agent.
- Do not claim the session is active unless `ssh -O check <alias>` succeeded inside WSL or the user provided equivalent evidence.
