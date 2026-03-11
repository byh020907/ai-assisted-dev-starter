# Docs

이 디렉토리는 사람이 읽고 관리하는 운영 문서와 예시를 모아두는 공간이다.

## 구성 원칙

- 바로 참고할 수 있는 설명과 예시를 우선 둔다.
- 중요한 구조적 결정은 `adr/`에 기록한다.
- 실제 작업 흐름 시나리오는 `examples/`에 둔다.
- 프로젝트 실문서는 `project/`와 `tasks/` 아래에 둔다.
- 하나의 task에 관련된 문서는 가능한 한 `docs/tasks/<date>-<task-slug>/` 아래에 함께 둔다.
- AI가 직접 복제하거나 생성에 활용하는 템플릿은 `ai/templates/`에 둔다.
- 프로젝트 고유 지식과 공통 운영 기준은 구분해서 관리한다.

## 추천 운영 방식

- 프로젝트 시작 흐름은 `examples/project-init-scenario.md`를 먼저 본다.
- 실제 feature 작업 흐름은 `examples/feature-dev-scenario.md`를 참고한다.
- git 커밋 협업 흐름은 `examples/git-commit-scenario.md`를 참고한다.
- 반복 문서 관례를 공통 conventions로 올리는 예시는 `examples/conventions-standardization-scenario.md`를 참고한다.
- 구조나 workflow 기준을 바꾸는 결정은 `adr/`에 남긴다.
