# ai-assisted-dev-starter

Codex 기준의 워크플로우와 규칙을 담은 AI 보조 개발 starter core 저장소

## 소개

`ai-assisted-dev-starter`는 AI를 활용한 개발 프로젝트에서
공통으로 재사용할 구조와 운영 규칙을 버전 관리하기 위한 starter core 저장소다.

기본 사용 모델은 파일 복사가 아니라 `git submodule`이다.
각 프로젝트는 이 저장소를 루트의 `ai-assisted-dev-starter/` submodule로 포함하고,
프로젝트별 문서와 산출물은 자신의 루트에서 별도로 관리한다.

이 저장소는 다음을 제공한다.

- Codex 중심의 작업 방식
- 재사용 가능한 운영 규칙
- 문서 기반 협업 템플릿과 초기화 구조
- 공통 프로젝트 구조의 기준
- 실제로 따라할 수 있는 개발 시나리오 예시

## 권장 사용 모델

이 저장소는 아래 두 영역을 분리하는 것을 전제로 한다.

1. starter core
2. project local outputs

`starter core`는 여러 프로젝트가 함께 참조하는 공통 규칙과 템플릿이다.
`project local outputs`는 특정 프로젝트에서만 누적되는 문서와 작업 산출물이다.

권장 원칙은 다음과 같다.

- 공통 구조, 규칙, workflow, 템플릿은 이 저장소 루트에서 관리한다.
- 프로젝트별 개요, 요구사항, task 기록, ADR은 소비 프로젝트의 전용 리소스 루트에서 관리한다.
- 소비 프로젝트는 이 저장소를 버전 고정된 `submodule`로 포함하고, 필요할 때만 업데이트한다.
- 소비 프로젝트 루트에는 얇은 `AGENTS.md`를 두고 starter core 문서를 참조하게 한다.
- 소비 프로젝트에 이미 `docs/`가 있다면 충돌을 피하기 위해 starter 전용 산출물은 별도 루트에 둔다.
- 소비 프로젝트 초기 구조는 `project-template/`과 `templates/`를 기준으로 재현 가능하게 만든다.

## Quick Start

새 프로젝트에서 이 저장소를 쓰려면 아래와 같은 구조를 권장한다.

```text
my-project/
|-- AGENTS.md
|-- .ai-assisted-dev-starter/
|   |-- README.md
|   |-- project/
|   |-- tasks/
|   `-- adr/
`-- ai-assisted-dev-starter/   # git submodule
```

시작 순서는 아래와 같다.

1. 새 프로젝트 루트를 만든다.
2. 이 저장소를 프로젝트 루트의 `ai-assisted-dev-starter` 경로에 `git submodule`로 추가한다.
3. 프로젝트 루트에서 starter core의 초기화 스크립트를 실행해 최소 `AGENTS.md`와 프로젝트 문서 구조를 만든다.
4. 생성된 `AGENTS.md`와 `.ai-assisted-dev-starter/` 기본 파일을 프로젝트에 맞게 채운다.
5. 공통 규칙 업데이트가 필요하면 submodule 버전을 갱신하고, 프로젝트에서 새 gitlink를 커밋한다.

초기 구조가 아직 없다면 아래 스크립트로 바로 초기화할 수 있다.

```powershell
pwsh ./ai-assisted-dev-starter/scripts/init-project-structure.ps1 `
  -ProjectRoot . `
  -SharedCoreRelativePath ai-assisted-dev-starter `
  -ProjectResourcesRoot .ai-assisted-dev-starter
```

이 스크립트는 재현성을 위해 다음 규칙으로 동작한다.

- 없으면 생성한다.
- 이미 있으면 덮어쓰지 않는다.
- 기본 프로젝트 리소스 루트는 `.ai-assisted-dev-starter/`다.
- 생성 대상은 `AGENTS.md`, `.ai-assisted-dev-starter/README.md`, `.ai-assisted-dev-starter/project/README.md`, `.ai-assisted-dev-starter/tasks/README.md`, `.ai-assisted-dev-starter/adr/README.md`, `.ai-assisted-dev-starter/project/brief.md`, `.ai-assisted-dev-starter/project/ai-collaboration.md`다.
- `AGENTS.md`는 starter core를 참조하는 최소 버전으로 생성된다.
- 기존 프로젝트에 `docs/`가 있어도 충돌하지 않는다.
- `.ai-assisted-dev-starter/` 기본 파일은 `project-template/` 구조에서 생성된다.

생성되는 최소 `AGENTS.md` 템플릿은 [PROJECT_AGENTS.md](/D:/projects/ai-assisted-dev-starter/templates/PROJECT_AGENTS.md)에 있다.
프로젝트 로컬 구조 템플릿은 [project-template](/D:/projects/ai-assisted-dev-starter/project-template)에 있다.

프로젝트 루트의 최소 `AGENTS.md` 예시는 아래처럼 생성된다.

```md
# Project AGENTS

