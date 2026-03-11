# ADR

이 디렉토리는 중요한 운영, 구조, 아키텍처, workflow 결정을 ADR(Architecture Decision Record) 형식으로 기록하는 공간이다.

## ADR이란

ADR은 중요한 결정을 짧고 일관된 형식으로 남기는 기록이다.
보통 아래 내용을 함께 담는다.

- 어떤 결정을 했는가
- 왜 그런 결정을 했는가
- 다른 대안은 무엇이었는가
- 이 결정으로 어떤 영향이 생기는가

## 언제 ADR을 남기는가

- 중요한 운영 정책이 정해졌을 때
- 저장소 구조나 문서 구조를 바꾸는 결정이 있을 때
- 작업 방식이나 workflow의 기준이 바뀔 때
- 여러 선택지 중 하나를 장기 기준으로 채택할 때

작은 수정이나 국소 bugfix는 기본적으로 ADR 대상이 아니다.

## 작성 원칙

- 결정 하나당 ADR 하나를 작성한다.
- README나 운영 문서에는 결과만 간단히 반영하고, 결정 이유는 ADR에 남긴다.
- 상태는 `proposed`, `accepted`, `deprecated`, `superseded` 중 하나로 관리한다.
- 새 결정을 내릴 때 기존 ADR을 대체하면 관련 ADR을 서로 참조한다.

## 파일 규칙

- 파일명은 `NNNN-short-title.md` 형식을 권장한다.
- 예시: `0001-use-skills-instead-of-prompts.md`

## 기본 템플릿

```md
# ADR NNNN: Title

- Status: accepted
- Date: YYYY-MM-DD

## Context

-

## Options Considered

1.
2.
3.

## Decision

-

## Consequences

- Positive:
- Negative:
- Follow-up:
```
