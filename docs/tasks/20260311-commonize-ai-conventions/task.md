# Task

## 작업명

- AI 공통 관례에 대화 축소, 기술 스택 우선 확인, Mermaid 우선 원칙 반영

## 배경

- 사람용 Cursor 활용 초안에서 여러 프로젝트에 공통으로 재사용 가능한 규칙 후보가 도출됐다.
- 현재 저장소에는 해당 내용을 공통 AI 관례로 명시한 문서가 없다.

## 목표

- 범용성이 높은 규칙만 `ai/standards/conventions.md`에 반영한다.
- 이번 변경의 의도와 범위를 task 문서로 남긴다.

## 완료 조건

- `ai/standards/conventions.md`에 공통화 가능한 규칙이 추가된다.
- 작업 의도, 영향 범위, 검증 결과가 `docs/tasks/20260311-commonize-ai-conventions/` 아래에 기록된다.

## 작업 범위

- 포함:
- `ai/standards/conventions.md` 업데이트
- task/worklog/decision 문서 생성
- 제외:
- Cursor 전용 소개 문서 추가
- Context7 MCP 같은 도구 종속 규칙의 공통화

## 참고 문서

- `README.md`
- `ai/README.md`
- `docs/adr/0001-use-skills-instead-of-prompts.md`
- `docs/adr/0003-separate-human-and-ai-docs.md`

## 메모

- 현재 워크트리에 `ai/scenarios/project-init-scenario.md` 사용자 변경이 있어 건드리지 않는다.
