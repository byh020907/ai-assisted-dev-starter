# ADR 0005: Keep AGENTS.md as a Minimal Index Document

- Status: accepted
- Date: 2026-03-11

## Context

AI 운영 규칙을 정리하는 과정에서 `AGENTS.md`에 모든 세부 규칙을 길게 적을지,
아니면 최소 핵심만 남기고 나머지를 하위 문서로 분리할지 결정이 필요했다.

`AGENTS.md`가 너무 길어지면 읽기 시작점으로서의 역할이 약해지고,
규칙이 여러 곳에 중복되면서 유지보수 비용이 커질 수 있다.
반대로 너무 짧아져서 핵심 안전 규칙까지 빠지면 세션 상황에 따라 재현성이 떨어질 수 있다.

## Options Considered

1. 모든 운영 규칙을 `AGENTS.md`에 길게 담는다.
2. `AGENTS.md`에는 최소 핵심 원칙과 참조 경로만 두고, 세부 내용은 `ai/` 하위로 분리한다.
3. `AGENTS.md`를 거의 비워 두고 README/예시 문서만 참조하게 한다.

## Decision

`AGENTS.md`는 최소 핵심 원칙과 참조 경로만 담는 인덱스 문서로 유지한다.

즉:

- `AGENTS.md`: 항상 지켜야 하는 최소 규칙, 문서 생성 기본 규칙, git 최소 규칙, 읽는 순서
- `ai/standards/`: 작업 분류와 관례
- `ai/workflows/`: 세부 작업 흐름
- `ai/templates/`: 문서 초안 템플릿

다만 재현성에 직접 영향을 주는 규칙은 `AGENTS.md`에서 완전히 제거하지 않고 최소한으로 유지한다.

## Consequences

- Positive:
  - AI가 읽어야 할 시작점이 단순해진다.
  - 세부 규칙을 역할별 문서로 나눠 관리할 수 있다.
  - 중복 문서가 줄고 유지보수가 쉬워진다.
- Negative:
  - 하위 문서 참조가 깨지면 전체 구조 이해가 어려워질 수 있다.
  - 인덱스 문서와 하위 문서의 균형을 계속 점검해야 한다.
- Follow-up:
  - `AGENTS.md`에는 예시보다 규범 문서를 우선 배치한다.
  - 사람 관점 시나리오는 `docs/examples/`에 유지한다.
