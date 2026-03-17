---
name: ssh-bootstrap
description: Reuse an already-authenticated SSH shared session from WSL without exposing passwords, private keys, MFA codes, or raw connection details to the AI agent. Use when Codex needs to operate on a remote server through a WSL SSH alias such as `ssh dev-server`, verify whether a shared ControlMaster session is active in WSL, run remote commands through that session, or instruct the user how to open or close the shared session safely.
---

# SSH Bootstrap

Guide AI-driven remote work through a user-opened shared SSH session in WSL, not through direct secret handling.

## Ask only for non-secret inputs

- Ask the user only for values the agent can safely handle:
  - alias name such as `dev-server`
  - host or IP
  - SSH username
  - optional port
  - optional WSL distro name
- Do not ask the user to paste passwords, MFA codes, private keys, or full secret files.
- If the user provides the non-secret connection values, prefer configuring the WSL alias for them with the bundled setup script rather than asking them to hand-edit WSL `~/.ssh/config`.

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
3. If the alias does not exist yet and the user gave non-secret values, create it with the WSL setup script.
4. Ask the user to authenticate by running `wsl -d <distro> ssh <alias>` from PowerShell once.
5. Check whether the shared session is active before running remote work.
6. Use alias-only commands and wrapper scripts.
7. Remind the user to keep secrets and raw connection values outside the repository and outside shared AI-readable files.

## Use the bundled reference

- Read [references/setup-guide.md](references/setup-guide.md) when you need the WSL shared-session architecture, `ControlMaster` config block, security checklist, or end-to-end workflow.
- Prefer these bundled scripts for repeatable operations:
  - [scripts/setup-wsl-shared-session-alias.ps1](scripts/setup-wsl-shared-session-alias.ps1)
  - [scripts/start-wsl-shared-session.ps1](scripts/start-wsl-shared-session.ps1)
  - [scripts/check-wsl-shared-session.ps1](scripts/check-wsl-shared-session.ps1)
  - [scripts/invoke-wsl-shared-command.ps1](scripts/invoke-wsl-shared-command.ps1)
  - [scripts/close-wsl-shared-session.ps1](scripts/close-wsl-shared-session.ps1)
- Reuse command patterns with placeholders only for alias names and non-sensitive paths.

## Produce answers in this shape

Keep responses short and operational:

1. State what the agent can do directly and what the user must still do from PowerShell.
2. If enough non-secret inputs are available, provide or run the exact WSL setup script command for the alias.
3. Provide the exact alias-based command or wrapper script the agent should use next.
4. End with one validation or cleanup command such as `wsl -d <distro> ssh -O check <alias>` or `wsl -d <distro> ssh -O exit <alias>`.

## Apply command rules

- To create a shared-session alias from user-supplied non-secret values, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/setup-wsl-shared-session-alias.ps1 -AliasName <alias> -HostName <host> -UserName <user> [-Port <port>] [-Distro <name>]`.
- To start the interactive shared session from PowerShell, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/start-wsl-shared-session.ps1 -AliasName <alias> [-Distro <name>]`.
- To verify a shared session, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/check-wsl-shared-session.ps1 -AliasName <alias> [-Distro <name>]`.
- To run remote commands, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/invoke-wsl-shared-command.ps1 -AliasName <alias> -RemoteCommand "<command>" [-Distro <name>]`.
- To close the session after work, prefer `pwsh -File ./skills/ssh-bootstrap/scripts/close-wsl-shared-session.ps1 -AliasName <alias> [-Distro <name>]`.
- When showing prerequisite setup, either run the WSL setup script for the user or instruct them to configure `ControlMaster`, `ControlPath`, and `ControlPersist` inside WSL.
- The user must still authenticate in the current PowerShell session when `wsl ... ssh ...` prompts for credentials.
- When running remote commands, always use the alias and avoid expanding it into raw connection details.

## Reject unsafe patterns

- Do not suggest storing SSH secrets in repository files.
- Do not suggest pasting private keys into chat.
- Do not suggest commands that echo passwords into shell history.
- Do not read secret stores or shell startup files to extract credentials for the agent.
- Do not claim the session is active unless `ssh -O check <alias>` succeeded inside WSL or the user provided equivalent evidence.
