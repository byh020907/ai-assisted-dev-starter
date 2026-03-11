# ADR 0004: Organize Task Documents as Per-Task Bundles

- Status: accepted
- Date: 2026-03-11

## Context

작업 문서를 정리하면서 `task`, `worklog`, `decision`을 문서 종류별 디렉토리로 분리할지,
아니면 하나의 작업 디렉토리 안에 함께 둘지 선택이 필요했다.

문서 종류별로 분리하면 분류는 단순하지만,
하나의 작업 맥락이 여러 폴더에 흩어져 추적이 어려워질 수 있다.
반면 작업 디렉토리 단위로 묶으면 특정 task의 범위, 진행, 결정 내용을 한 번에 볼 수 있다.

## Options Considered

1. `docs/tasks/`, `docs/worklog/`, `docs/decisions/`처럼 종류별 디렉토리로 분리한다.
2. `docs/tasks/<date>-<task-slug>/` 아래에 `task.md`, `worklog.md`, `decision.md`를 함께 둔다.
3. 모든 작업 문서를 하나의 긴 문서로 관리한다.

## Decision

하나의 작업과 관련된 문서는 `docs/tasks/<date>-<task-slug>/` 아래에 함께 둔다.

기본 구조는 아래를 사용한다.

- `docs/tasks/<date>-<task-slug>/task.md`
- `docs/tasks/<date>-<task-slug>/worklog.md`
- `docs/tasks/<date>-<task-slug>/decision.md`

프로젝트 전체의 장기 결정은 이 구조와 별도로 `docs/adr/`에 둔다.

## Consequences

- Positive:
  - 하나의 작업 맥락을 한 디렉토리에서 추적할 수 있다.
  - 작업 정의, 기록, 결정을 함께 보기 쉽다.
  - 시간이 지나도 특정 작업의 흐름을 복기하기 편하다.
- Negative:
  - task 수가 많아지면 디렉토리 개수가 빠르게 늘 수 있다.
  - 파일명 규칙과 날짜 규칙을 일관되게 유지해야 한다.
- Follow-up:
  - task 디렉토리 이름은 날짜 기반 `YYYYMMDD-slug` 형식을 사용한다.
  - 초기 문서가 없으면 `ai/templates/` 기반으로 생성한다.
