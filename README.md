# HyperFocus

## 프로젝트 구조 제안

아래 구조는 기능·도메인·데이터 계층을 명확히 분리하여 유지보수성과 테스트 용이성을 높이기 위한 예시입니다.

```
App/
 ├─ Features/                # 화면(또는 플로우) 단위
 │   ├─ Home/
 │   └─ TODO/
 │
 ├─ Shared/
 │   ├─ DesignSystem/        # 공용 UI 컴포넌트, 테마, 토큰
 │   └─ ...                  # 공용 유틸/확장 등
 │
 ├─ Data/
 │   ├─ RepositoryImpl/      # Domain의 Repository 인터페이스 구현체
 │   ├─ DataSource/          # Remote/Local 데이터 소스 (API, DB, 캐시)
 │   └─ Dto/                 # 네트워크/DB 매핑용 DTO
 │
 ├─ Domain/
 │   ├─ UseCase/             # 유스케이스(비즈니스 로직)
 │   ├─ Entity/              # 순수 도메인 엔티티/모델
 │   └─ Repository/          # Repository 인터페이스
 │
 └─ (필요시) Core/Config/    # DI, 라우팅, 환경설정 등
```

### 레이어 역할 요약
- **Domain**: 비즈니스 규칙의 중심. 엔티티, 유스케이스, Repository 인터페이스만 포함하며 플랫폼/프레임워크 의존성을 최소화합니다.
- **Data**: 데이터 획득·저장 책임. DataSource에서 외부 세부사항 처리 → DTO ↔ Entity 매핑 → RepositoryImpl에서 Domain Repository 구현.
- **Features**: 화면/플로우 단위로 묶인 프레젠테이션 계층. Domain의 UseCase를 주입받아 사용합니다.
- **Shared**: 모든 Feature가 공용으로 사용하는 디자인 시스템, 스타일, 공용 컴포넌트, 유틸을 모읍니다.
- **(선택) Core/Config**: DI 컨테이너, 네트워크 설정, 라우팅 설정 등을 한 곳에 정리합니다.

### 추가 팁
- **의존성 방향**: `Features → Domain ←→ DataSource/RepositoryImpl` 형태를 유지하여 Domain이 외부 구현에 의존하지 않도록 합니다.
- **DTO vs Entity**: DTO는 외부 포맷(API/DB)에 맞추고, Entity는 도메인 규칙에 맞춘 순수 모델로 유지합니다.
- **테스트 위치**: Domain 유스케이스는 단위 테스트, Data 레이어는 통합 테스트, Features는 UI·스냅샷·상태 테스트로 분리합니다.
- **이름 규칙**: Repository 인터페이스는 `XRepository`, 구현은 `XRepositoryImpl`; UseCase는 동사 형태(`FetchTodosUseCase`, `AddTodoUseCase`)로 통일합니다.

## Tuist 모노레포 구성

Tuist로 계층별 모듈을 독립 프로젝트로 분리하고 `Workspace.swift`로 하나의 워크스페이스에 묶었습니다.

```
Workspace.swift
Projects/
 ├─ App/                    # 실행 앱 (HyperFocus)
 ├─ Core/                   # Domain/Data 공통 기반
 │   ├─ Models/             # Entity 모델
 │   ├─ Services/           # 데이터 접근/비즈니스 서비스
 │   ├─ Common/             # 공용 타입, 유틸
 │   └─ CoreKit/            # DI 환경 등 코어 인프라
 ├─ DesignSystem/           # 공용 UI 컴포넌트/스타일
 └─ Features/
     ├─ Scene/              # 화면 단위(Main, KakaoLogin 등)
     └─ Coordinator/        # 탭/네비게이션 조립
```

- **의존성 흐름**: `App → Coordinator → Scene → Core/DesignSystem` 순서로 일방향 의존을 유지합니다.
- **생성 방법**: 루트에서 `tuist generate`로 워크스페이스를 생성하면 각 모듈이 포함된 Xcode 프로젝트가 만들어집니다.
- **실행 진입점**: 워크스페이스의 루트 실행 대상은 `Projects/App`의 `HyperFocusApp`이며, 나머지 모듈은 모두 이 앱에서 조립되는 라이브러리 역할을 합니다.

## 빌드 가능한 기본 모듈
- **App**: `Common`, `DesignSystem` 모듈을 의존성으로 추가한 정적 라이브러리입니다. `HyperFocusRootView`에서 두 모듈이 제공하는 기능을 사용하여 실제로 빌드가 가능한 상태입니다.
- **Core/Common**: 공용 메시지를 제공하는 `CommonGreeting`을 포함합니다.
- **Shared/DesignSystem**: SwiftUI `ButtonStyle` 샘플(`DesignSystemButtonStyle`)과 리소스 자릿수를 포함합니다.

## Tuist 템플릿으로 새 모듈 추가하기
루트에서 아래 명령으로 기본 정적 라이브러리 템플릿을 활용할 수 있습니다.

```sh
tuist scaffold Module --name NewFeature
```

생성 경로는 `Projects/NewFeature`이며, `Project.swift`, `Sources/NewFeature.swift`, `Resources/.gitkeep`가 자동으로 생성됩니다. `--bundle-id-prefix` 옵션으로 번들 ID 프리픽스를 원하는 값으로 덮어쓸 수 있습니다.
