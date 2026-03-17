# WSL SSH Shared Session 가이드

이 문서는 `ssh-bootstrap` skill이 AI 에이전트가 WSL 안의 사용자 인증을 공유 세션으로만 재사용하도록 안내할 때 참고하는 운영용 레퍼런스다.

## 목표

- 사용자가 WSL 터미널에서 직접 인증한다.
- AI 에이전트는 WSL 안에서 이미 열린 공유 세션만 사용한다.
- 원격 실행은 별칭 검증 이후에만 진행한다.

## 핵심 구조

```text
사용자가 WSL에서 인증 -> SSH shared session(ControlMaster) 생성 -> AI는 WSL alias만 사용
                                                             -> 세션 종료 시 AI 접근도 종료
```

- 비밀번호, 개인 키, MFA 코드는 AI가 직접 다루지 않는다.
- 응답에서는 별칭 중심으로 설명하고, 실제 접속 값은 사용자가 WSL 안에서만 관리한다.

## WSL SSH 설정

사용자는 WSL 안의 `~/.ssh/config` 에 세션 공유 설정을 적용한다.
이 단계는 AI가 non-secret 값만 받으면 대신 진행할 수 있다.

AI가 대신 alias를 추가할 때:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\setup-wsl-shared-session-alias.ps1 `
  -AliasName dev-server `
  -HostName YOUR_SERVER_IP `
  -UserName YOUR_USER `
  -Port 22
```

필요하면 `-Distro Ubuntu` 같은 식으로 대상 WSL 배포판을 지정한다.

AI가 이 스크립트로 처리할 수 있는 입력:

- alias 이름
- HostName 또는 IP
- SSH 사용자명
- 포트
- WSL distro 이름

AI가 받으면 안 되는 입력:

- 비밀번호
- MFA 코드
- 개인 키 본문
- 패스프레이즈

예시:

```sshconfig
Host *
    ControlMaster auto
    ControlPath ~/.ssh/ssh-%r@%h:%p
    ControlPersist 10m
    ServerAliveInterval 60

Host dev-server
    HostName YOUR_SERVER_IP
    User YOUR_USER
    ServerAliveCountMax 3
```

사용자는 WSL `~/.ssh/config` 내용을 AI에게 보여줄 필요가 없다.

## 사용자 시작 절차

PowerShell이 기본 쉘이면 WSL 터미널을 따로 열 필요가 없다.

권장 시작 명령:

```powershell
wsl -d OracleLinux_9_5 ssh dev-server
```

wrapper를 쓰려면:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-session.ps1 `
  -AliasName dev-server `
  -Distro OracleLinux_9_5
```

1. 사용자가 PowerShell에서 `wsl -d <distro> ssh dev-server` 또는 `wsl -d <distro> ssh -MNf dev-server` 를 실행한다.
2. 비밀번호, MFA, 키 패스프레이즈가 필요하면 사용자가 직접 입력한다.
3. 인증이 끝나면 공유 세션이 열린다.
4. 그 뒤부터 AI 에이전트는 alias만 사용해 명령을 실행할 수 있다.

권장 확인:

```bash
ssh -O check dev-server
```

## 에이전트 실행 스크립트

이 저장소에는 WSL 공유 세션을 전제로 하는 로컬 스크립트가 포함되어 있다.

alias 준비:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\setup-wsl-shared-session-alias.ps1 `
  -AliasName dev-server `
  -HostName YOUR_SERVER_IP `
  -UserName YOUR_USER `
  -Port 22
```

세션 시작:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-session.ps1 `
  -AliasName dev-server `
  -Distro OracleLinux_9_5
```

세션 확인:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\check-wsl-shared-session.ps1 -AliasName dev-server
```

원격 명령 실행:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\invoke-wsl-shared-command.ps1 `
  -AliasName dev-server `
  -RemoteCommand "nginx -t"
```

