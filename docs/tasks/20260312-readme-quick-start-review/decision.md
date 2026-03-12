# Decision Log

## Decision

- 제목: 스타터 초기화 절차를 메인 README에 명시한다
- 날짜: 2026-03-12
- 상태: accepted

## Context

- `AGENTS.md`는 의도적으로 최소 인덱스로 유지되고 있어 AI 작업에는 충분하지만, 사람이 스타터를 새 프로젝트에 적용하는 첫 단계는 메인 `README.md`에서 더 직접 안내할 필요가 있었다.
- 특히 `docs/` 예시 문서를 비우고 시작하는 규칙은 구조 설명만으로는 놓치기 쉬웠다.

## Options Considered

1. `AGENTS.md`에 quick start까지 추가한다.
2. 메인 `README.md`에 quick start를 추가하고 `AGENTS.md`는 최소 인덱스로 유지한다.
3. 별도 시작 가이드를 새 파일로 만든다.

## Decision

- 메인 `README.md`에 quick start 섹션을 추가하고, `AGENTS.md`는 최소 핵심 원칙과 참조 경로만 유지한다.

## Consequences

- 장점:
- 스타터를 복사해 쓰는 사람이 바로 정리 순서를 이해할 수 있다.
- AI용 최소 진입 문서와 사람용 시작 가이드의 역할 분리가 유지된다.
- 단점:
- 메인 `README.md`가 구조 소개 외에 운영 절차까지 일부 포함하게 된다.
- 후속 작업:
- 필요하면 `docs/project/brief.md` 작성 시점을 quick start에 더 구체화할 수 있다.
