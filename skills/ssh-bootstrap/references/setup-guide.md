# WSL SSH Shared Session 가이드

이 문서는 `ssh-bootstrap` skill이 AI 에이전트가 WSL 안의 사용자 인증을 공유 세션으로만 재사용하도록 안내할 때 참고하는 운영용 레퍼런스다.

## 한눈에 보기

- 기본 쉘은 PowerShell이다.
- 실제 SSH 인증은 WSL 안의 `ssh` 가 담당한다.
- 사용자는 인증만 직접 한다.
- AI는 alias 등록, 세션 시작 명령 제안, 세션 확인, 원격 명령 실행, 세션 종료를 담당한다.
- 복잡한 원격 작업은 단일 문자열 명령 대신 로컬 스크립트를 stdin으로 전달하는 방식을 기본으로 한다.
- 다중 서버 작업은 PowerShell 창 여러 개를 띄운 뒤 인증 완료 후 자동 종료하는 흐름을 기본으로 한다.
- 사용자가 distro 이름을 헷갈리면 AI가 먼저 WSL 목록을 조회해서 후보를 제안한다.

## 필수 요구사항

- Windows에서 PowerShell을 사용 중이어야 한다.
- WSL이 설치되어 있어야 한다.
- 대상 배포판 예: `OracleLinux_9_5`, `Ubuntu` 가 이미 생성되어 있어야 한다.
- 해당 배포판 안에서 `ssh` 명령이 동작해야 한다.
- 사용자가 해당 서버에 로그인할 자격 증명을 이미 알고 있어야 한다.
- 비밀번호, MFA, 개인 키, 패스프레이즈는 사용자만 입력한다.
- AI는 비밀값을 읽거나 저장하지 않는다.

## 표준 진행 순서

1. 사용자가 `host`, `user`, optional `alias`, optional `port` 를 준다.
2. distro가 불명확하면 AI가 먼저 WSL 목록을 조회한다.
3. AI가 적절한 distro를 제안하거나 사용자 확인을 받는다.
4. AI가 WSL alias를 등록한다.
5. 사용자가 PowerShell에서 세션 시작 명령을 실행한다.
6. 사용자가 인증을 직접 완료한다.
7. AI가 세션 상태를 확인한다.
8. AI가 원격 명령을 실행한다.
9. 작업이 끝나면 AI가 세션을 닫는다.

## distro 확인 먼저 하기

사용자가 distro 이름을 정확히 모르더라도 바로 막지 않는다.

AI가 먼저 실행할 명령:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\list-wsl-distros.ps1
```

예를 들어 출력이 아래 같다면:

```text
Ubuntu
OracleLinux_9_5
docker-desktop
docker-desktop-data
```

AI는 일반적으로 다음처럼 진행한다.

- 서버 작업용 배포판처럼 보이는 항목을 우선 제안한다.
- `docker-desktop`, `docker-desktop-data` 같은 내부 용도 배포판은 기본 후보에서 제외한다.
- 사용자가 "오라클 리눅스였던 것 같다" 정도만 말해도 `OracleLinux_9_5` 를 먼저 제안한다.

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
  -HostName YOUR_SERVER_IP `
  -UserName YOUR_USER `
  -Port 22 `
  -Distro OracleLinux_9_5
```

필요하면 `-Distro Ubuntu` 같은 식으로 대상 WSL 배포판을 지정한다.

AI가 이 스크립트로 처리할 수 있는 입력:

- alias 이름
- HostName 또는 IP
- SSH 사용자명
- 포트
- WSL distro 이름

기본 규칙:

- alias를 따로 주지 않으면 `HostName` 값을 그대로 alias로 사용한다.
- 가능하면 별도 이름보다 IP literal 자체를 alias로 우선 사용한다.
- 같은 alias가 이미 `~/.ssh/config` 에 있으면 덮어쓰지 않고 실패해야 한다.

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

IP를 그대로 alias로 쓰면 아래처럼 생성된다.

```sshconfig
Host 10.0.0.12
    HostName 10.0.0.12
    User YOUR_USER
