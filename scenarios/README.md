# AI Scenarios

이 디렉토리는 사용자 요청이 각 작업 유형에서 어떤 흐름으로 이어지는지
사람이 이해하기 쉽게 보여주는 시나리오 예시를 모아두는 공간이다.

여기 문서의 목적은 AI의 세부 실행 절차를 정의하는 것이 아니라,
사용자 요청을 기준으로 실제 협업이 어떻게 흘러가는지 예시로 설명하는 데 있다.

세부 작업 기준과 실행 규칙은 `workflows/` 문서에서 관리하고,
이 디렉토리는 그 규칙이 어떤 요청 맥락에서 쓰이는지 보여주는 보조 문서로 유지한다.

포함된 시나리오:

- `project-init-scenario.md`: 새 프로젝트를 시작할 때 기본 문서 구조가 어떻게 잡히는지 보여준다.
- `feature-dev-scenario.md`: 진행 중인 프로젝트에서 feature 하나를 요청했을 때 작업 문서가 어떻게 만들어지고 이어지는지 보여준다.
- `git-commit-scenario.md`: 사용자가 staged 변경을 기준으로 커밋 초안을 받고, 브랜치 확인 후 커밋까지 이어가는 흐름을 보여준다.
- `conventions-standardization-scenario.md`: 반복된 문서 형식과 작성 관례가 공통 conventions 기준으로 승격되는 상황을 보여준다.
- `project-specific-ai-rules-scenario.md`: 프로젝트별 AI 협업 규칙을 공통 규칙과 분리해 두는 이유와 적용 방식을 보여준다.

이 디렉토리의 문서는 `workflows/`와 짝을 이루는 예시 자산으로 관리한다.
