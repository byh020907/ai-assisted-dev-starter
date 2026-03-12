# ai-assisted-dev-starter

Codex 기준의 워크플로우와 규칙을 담은 AI 보조 개발 스타터 저장소

## 소개

`ai-assisted-dev-starter`는 AI를 활용한 개발 프로젝트를 시작할 때 공통으로 가져다 쓰는 베이스 저장소다.

이 저장소는 다음을 제공한다.

- Codex 중심의 작업 방식
- 재사용 가능한 운영 규칙
- 문서 기반 협업 템플릿
- 공통 프로젝트 시작 구조
- 실제로 따라할 수 있는 개발 시나리오 예시

## Quick Start

새 프로젝트에서 이 스타터를 바로 쓰려면 아래 순서로 시작하면 된다.

1. 루트에서는 `README.md`를 제외한 파일과 폴더를 복사한다.
2. `ai/` 디렉토리는 그대로 유지한다.
3. `docs/` 아래 내용은 각 폴더의 `README.md`만 남기고 나머지 예시 문서를 삭제한 뒤 시작한다.
4. 프로젝트 개요가 필요해지면 `docs/project/brief.md`를 만들고, 없으면 `ai/templates/PROJECT_BRIEF.md`를 기준으로 작성한다.
5. 실제 작업을 시작하면 `AGENTS.md`를 먼저 읽고, 이어서 `ai/README.md`와 필요한 세부 문서를 참조한다.

초기 정리 기준 예시는 아래와 같다.

```text
keep:
- AGENTS.md
- ai/
- docs/README.md
- docs/project/README.md
- docs/tasks/README.md
- docs/adr/README.md

remove before starting:
- docs/project/* (except README.md)
- docs/tasks/* (except README.md)
- docs/adr/* (except README.md)
```

이렇게 시작하면 AI가 참고할 기준 문서는 유지하면서, 사람용 예시 산출물은 비운 상태로 프로젝트에 맞게 채워갈 수 있다.

## 구조 관점

이 저장소는 아래 3가지 관점으로 사용할 수 있다.

1. 모든 프로젝트 공통 구조 사항
2. AI가 개발하면서 만드는 산출물 구조
3. 프로젝트별 특화된 구조 및 규칙 사항

현재 루트에는 1, 2가 바로 반영되어 있고, 3은 각 프로젝트에서 별도로 구체화하는 영역으로 본다.

## 구성

```text
.
|-- AGENTS.md
|-- README.md
|-- ai
|   |-- README.md
|   |-- scenarios
|   |-- skills
|   |-- standards
|   |   |-- conventions.md
|   |   `-- task-classification.md
|   |-- templates
|   `-- workflows
|-- docs
|   |-- README.md
|   |-- adr
|   |-- project
|   `-- tasks
```

## 디렉토리

- `ai/`: AI가 참조하는 전용 기준, workflow, skill, templates, scenarios
- `ai/standards/`: 작업 분류와 문서 관례 같은 공통 기준
- `ai/workflows/`: AI가 따라야 할 작업 흐름 문서
- `ai/templates/`: AI가 작업 문서 초안을 만들 때 사용하는 템플릿
- `ai/scenarios/`: AI가 작업 흐름 예시로 참고하는 시나리오 문서
- `ai/skills/`: 반복 작업을 돕는 skill 문서
- `docs/`: 사람이 읽고 관리하는 운영 문서와 프로젝트 산출물
- `docs/project/`: 프로젝트 전체 설명, 도메인 배경, 상위 요구사항 문서 위치
- `docs/tasks/`: 작업 단위 실문서 기본 위치
- `docs/tasks/<date>-<task-slug>/`: 하나의 task와 관련된 문서 묶음 위치
- `docs/adr/`: 중요한 운영/구조/워크플로우 결정 기록

## 문서 역할 분리

- `README.md`: 사람이 이 저장소를 이해하기 위한 문서
- `AGENTS.md`: AI가 가장 먼저 읽는 짧은 인덱스 문서
- `ai/standards/`: AI가 따라야 하는 기준 문서
- `ai/workflows/`: AI가 따라야 하는 작업 흐름 문서
- `ai/templates/`: AI가 문서 초안 작성에 쓰는 템플릿
- `ai/scenarios/`: AI가 작업 흐름 예시로 참고하는 시나리오 문서
- `docs/`: 사람이 읽고 관리하는 운영 문서와 프로젝트 산출물
- `docs/adr/`: 중요한 결정의 이유와 영향 기록

## 예제로 보는 사용 방식

예를 들어 새 프로젝트를 시작하거나 기능을 개발하거나 커밋을 준비할 때는 아래처럼 쓸 수 있다.

1. `README.md`와 `AGENTS.md`로 공통 구조와 운영 기준을 확인한다.
2. 사람이 보는 문서는 `docs/`에서 관리한다.
3. AI가 참조할 세부 규칙은 `ai/standards/`, `ai/workflows/`, `ai/templates/`, `ai/scenarios/`에서 관리한다.
4. 초기 문서가 없으면 `ai/templates/` 기반으로 아래 위치에 생성한다.
5. 프로젝트 전체 배경과 상위 개요 문서는 `docs/project/` 아래에 둔다.
6. task 관련 문서는 `docs/tasks/<date>-<task-slug>/` 아래에 함께 둔다.
7. 같은 task 안에서 `task.md`, `worklog.md`, `decision.md`를 함께 관리한다.
8. 장기 구조 결정은 `docs/adr/`에 남긴다.
9. git 커밋 전에는 staged 변경 기준 초안 작성과 작업 브랜치 여부 확인을 함께 진행한다.
10. 반복되는 문서 관례와 표현 규칙은 `ai/standards/conventions.md`에 반영한다.

실제 흐름 예시는 `ai/scenarios/` 아래 시나리오 문서를 참고한다.
