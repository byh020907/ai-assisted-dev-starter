# Worklog

## 2026-03-12

### 오늘 작업

- `AGENTS.md`, `ai/README.md`, `README.md`, `docs/` 하위 README를 비교 검토했다.
- 새 프로젝트 시작 시 필요한 quick start 가이드를 메인 `README.md`에 추가했다.
- 이번 검토 결과와 변경 이유를 task 문서로 남겼다.
- staged 변경 기준으로 이력 제목과 이력 내용 초안을 정리했다.

### 확인한 내용

- AI 작업의 최소 진입 정보는 `AGENTS.md`에 있고, 세부 기준은 `ai/README.md`와 `ai/standards/`, `ai/workflows/`가 이어받는다.
- 메인 `README.md`에는 구조 설명은 충분하지만, 스타터 복사 직후 정리 규칙은 명시적으로 적혀 있지 않았다.
- `docs/`는 사람용 실문서 공간이라 예시 문서를 비우고 각 폴더의 `README.md`만 남겨도 운영 원칙과 충돌하지 않는다.
- Git commit workflow 기준으로 이력은 staged diff 중심의 제목과 bullet 요약으로 남기는 것이 맞다.

### 결정 / 보류

- 결정:
- 메인 `README.md`에 quick start 절차를 추가해 스타터 사용 진입 비용을 낮춘다.
- `AGENTS.md`는 최소 인덱스 역할을 유지하고, 세부 설명은 `README.md`에만 보강한다.
- 이번 변경의 이력 초안은 문서 개선 성격의 `docs` 카테고리로 정리한다.
- 보류:
- 없음

### 이력 초안

- 제목: `[docs] README quick start 가이드 및 검토 이력 추가`
- 내용:
- 메인 `README.md`에 스타터 초기화용 quick start 절차를 추가함
- `AGENTS.md`, `ai/README.md`, `docs/` 구조를 비교 검토한 내용을 task 문서로 기록함
- 새 프로젝트 시작 시 `ai/`는 유지하고 `docs/` 예시 문서는 비우는 운영 기준을 명확히 함
- 커밋 제목 초안: `[#이력번호] [docs] README quick start 가이드 및 검토 이력 추가`

### 다음 액션

1. 새 프로젝트에서 이 저장소를 복사한 뒤 quick start 절차대로 초기 정리를 수행한다.
2. 사용자가 이력 번호를 정하면 같은 제목으로 커밋 메시지를 확정할 수 있다.
3. 프로젝트별 설명이 생기면 `docs/project/brief.md`와 관련 문서를 채운다.