```

사용자는 WSL `~/.ssh/config` 내용을 AI에게 보여줄 필요가 없다.

## 사용자 시작 절차

PowerShell이 기본 쉘이면 WSL 터미널을 따로 열 필요가 없다.

권장 시작 명령:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-sessions.ps1 `
  -AliasNames 10.0.0.12 `
  -Distro OracleLinux_9_5
```

인증 후 창을 자동으로 닫고 shared session만 남기려면:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-sessions.ps1 `
  -AliasNames 10.0.0.12 `
  -Distro OracleLinux_9_5 `
  -Background
```

여러 서버를 한 번에 열어야 하면:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-sessions.ps1 `
  -AliasNames 10.0.0.12,10.0.0.13,10.0.0.14 `
  -Distro OracleLinux_9_5 `
  -OpenInNewWindows `
  -Background
```

비밀번호나 MFA가 필요한 서버는 한 창에서 동시에 처리할 수 없으므로, 병렬 시작은 별도 PowerShell 창을 여는 방식이 기본이다. `-Background` 를 함께 쓰면 인증이 끝난 뒤 각 창이 자동으로 닫히고 shared session만 남는다.

1. 사용자가 PowerShell에서 `start-wsl-shared-sessions.ps1` 를 실행한다.
2. 비밀번호, MFA, 키 패스프레이즈가 필요하면 사용자가 직접 입력한다.
3. 인증이 끝나면 공유 세션이 열린다.
4. 그 뒤부터 AI 에이전트는 alias만 사용해 명령을 실행할 수 있다.

권장 확인:

```bash
ssh -O check 10.0.0.12
```

## 에이전트 실행 스크립트

이 저장소에는 WSL 공유 세션을 전제로 하는 로컬 스크립트가 포함되어 있다.

alias 준비:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\setup-wsl-shared-session-alias.ps1 `
  -HostName YOUR_SERVER_IP `
  -UserName YOUR_USER `
  -Port 22 `
  -Distro OracleLinux_9_5
```

세션 시작:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-sessions.ps1 `
  -AliasNames 10.0.0.12 `
  -Distro OracleLinux_9_5 `
  -Background
```

다중 세션 시작:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\start-wsl-shared-sessions.ps1 `
  -AliasNames 10.0.0.12,10.0.0.13,10.0.0.14 `
  -Distro OracleLinux_9_5 `
  -OpenInNewWindows `
  -Background
```

세션 확인:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\check-wsl-shared-session.ps1 -AliasName 10.0.0.12
```

원격 명령 실행:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\invoke-wsl-shared-command.ps1 `
  -AliasName 10.0.0.12 `
  -RemoteCommand "nginx -t"
```

복잡한 원격 작업 실행:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\invoke-wsl-shared-command.ps1 `
  -AliasName 10.0.0.12 `
  -LocalScriptPath .\scripts\remote-check.sh `
  -ScriptArguments app /var/www/app `
  -Distro OracleLinux_9_5
```

`-RemoteCommand` 는 한 줄짜리 단순 명령에만 쓴다. 아래 같은 경우는 `-LocalScriptPath` 또는 `-RemoteScriptBase64` 를 사용한다.

- heredoc 이 포함된 명령
- 중첩 따옴표가 많은 bash 구문
- command substitution, redirection, `nohup`, background job 설정이 섞인 명령
- 여러 줄 shell 스크립트

## 복잡한 작업 표준 패턴

복잡한 원격 작업은 아래 순서를 기본으로 한다.

1. 로컬에서 완전한 bash 스크립트를 만든다.
2. PowerShell 안에서 즉석 생성할 때는 반드시 single-quoted here-string `@' ... '@` 를 사용한다.
3. `$HOME`, `$!`, `$(...)`, inner quote는 remote bash가 해석해야 하므로 로컬 PowerShell에서 먼저 확장되면 안 된다.
4. 필요한 실행 식별자는 `__RUN_ID__` 같은 placeholder로 넣고, here-string 생성 뒤 `.Replace(...)` 로 치환한다.
5. 실행은 `invoke-wsl-shared-command.ps1 -LocalScriptPath` 또는 `-RemoteScriptBase64` 로 한다.
6. 백그라운드 작업이면 직후에 같은 script transport로 검증 스크립트를 한 번 더 실행한다.

권장 검증 항목:

