# AI 개발 운영 규칙

이 문서는 이 저장소에서 AI 도구가 가장 먼저 읽는 진입 문서다.
상세 규칙은 루트의 기준 문서를 참고하고, 사람 중심 설명은 `README.md`와 `STARTER.md`를 참고한다.

## 현재 컨텍스트 판별

- 용어는 `standards/glossary.md`를 기준으로 해석한다.
- 현재 읽는 `AGENTS.md`가 `core` 경로를 먼저 참고하라고 안내하는 얇은 라우터 문서라면 `consumer`의 로컬 `AGENTS.md`로 해석한다.
- `consumer`의 로컬 `AGENTS.md`를 읽고 이 문서로 들어온 경우, 현재 컨텍스트는 `consumer` 작업으로 이어진다고 본다.
- 현재 읽는 `AGENTS.md`가 이 저장소 루트의 원본 문서이고 `project-template/`, `templates/`, `workflows/`, `standards/`, `scripts/` 같은 원본 구조를 직접 설명하면 `core`로 해석한다.
- 별도 표시가 없으면 이 문서를 기준 문서로 보고, 경로와 문서 위치는 `consumer` 기준으로 해석한다.
- `project-template/` 아래 경로는 `consumer`에 생성될 구조의 템플릿 원본 경로다.
- `consumer` 문서로 해결 가능한 요청은 `core` 수정 요청으로 승격하지 않는다.

## 최소 핵심 원칙

- 변경은 요청 범위 안에서 최소한으로 수행한다.
- 파괴적이거나 되돌리기 어려운 작업은 사용자 확인 후 진행한다.
- 코드와 문서가 어긋나면 관련 문서를 함께 갱신한다.
- 세션이 바뀌어도 이어질 수 있도록 의도, 영향 범위, 검증 결과를 남긴다.
- 커밋은 사용자가 명시적으로 요청했을 때만 진행한다.

## 코어 수정 경계

- `ai-assisted-dev-starter/` submodule 안의 문서는 기본적으로 읽기 전용으로 취급한다.
- 프로젝트별 규칙 추가, 예외 정책, 협업 선호, 산출물 기록은 기본적으로 `consumer`의 `.ai-assisted-dev-starter/` 아래에만 기록한다.
- 사용자가 규칙을 추가하려고 할 때 AI는 먼저 프로젝트 전용 규칙인지 공통 규칙인지 판단한다.
- 판단이 애매하면 기본값은 프로젝트 로컬 문서에 기록하는 것이다.
- `core` 자체 수정은 사용자가 명시적으로 starter 개선 또는 공통 규칙 승격을 요청한 경우에만 수행한다.

## 문서 생성 기본 규칙

- 프로젝트 로컬 리소스 루트: `.ai-assisted-dev-starter/`
- 프로젝트 상위 문서 위치: `.ai-assisted-dev-starter/project/`
- 프로젝트 개요 기본 문서: `.ai-assisted-dev-starter/project/brief.md`
- 프로젝트 협업 규칙 문서: `.ai-assisted-dev-starter/project/ai-collaboration.md`
- 작업 문서 묶음: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/`
- 작업 정의: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/task.md`
- 작업 기록: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/worklog.md`
- 작업 단위 결정: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/decision.md`

해당 문서가 없으면 `templates/` 템플릿을 기반으로 먼저 생성한다.
이미 문서가 있으면 새로 만들기보다 기존 문서를 갱신하는 것을 우선한다.
- 규칙 추가 요청을 받으면 먼저 `.ai-assisted-dev-starter/project/` 아래 기존 문서에 기록 가능한지 확인한다.
- 프로젝트 문서로 해결 가능한 요청은 `core` 문서를 수정하지 않는다.

## Git 최소 규칙

- stage 범위 선택은 사용자가 직접 한다.
- AI는 staged diff 기준으로 커밋 초안을 제안한다.
- 커밋 전에는 현재 브랜치가 작업 브랜치인지 확인한다.
- 작업 브랜치가 아니면 새 브랜치를 만든 뒤 진행한다.

## 읽는 순서

1. `AGENTS.md`
2. `STARTER.md`
3. `consumer`에서는 `.ai-assisted-dev-starter/README.md`부터 로컬 문서 계층을 따라간다
4. starter 구조를 확인할 때만 `project-template/README.md`와 그 하위 README를 참고한다
5. 필요한 세부 문서

## 바로 참조할 문서

- 작업 분류 기준: `standards/task-classification.md`
- 문서 관례 기준: `standards/conventions.md`
- 용어 기준: `standards/glossary.md`
- 기본 workflow: `workflows/default-workflow.md`
- feature workflow: `workflows/feature-workflow.md`
- git commit workflow: `workflows/git-commit-workflow.md`
- 템플릿: `templates/`
- 프로젝트 로컬 실제 경로: `.ai-assisted-dev-starter/`
- 프로젝트 로컬 구조 템플릿 원본: `project-template/`

## 예시 문서

아래 문서는 규칙 자체가 아니라 사람 관점의 시나리오 예시다.
필요할 때만 참고한다.

- 프로젝트 시작 시나리오: `scenarios/project-init-scenario.md`
- feature 작업 시나리오: `scenarios/feature-dev-scenario.md`
- git 커밋 시나리오: `scenarios/git-commit-scenario.md`

## 분리 원칙

- `AGENTS.md`에는 항상 지켜야 하는 최소 핵심과 참조 경로만 둔다.
- 세부 분류, 관례, 작업 흐름은 각각 `standards/`, `workflows/`, `templates/`로 분리한다.
- 재현성에 직접 영향을 주는 규칙만 `AGENTS.md`에 남기고, 설명성 내용은 하위 문서로 내린다.

