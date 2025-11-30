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
