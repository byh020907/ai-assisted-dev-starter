# AI Docs

이 디렉토리는 사람이 읽는 운영 문서와 분리해서,
AI 도구가 작업 중 참조할 기준, 흐름, skill, 템플릿을 모아두는 공간이다.

## 구성

- `standards/`: 작업 분류, 문서 관례 같은 공통 기준
- `workflows/`: 작업 유형별 진행 방식
- `skills/`: 반복적으로 재사용할 작업 단위와 사용 가이드
- `templates/`: AI가 활용할 문서/응답 템플릿

## 읽는 순서

1. 루트 `AGENTS.md`
2. `ai/README.md`
3. 필요한 세부 문서

## 대표 문서

- 작업 분류 기준: `standards/task-classification.md`
- 문서 관례 기준: `standards/conventions.md`
- 기본 작업 흐름: `workflows/default-workflow.md`
- feature 작업 흐름: `workflows/feature-workflow.md`
- git 커밋 흐름: `workflows/git-commit-workflow.md`

## 원칙

- 사람 중심 설명은 `docs/`에 둔다.
- AI의 판단과 실행에 직접 영향을 주는 문서는 `ai/`에 둔다.
- 같은 내용을 사람용 문서와 AI용 문서에 중복 작성하지 않는다.
- 구조 결정 이유는 README보다 ADR에 기록한다.

## 프로젝트별 확장 규칙

- 여러 프로젝트에 공통으로 적용할 수 있는 기준은 `ai/standards/`와 `ai/workflows/`에 둔다.
- 특정 팀의 협업 스타일이나 선호는 프로젝트 문서로 분리한다.
- 예를 들어 응답 언어, 구현 전 제안 방식, 코드 주석 스타일 같은 항목은 `docs/project/ai-collaboration.md` 같은 프로젝트별 문서에 두는 것을 우선한다.