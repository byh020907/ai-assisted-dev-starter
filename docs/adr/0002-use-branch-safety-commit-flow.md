# adr 0002: Use Branch-Safety Commit Support Instead of Classic Gitflow

- Status: accepted
- Date: 2026-03-11

## Context

이 저장소에 Git 관련 운영 흐름을 추가하면서,
전통적인 Gitflow 모델을 따를지 아니면 더 단순한 작업 브랜치 중심 흐름을 따를지 결정이 필요했다.

사용자가 원하는 시나리오는 아래에 가깝다.

- 사용자가 직접 stage 범위를 정한다.
- AI는 staged diff 기반으로 커밋 초안을 만든다.
- 사용자가 최종 이력 번호와 메시지를 정한다.
- 커밋 전에는 현재 브랜치가 작업 브랜치인지 확인한다.
- 작업 브랜치가 아니면 브랜치를 만들어 그 위에서 커밋한다.

이는 `main`과 `develop`, `release`, `hotfix` 같은 여러 장기 브랜치를 운영하는 전통적인 Gitflow보다,
작업 브랜치 기반의 단순한 브랜치 안전성 흐름에 더 가깝다.

## Options Considered

1. 전통적인 Gitflow를 기본으로 채택한다.
2. 작업 브랜치 기반의 단순한 commit support workflow를 채택한다.
3. 두 방식을 모두 공식 기본값으로 둔다.

## Decision

이 저장소의 기본 Git 관련 흐름은 전통적인 Gitflow가 아니라,
작업 브랜치 기반의 branch-safety commit support workflow로 정리한다.

즉, 사용자는 stage 범위와 최종 메시지를 책임지고,
AI 에이전트는 staged diff 기반 초안 작성과 브랜치 안전성 확인을 지원한다.

## Consequences

- Positive:
  - 더 단순하고 실제 대화형 AI 협업 흐름에 잘 맞는다.
  - 기본 브랜치 직접 커밋 위험을 줄일 수 있다.
  - 전통적인 Gitflow의 복잡한 브랜치 모델을 강제하지 않는다.
- Negative:
  - 조직마다 쓰는 정교한 Gitflow 규칙은 별도로 추가해야 한다.
  - 브랜치 이름 규칙은 프로젝트별로 더 구체화가 필요할 수 있다.
- Follow-up:
  - `ai/workflows/git-commit-workflow.md`에 구체 흐름을 둔다.
  - 사람용 예시는 `docs/examples/git-commit-scenario.md`에 둔다.