이 프로젝트의 공통 AI 운영 규칙은 `ai-assisted-dev-starter/AGENTS.md`를 먼저 따른다.

프로젝트 고유 규칙은 아래 문서를 추가로 본다.

1. `.ai-assisted-dev-starter/project/ai-collaboration.md`
2. `.ai-assisted-dev-starter/project/brief.md`
3. 현재 작업과 관련된 `.ai-assisted-dev-starter/tasks/` 문서
```

이 모델에서는 공통 자산 업데이트와 프로젝트별 산출물 기록을 서로 분리해서 관리할 수 있다.

스크립트를 쓰지 못하는 환경이라면 아래 프롬프트를 그대로 사용해도 된다.

```text
현재 프로젝트 루트에 아래 구조가 없으면 생성해줘.

- AGENTS.md
- .ai-assisted-dev-starter/README.md
- .ai-assisted-dev-starter/project/README.md
- .ai-assisted-dev-starter/project/brief.md
- .ai-assisted-dev-starter/project/ai-collaboration.md
- .ai-assisted-dev-starter/tasks/README.md
- .ai-assisted-dev-starter/adr/README.md

조건:
- 공통 규칙 참조 경로는 `ai-assisted-dev-starter/AGENTS.md`
- 이미 있는 파일은 덮어쓰지 말 것
- AGENTS.md는 최소 진입 문서만 만들 것
- `.ai-assisted-dev-starter`는 starter 전용 프로젝트 리소스 루트로 설명할 것
- 결과는 생성된 파일 목록과 각 파일의 목적까지 함께 요약할 것
```

## 구조 관점

이 저장소는 아래 3가지 관점으로 사용할 수 있다.

1. 모든 프로젝트 공통 구조 사항
2. AI가 개발하면서 참고하는 공통 운영 자산
3. 프로젝트별 특화 구조 및 산출물

이 저장소는 주로 1, 2를 제공한다.
3은 소비 프로젝트에서 별도로 구체화하고 유지하는 영역으로 본다.

## 구성

```text
.
|-- AGENTS.md
|-- README.md
|-- STARTER.md
|-- scenarios
|-- skills
|-- standards
|-- templates
|-- workflows
|-- project-template
`-- scripts
```

## 디렉토리

- `standards/`: 작업 분류와 문서 관례 같은 공통 기준
- `workflows/`: AI가 따라야 할 공통 작업 흐름 문서
- `templates/`: 소비 프로젝트가 참고할 문서 템플릿
- `scenarios/`: 공통 작업 흐름 예시
- `skills/`: 반복 작업을 돕는 skill 문서
- `project-template/`: 소비 프로젝트 로컬 구조의 디렉토리 템플릿
- `scripts/`: 소비 프로젝트 초기화 스크립트

## 공통 구조와 프로젝트 산출물의 경계

아래 항목은 starter core에 둔다.

- 공통 `AGENTS` 진입 규칙
- 공통 AI workflow와 standards
- 문서 템플릿
- 프로젝트 로컬 구조 템플릿
- 재사용 가능한 시나리오와 skill

아래 항목은 소비 프로젝트의 전용 리소스 루트 예를 들어 `.ai-assisted-dev-starter/` 아래에 둔다.

- 프로젝트 개요와 도메인 설명
- 프로젝트별 AI 협업 규칙
- 실제 작업 `task.md`, `worklog.md`, `decision.md`
- 프로젝트 장기 결정용 ADR
- 제품 요구사항, 운영 정책, 팀 규칙

## 예제로 보는 사용 방식

새 프로젝트에서 이 starter core를 붙여 쓸 때는 아래처럼 운영한다.

1. 프로젝트 루트 `AGENTS.md`에서 starter core의 `AGENTS.md`를 참조한다.
2. 공통 기준은 submodule 루트의 `standards/`, `workflows/`, `templates/`, `scenarios/` 문서를 따른다.
3. 프로젝트 고유 AI 협업 자산은 프로젝트 루트 `.ai-assisted-dev-starter/`에서 관리한다.
4. 초기 문서가 없으면 starter core의 초기화 스크립트로 `.ai-assisted-dev-starter/` 구조를 생성한다.
5. 프로젝트 전체 배경과 상위 개요 문서는 `.ai-assisted-dev-starter/project/` 아래에 둔다.
6. task 관련 문서는 `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/` 아래에 함께 둔다.
7. 장기 구조 결정은 `.ai-assisted-dev-starter/adr/`에 남긴다.
8. starter core 자체를 개선할 필요가 있으면 이 저장소에서 변경하고, 이후 각 프로젝트가 submodule 버전을 올려 반영한다.

실제 흐름 예시는 `scenarios/` 아래 시나리오 문서를 참고한다.
