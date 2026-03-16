# Starter Guide

이 문서는 starter core 루트에 있는 공통 기준, 흐름, 템플릿, 시나리오 구조를 설명한다.

## 구성

- `standards/`: 작업 분류, 문서 관례 같은 공통 기준
- `workflows/`: 작업 유형별 진행 방식
- `skills/`: 반복적으로 재사용할 작업 단위와 사용 가이드
- `templates/`: 소비 프로젝트가 활용할 문서 템플릿
- `project-template/`: 소비 프로젝트 로컬 구조 템플릿
- `scripts/`: 소비 프로젝트 초기화에 사용하는 재현 가능한 스크립트
- `scenarios/`: AI가 작업 흐름 예시로 참고하는 시나리오 문서

## 읽는 순서

1. starter core의 `AGENTS.md`
2. `STARTER.md`
3. 필요한 세부 문서

## 대표 문서

- 작업 분류 기준: `standards/task-classification.md`
- 문서 관례 기준: `standards/conventions.md`
- 기본 작업 흐름: `workflows/default-workflow.md`
- feature 작업 흐름: `workflows/feature-workflow.md`
- git 커밋 흐름: `workflows/git-commit-workflow.md`
- 작업 시나리오: `scenarios/`

## 원칙

- starter core의 AI 공통 규칙은 루트 디렉토리들에 둔다.
- 프로젝트 고유 설명과 산출물은 소비 프로젝트의 전용 리소스 루트 예를 들어 `.ai-assisted-dev-starter/`에서 관리한다.
- 같은 내용을 사람용 문서와 AI용 문서에 중복 작성하지 않는다.
- 구조와 사용 기준은 `README.md`와 이 문서에 직접 반영한다.
- starter core는 기본적으로 읽기 전용으로 사용한다.
- 프로젝트 규칙 추가 요청은 기본적으로 `.ai-assisted-dev-starter/project/` 문서에 기록한다.
- starter core 수정은 사용자가 공통 규칙 승격이나 starter 자체 개선을 명시적으로 요청한 경우에만 수행한다.

## 프로젝트별 확장 규칙

- 여러 프로젝트에 공통으로 적용할 수 있는 기준은 `standards/`와 `workflows/`에 둔다.
- 특정 팀의 협업 스타일이나 선호는 소비 프로젝트 문서로 분리한다.
- 예를 들어 응답 언어, 구현 전 제안 방식, 코드 주석 스타일 같은 항목은 소비 프로젝트 루트의 `.ai-assisted-dev-starter/project/ai-collaboration.md` 같은 문서에 두는 것을 우선한다.
- 프로젝트 실문서를 새로 만들 때는 `templates/`와 `project-template/`을 참고하되, 결과물은 starter core 안이 아니라 소비 프로젝트 쪽에 생성한다.
- 프로젝트에서만 유효한 규칙을 starter core에 직접 추가하지 않는다.