- 작업 디렉터리 생성 여부
- 실행 스크립트 생성 여부
- 로그 파일 생성 여부
- PID 파일 생성 여부
- `kill -0 <pid>` 기준 프로세스 생존 여부
- 로그 첫 몇 줄이 기대한 형태인지

피해야 할 패턴:

- `-RemoteCommand` 에 heredoc, `nohup`, redirection, command substitution을 한 번에 몰아넣기
- double-quoted here-string으로 base64 원본 스크립트를 만들기
- 시작은 script transport로 하고, 확인은 다시 복잡한 `-RemoteCommand` 로 바꾸기

아래는 검증된 패턴의 핵심 예시다.

```powershell
$runId = Get-Date -Format yyyyMMdd-HHmmss
$script = @'
set -eu
run_dir="$HOME/star-log-run-__RUN_ID__"
script_path="$run_dir/star_printer.sh"
log_path="$run_dir/star_printer.log"
pid_path="$run_dir/star_printer.pid"
mkdir -p "$run_dir"
cat > "$script_path" <<'EOF'
#!/usr/bin/env bash
set -eu
for i in $(seq 1 100); do
  printf '%*s\n' "$i" '' | tr ' ' '*'
  sleep 1
done
EOF
chmod 700 "$script_path"
nohup bash "$script_path" > "$log_path" 2>&1 < /dev/null &
echo $! > "$pid_path"
printf 'RUN_DIR=%s\nLOG=%s\nPID_FILE=%s\nPID=%s\n' "$run_dir" "$log_path" "$pid_path" "$(cat "$pid_path")"
'@
$script = $script.Replace('__RUN_ID__', $runId)
$base64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($script))
pwsh -File .\skills\ssh-bootstrap\scripts\invoke-wsl-shared-command.ps1 `
  -AliasName dev-server `
  -RemoteScriptBase64 $base64 `
  -Distro OracleLinux_9_5
```

세션 종료:

```powershell
pwsh -File .\skills\ssh-bootstrap\scripts\close-wsl-shared-sessions.ps1 `
  -AliasNames 10.0.0.12 `
  -Distro OracleLinux_9_5
