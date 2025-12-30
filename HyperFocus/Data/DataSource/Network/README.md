# Network Layer

Moya + Alamofire 기반의 확장 가능한 네트워크 레이어입니다.

## 구조

```
Network/
├── Core/
│   ├── APIError.swift          # 에러 타입 정의
│   ├── APIResponse.swift        # 공통 응답 모델
│   ├── BaseTarget.swift         # 기본 TargetType 프로토콜
│   ├── NetworkPlugin.swift      # 플러그인 (로깅, 인증 등)
│   └── APIService.swift         # API 서비스 (TCA Dependency)
└── Target/
    └── ExampleTarget.swift      # 사용 예제
```

## 사용 방법

### 1. Target 정의

```swift
enum MyAPI: BaseTarget {
    case getData(id: Int)
    
    var apiVersion: String? { "v1" }
    
    var path: String {
        switch self {
        case .getData(let id):
            return "/data/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
}
```

### 2. Response 모델 정의

```swift
struct MyData: Decodable {
    let id: Int
    let name: String
}
```

### 3. Feature에서 사용

```swift
@Reducer
struct MyFeature {
    @Dependency(\.apiService) var apiService
    
    enum Action {
        case loadData
        case dataLoaded(Result<MyData, APIError>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadData:
                return .run { send in
                    do {
                        let data = try await apiService.request(
                            MyAPI.getData(id: 1),
                            responseType: MyData.self
                        )
                        await send(.dataLoaded(.success(data)))
                    } catch let error as APIError {
                        await send(.dataLoaded(.failure(error)))
                    }
                }
            case .dataLoaded:
                return .none
            }
        }
    }
}
```

### 4. APIResponse 래핑 사용

서버가 공통 응답 형식을 사용하는 경우:

```swift
let response = try await apiService.request(
    MyAPI.getData(id: 1),
    responseType: MyData.self
)

if response.success, let data = response.data {
    // 성공 처리
} else {
    // 에러 처리
    print(response.message ?? "알 수 없는 오류")
}
```

## 확장

### 환경별 baseURL 설정

`BaseTarget.swift`의 `baseURL`을 수정하여 환경별 URL을 설정할 수 있습니다.

### 인증 토큰 추가

`BaseTarget.swift`의 `headers`에서 토큰을 추가하거나, `NetworkAuthPlugin`을 사용할 수 있습니다.

### 커스텀 플러그인 추가

`NetworkPlugin.swift`를 참고하여 새로운 플러그인을 만들고 `APIService`에 추가할 수 있습니다.

## 테스트

Preview나 테스트에서 Mock을 사용하려면:

```swift
let store = TestStore(initialState: MyFeature.State()) {
    MyFeature()
} withDependencies: {
    $0.apiService = APIService(provider: mockProvider)
}
```