세션 종료:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\close-wsl-shared-session.ps1 -AliasName dev-server
```

각 스크립트는 WSL 안의 `ssh` 를 사용하고 비밀번호를 받지 않는다. 세션이 없으면 실패하고, 먼저 사용자가 WSL에서 세션을 열도록 요구한다.

## 에이전트 도구 매핑 예시

- `ssh_check_session`
  - 목적: WSL 공유 세션이 열려 있는지 확인
  - 예시: `pwsh -File .\skills\ssh-bootstrap\scripts\check-wsl-shared-session.ps1 -AliasName dev-server`
- `ssh_run`
  - 목적: WSL 공유 세션을 통해 단일 원격 명령 실행
  - 예시: `pwsh -File .\skills\ssh-bootstrap\scripts\invoke-wsl-shared-command.ps1 -AliasName dev-server -RemoteCommand "ls -al /var/www"`
- `ssh_close_session`
  - 목적: 작업 종료 후 세션 정리
  - 예시: `pwsh -File .\skills\ssh-bootstrap\scripts\close-wsl-shared-session.ps1 -AliasName dev-server`

## 보안 가이드라인

- 비밀번호를 채팅에 붙여넣지 않는다.
- 비밀번호를 환경변수, 저장소 파일, wrapper 인자에 직접 넘기지 않는다.
- 가능하면 작업이 끝난 뒤 WSL에서 `ssh -O exit <alias>` 로 세션을 닫는다.
- WSL `~/.ssh/` 권한은 사용자 전용으로 유지한다.

## 보안 체크리스트

- WSL `~/.ssh/` 는 사용자만 접근 가능하게 유지한다.
- WSL `ControlPath` 는 사용자 홈 아래 안전한 경로를 사용한다.
- 저장소와 공유 워크스페이스에 `.ssh` 관련 파일을 두지 않는다.
- WSL 공유 세션이 열리기 전에는 에이전트 원격 작업을 시도하지 않는다.

## 사용 시나리오

### 시나리오 A: 처음 등록하는 서버

1. 사용자가 AI에게 alias, host, user, port, distro를 준다.
2. AI는 `setup-wsl-shared-session-alias.ps1` 로 WSL `~/.ssh/config` 에 alias를 추가한다.
3. AI는 사용자에게 PowerShell에서 `wsl -d OracleLinux_9_5 ssh dev-server` 를 한 번 실행해 인증하라고 안내한다.
4. 사용자가 비밀번호나 MFA를 직접 입력한다.
5. AI는 `check-wsl-shared-session.ps1` 로 세션을 확인한다.
6. AI는 필요한 원격 작업을 수행한다.

### 시나리오 B: 이미 등록된 서버에서 즉시 작업

1. 사용자가 먼저 PowerShell에서 `wsl -d OracleLinux_9_5 ssh dev-server` 로 로그인한다.
2. 사용자가 AI에게 "방금 연 dev-server 에서 nginx 설정 확인해줘" 라고 요청한다.
3. AI는 `check-wsl-shared-session.ps1` 로 세션 상태를 확인한다.
4. AI는 `invoke-wsl-shared-command.ps1 -AliasName dev-server -RemoteCommand "nginx -t"` 를 실행한다.
5. 작업이 끝나면 필요 시 `close-wsl-shared-session.ps1` 로 세션을 닫는다.

### 시나리오 C: 여러 서버를 각각 등록

1. 사용자가 `dev-server`, `staging-server`, `prod-readonly` 같은 alias와 각 host/user를 AI에 알려준다.
2. AI는 alias별로 `setup-wsl-shared-session-alias.ps1` 를 실행해 WSL config를 준비한다.
3. 이후 사용자는 필요한 서버만 먼저 PowerShell에서 `wsl -d <distro> ssh <alias>` 로 열어 둔다.
4. AI는 열린 alias에 대해서만 원격 작업을 수행한다.

## 응답 작성 규칙

- 설명보다 절차를 우선한다.
- 민감값이 필요한 자리는 `YOUR_SERVER_IP`, `YOUR_USER`, `dev-server` 같은 플레이스홀더를 사용한다.
- 검증과 실행 단계는 항상 alias만 사용한다.