```

각 스크립트는 WSL 안의 `ssh` 를 사용하고 비밀번호를 받지 않는다. 세션이 없으면 실패하고, 먼저 사용자가 WSL에서 세션을 열도록 요구한다.

## 에이전트 도구 매핑 예시

- `ssh_check_session`
  - 목적: WSL 공유 세션이 열려 있는지 확인
  - 예시: `pwsh -File .\skills\ssh-bootstrap\scripts\check-wsl-shared-session.ps1 -AliasName 10.0.0.12`
- `ssh_run`
  - 목적: WSL 공유 세션을 통해 단일 원격 명령 실행
  - 예시: `pwsh -File .\skills\ssh-bootstrap\scripts\invoke-wsl-shared-command.ps1 -AliasName 10.0.0.12 -RemoteCommand "ls -al /var/www"`
- `ssh_run_script`
  - 목적: 복잡한 원격 작업을 로컬 스크립트로 안전하게 전달
  - 예시: `pwsh -File .\skills\ssh-bootstrap\scripts\invoke-wsl-shared-command.ps1 -AliasName 10.0.0.12 -LocalScriptPath .\scripts\remote-check.sh -Distro OracleLinux_9_5`
- `ssh_close_session`
  - 목적: 작업 종료 후 세션 정리
  - 예시: `pwsh -File .\skills\ssh-bootstrap\scripts\close-wsl-shared-sessions.ps1 -AliasNames 10.0.0.12`

## 보안 가이드라인

- 비밀번호를 채팅에 붙여넣지 않는다.
- 비밀번호를 환경변수, 저장소 파일, wrapper 인자에 직접 넘기지 않는다.
- 가능하면 작업이 끝난 뒤 WSL에서 `ssh -O exit 10.0.0.12` 처럼 alias를 지정해 세션을 닫는다.
- WSL `~/.ssh/` 권한은 사용자 전용으로 유지한다.

## 보안 체크리스트

- WSL `~/.ssh/` 는 사용자만 접근 가능하게 유지한다.
- WSL `ControlPath` 는 사용자 홈 아래 안전한 경로를 사용한다.
- 저장소와 공유 워크스페이스에 `.ssh` 관련 파일을 두지 않는다.
- WSL 공유 세션이 열리기 전에는 에이전트 원격 작업을 시도하지 않는다.

## 사용 시나리오

### 시나리오 A: 처음 등록하는 서버

1. 사용자가 AI에게 host, user, optional alias, port, distro를 준다.
2. AI는 `setup-wsl-shared-session-alias.ps1` 로 WSL `~/.ssh/config` 에 alias를 추가한다.
3. AI는 사용자에게 PowerShell에서 `start-wsl-shared-sessions.ps1 -AliasNames 10.0.0.12 -Distro OracleLinux_9_5` 를 실행해 인증하라고 안내한다.
4. 사용자가 비밀번호나 MFA를 직접 입력한다.
5. AI는 `check-wsl-shared-session.ps1` 로 세션을 확인한다.
6. AI는 필요한 원격 작업을 수행한다.
7. 작업이 끝나면 `close-wsl-shared-sessions.ps1 -AliasNames 10.0.0.12` 로 세션을 닫는다.

### 시나리오 B: 이미 등록된 서버에서 즉시 작업

1. 사용자가 먼저 PowerShell에서 `start-wsl-shared-sessions.ps1 -AliasNames 10.0.0.12 -Distro OracleLinux_9_5` 로 세션을 연다.
2. 사용자가 AI에게 "방금 연 10.0.0.12 에서 nginx 설정 확인해줘" 라고 요청한다.
3. AI는 `check-wsl-shared-session.ps1` 로 세션 상태를 확인한다.
4. AI는 `invoke-wsl-shared-command.ps1 -AliasName 10.0.0.12 -RemoteCommand "nginx -t"` 를 실행한다.
5. 작업이 끝나면 `close-wsl-shared-sessions.ps1 -AliasNames 10.0.0.12` 로 세션을 닫는다.

### 시나리오 D: 복잡한 배경 작업 실행

1. 사용자가 먼저 PowerShell에서 `start-wsl-shared-sessions.ps1 -AliasNames 10.0.0.12 -Distro OracleLinux_9_5` 로 인증을 완료한다.
2. AI는 복잡한 멀티라인 bash 명령을 `-RemoteCommand` 로 조합하지 않는다.
3. 대신 로컬 임시 스크립트 또는 준비된 스크립트를 만든 뒤 `invoke-wsl-shared-command.ps1 -LocalScriptPath ...` 로 실행한다.
4. inline 생성 시 single-quoted here-string과 placeholder replacement를 사용한다.
5. 실행 직후 같은 script transport로 PID, 로그, 작업 디렉터리를 검증한다.
6. 이 방식은 heredoc, 중첩 따옴표, redirection, `nohup` 같은 구문이 PowerShell 인용 규칙에 깨지지 않게 한다.

### 시나리오 C: 여러 서버를 각각 등록

1. 사용자가 `10.0.0.12`, `10.0.0.13`, `10.0.0.14` 같은 alias 또는 각 host/user를 AI에 알려준다.
2. AI는 alias별로 `setup-wsl-shared-session-alias.ps1` 를 실행해 WSL config를 준비한다.
3. 이후 사용자는 PowerShell에서 `start-wsl-shared-sessions.ps1 -AliasNames ... -OpenInNewWindows -Background` 로 여러 세션 창을 한 번에 띄운다.
4. 각 창에서 비밀번호나 MFA를 직접 완료하면 창은 자동으로 닫힌다.
5. AI는 열린 alias에 대해서만 원격 작업을 수행한다.
6. 작업이 끝나면 `close-wsl-shared-sessions.ps1` 로 여러 세션을 한 번에 닫을 수 있다.

## 응답 작성 규칙

- 설명보다 절차를 우선한다.
- 민감값이 필요한 자리는 `YOUR_SERVER_IP`, `YOUR_USER`, `dev-server` 같은 플레이스홀더를 사용한다.
- alias가 없으면 기본값은 host/IP 값이며, 가능하면 IP literal alias를 우선한다.
- 검증과 실행 단계는 항상 alias만 사용한다.
