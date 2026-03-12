# Task

## 작업명

- task 문서 3종 역할 분리 및 decision 템플릿 한글화

## 배경

- 누적된 task 문서를 검토한 결과 `task.md`, `worklog.md`, `decision.md` 사이의 역할 경계가 일부 겹치고 있었다.
- 특히 `task.md`의 메모, `worklog.md`의 결정 / 보류, `decision.md`의 후속 작업은 서로 다른 문서가 가져야 할 내용을 흡수하기 쉬웠다.
- `decision` 템플릿은 소제목 일부가 영어로 남아 있어 나머지 문서와 톤이 통일되지 않았다.

## 목표

- `task.md`, `worklog.md`, `decision.md`의 역할을 사용자 의도에 맞게 템플릿 수준에서 분리한다.
- `decision` 템플릿의 소제목을 한국어로 통일한다.

## 범위

- 포함:
- `ai/templates/TASK.md` 정리
- `ai/templates/WORKLOG.md` 정리
- `ai/templates/DECISION_LOG.md` 정리
- 이번 변경의 task 문서 기록
- 제외:
- 기존 task 실문서 일괄 마이그레이션
- 새로운 문서 종류 추가

## 완료 조건

- 템플릿만 읽어도 세 문서의 역할 차이가 드러난다.
- `decision` 템플릿의 소제목이 한국어로 통일된다.
- 이번 변경의 의도와 근거가 task 문서 묶음에 기록된다.

## 참고 문서

- `ai/templates/TASK.md`
- `ai/templates/WORKLOG.md`
- `ai/templates/DECISION_LOG.md`
- `docs/tasks/20260311-history-format/`
