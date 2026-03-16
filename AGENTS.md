# AI 개발 운영 규칙

이 문서는 이 저장소에서 AI 도구가 가장 먼저 읽는 진입 문서다.
상세 규칙은 루트의 기준 문서를 참고하고, 사람 중심 설명은 `README.md`와 `STARTER.md`를 참고한다.

## 최소 핵심 원칙

- 변경은 요청 범위 안에서 최소한으로 수행한다.
- 파괴적이거나 되돌리기 어려운 작업은 사용자 확인 후 진행한다.
- 코드와 문서가 어긋나면 관련 문서를 함께 갱신한다.
- 세션이 바뀌어도 이어질 수 있도록 의도, 영향 범위, 검증 결과를 남긴다.
- 커밋은 사용자가 명시적으로 요청했을 때만 진행한다.

## 문서 생성 기본 규칙

- 프로젝트 로컬 리소스 루트: `.ai-assisted-dev-starter/`
- 프로젝트 상위 문서 위치: `.ai-assisted-dev-starter/project/`
- 프로젝트 개요 기본 문서: `.ai-assisted-dev-starter/project/brief.md`
- 작업 문서 묶음: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/`
- 작업 정의: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/task.md`
- 작업 기록: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/worklog.md`
- 작업 단위 결정: `.ai-assisted-dev-starter/tasks/<date>-<task-slug>/decision.md`

해당 문서가 없으면 `templates/` 템플릿을 기반으로 먼저 생성한다.
이미 문서가 있으면 새로 만들기보다 기존 문서를 갱신하는 것을 우선한다.

## Git 최소 규칙

- stage 범위 선택은 사용자가 직접 한다.
- AI는 staged diff 기준으로 커밋 초안을 제안한다.
- 커밋 전에는 현재 브랜치가 작업 브랜치인지 확인한다.
- 작업 브랜치가 아니면 새 브랜치를 만든 뒤 진행한다.

## 읽는 순서

1. `AGENTS.md`
2. `STARTER.md`
3. 필요한 세부 문서

## 바로 참조할 문서

- 작업 분류 기준: `standards/task-classification.md`
- 문서 관례 기준: `standards/conventions.md`
- 기본 workflow: `workflows/default-workflow.md`
- feature workflow: `workflows/feature-workflow.md`
- git commit workflow: `workflows/git-commit-workflow.md`
- 템플릿: `templates/`
- 프로젝트 로컬 구조 템플릿: `project-template/`

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

