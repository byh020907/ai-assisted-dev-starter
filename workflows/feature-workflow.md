# Feature Workflow

## 원칙

- `feature` 작업은 기본적으로 spec-first 방식으로 진행한다.
- 구현 전에 목표, 범위, 완료 조건을 먼저 정리한다.
- 범위가 큰 구현은 합의 전까지 확장하지 않는다.

## 기본 문서 흐름

- 현재 작업 초안: `templates/TASK.md`
- 진행 기록 초안: `templates/WORKLOG.md`
- 결정 기록 초안: `templates/DECISION_LOG.md`
- 프로젝트 목표가 실제로 바뀌는 경우에만 `templates/PROJECT_BRIEF.md`를 참고하거나 갱신한다.

## 기본 생성 위치

- 프로젝트 개요: `docs/project/brief.md`
- 작업 문서 묶음: `docs/tasks/<date>-<task-slug>/`
- 작업 정의 문서: `docs/tasks/<date>-<task-slug>/task.md`
- 작업 기록 문서: `docs/tasks/<date>-<task-slug>/worklog.md`
- 작업 단위 결정 문서: `docs/tasks/<date>-<task-slug>/decision.md`

## 생성 원칙

- 필요한 문서가 기본 위치에 없으면 템플릿을 기반으로 먼저 생성한다.
- 같은 task의 문서는 가능한 한 하나의 task 디렉토리에 함께 둔다.
- 이미 문서가 있으면 새로 만들기보다 기존 문서를 업데이트한다.
- task 디렉토리 이름은 `20260311-archive-note` 같은 `YYYYMMDD-slug` 형식을 사용한다.
