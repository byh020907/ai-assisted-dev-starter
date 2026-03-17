---
name: ssh-bootstrap
description: Reuse an already-authenticated SSH shared session from WSL without exposing passwords, private keys, MFA codes, or raw connection details to the AI agent. Use when Codex needs to operate on a remote server through a WSL SSH alias such as `ssh dev-server`, verify whether a shared ControlMaster session is active in WSL, run remote commands through that session, or instruct the user how to open or close the shared session safely.
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

## Required Preconditions

- PowerShell is the working shell.
- WSL is installed and the target distro already exists.
- The distro has `ssh` available.
- The user can authenticate to the target server from WSL.
- The user must enter passwords, MFA codes, or passphrases themselves.
- AI must never be asked to read or store secrets.

## Ask only for non-secret inputs

- Ask the user only for values the agent can safely handle:
  - alias name such as `dev-server`
  - host or IP
  - SSH username
  - optional port
  - optional WSL distro name if it is already known
- Do not ask the user to paste passwords, MFA codes, private keys, or full secret files.
- If the user provides the non-secret connection values, prefer configuring the WSL alias for them with the bundled setup script rather than asking them to hand-edit WSL `~/.ssh/config`.
- If the user does not know the distro name, list WSL distros first and suggest the closest match instead of blocking.

## Enforce safety boundaries

- Treat WSL `~/.ssh/config`, private keys, passwords, MFA codes, socket paths, and raw host connection values as sensitive.
- Do not read WSL `~/.ssh/config`, WSL `~/.ssh/keys/`, shell rc files, password stores, or copied key material unless the user explicitly asks for that exact inspection.
- Prefer asking the user to start the session from PowerShell with `wsl -d <distro> ssh <alias>` rather than telling them to manually open a separate WSL terminal.
- Use only alias-based commands such as `wsl ssh dev-server`, `wsl scp file dev-server:/path`, or the bundled wrapper scripts.
- If no shared session exists, stop and ask the user to open one from their WSL terminal first.

## Follow the default workflow

1. Identify the user's target outcome.
2. Choose one of these paths:
   - WSL shared-session prerequisite setup
   - WSL shared-session health check
   - Remote command execution through an active WSL session
   - Session shutdown after work is complete
3. If the distro is unknown, list WSL distros and choose the best matching distro with the user.
4. If the alias does not exist yet and the user gave non-secret values, create it with the WSL setup script.
5. Ask the user to authenticate by running `wsl -d <distro> ssh <alias>` from PowerShell once.
6. Check whether the shared session is active before running remote work.
7. Use alias-only commands and wrapper scripts.
8. Remind the user to keep secrets and raw connection values outside the repository and outside shared AI-readable files.

## Default Runbook

1. If alias info is missing, ask only for `alias`, `host`, `user`, optional `port`, and optional `distro`.
2. If distro is missing or vague, run `list-wsl-distros.ps1` and propose the closest available distro.
3. If alias is not configured, run `setup-wsl-shared-session-alias.ps1`.
4. If the user wants one session, suggest `wsl -d <distro> ssh <alias>` or `start-wsl-shared-sessions.ps1` with one alias.
5. If the user wants many sessions, prefer `start-wsl-shared-sessions.ps1 -OpenInNewWindows -Background`.
6. Before remote work, verify the session with `check-wsl-shared-session.ps1`.
7. Run remote work with `invoke-wsl-shared-command.ps1`.
8. After work, close sessions with `close-wsl-shared-sessions.ps1`.

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
4. End with one validation or cleanup command such as `wsl -d <distro> ssh -O check <alias>` or `wsl -d <distro> ssh -O exit <alias>`.

## Apply command rules

- To create a shared-session alias from user-supplied non-secret values, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/setup-wsl-shared-session-alias.ps1 -AliasName <alias> -HostName <host> -UserName <user> [-Port <port>] [-Distro <name>]`.
- To detect available distros before setup, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/list-wsl-distros.ps1`.
- To start one or many shared sessions, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/start-wsl-shared-sessions.ps1 -AliasNames <alias1>,<alias2> [-Distro <name>] [-OpenInNewWindows] [-Background]`.
- To verify a shared session, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/check-wsl-shared-session.ps1 -AliasName <alias> [-Distro <name>]`.
- To run remote commands, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/invoke-wsl-shared-command.ps1 -AliasName <alias> -RemoteCommand "<command>" [-Distro <name>]`.
- To close one or many shared sessions after work, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/close-wsl-shared-sessions.ps1 -AliasNames <alias1>,<alias2> [-Distro <name>]`.
- When showing prerequisite setup, either run the WSL setup script for the user or instruct them to configure `ControlMaster`, `ControlPath`, and `ControlPersist` inside WSL.
- The user must still authenticate in the current PowerShell session when `wsl ... ssh ...` prompts for credentials.
- If multiple servers need password or MFA prompts, prefer launching separate PowerShell windows with `start-wsl-shared-sessions.ps1 -OpenInNewWindows -Background` so the user can authenticate each session independently and each window closes after authentication completes.
- When running remote commands, always use the alias and avoid expanding it into raw connection details.

## Reject unsafe patterns

- Do not suggest storing SSH secrets in repository files.
- Do not suggest pasting private keys into chat.
- Do not suggest commands that echo passwords into shell history.
- Do not read secret stores or shell startup files to extract credentials for the agent.
- Do not claim the session is active unless `ssh -O check <alias>` succeeded inside WSL or the user provided equivalent evidence.
