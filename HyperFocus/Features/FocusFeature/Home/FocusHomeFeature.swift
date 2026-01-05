//
//  FocusFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FocusHomeFeature {
    @Dependency(\.focusUseCase) var focusUseCase
    @Dependency(\.amplitudeService) var amplitudeService
    
    @ObservableState
    struct State {
        var isLoading: Bool = false
        var inputText: String = ""
        var suggestions: [SuggestionEntity] = []
        var selectedDuration: DurationType? = .min25
        var inputMethod: InputMethodType = .chip
        var toast: ToastFeature.State = ToastFeature.State()
        
        var path = StackState<Path.State>()
    }
    
    @CasePathable
    enum Action {
        case viewDidAppear
        case setLoading(Bool)
        case getSuggestionResponse(Result<[SuggestionEntity], Error>)
        case inputTextChanged(String)
        case addBtnTapped
        case startSessionResponse(Result<SessionEntity?, Error>)
        case reasonChanged(Int) // suggestions의 index
        case durationChanged(DurationType)
        case toast(ToastFeature.Action)
        case path(StackActionOf<Path>)
        case pathRemoved

        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case sessionCompleted
        }
    }
    
    @Reducer()
    enum Path {
        case detail(FocusDetailFeature)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.toast, action: \.toast) {
            ToastFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .viewDidAppear:
                return .run { send in
                    do {
                        let response = try await focusUseCase.getSuggestions()
                        await send(.getSuggestionResponse(.success(response)))
                    } catch {
                        await send(.getSuggestionResponse(.failure(error)))
                    }
                }
            case .setLoading(let isLoadaing):
                state.isLoading = isLoadaing
                return .none
            case let .getSuggestionResponse(.success(suggestions)):
                state.suggestions = suggestions
                
                return .none
            case .getSuggestionResponse(.failure(_)):
                state.suggestions = SuggestionEntity.defaultSuggesions
                return .none
            case .inputTextChanged(let text):
                if(text.count > 60) {
                    // TODO: - Toast "목표는 최대 60자까지 입력 가능합니다."
                    return .none
                }
                state.inputText = text
                state.inputMethod = .manual
                return .none
                
            case .addBtnTapped:
                let inputMethod = state.inputMethod
                let reason = ReasonType(rawValue: state.inputText)
                
                guard reason.isValid else {
                    // TODO: - Toast "목표는 최대 60자까지 입력 가능합니다."
                    return .none
                }
                
                guard let duration = state.selectedDuration else {
                    // TODO: - Toast "집중 시간을 선택해주세요."
                    return .none
                }
                
                return .run { send in
                    
                    await send(.setLoading(true))
                    
                    do {
                        let response = try await focusUseCase.startSession(
                            .init(
                                name: reason.title,
                                duration: duration,
                                inputMethod: inputMethod,
                            )
                        )
                        
                        await send(.startSessionResponse(.success(response)))
                    } catch {
                        await send(.startSessionResponse(.failure(error)))
                    }
                    
                    await send(.setLoading(false))
                }
            case let .startSessionResponse(.success(response)):
                // TODO: - 상세 화면으로 이동
                
                if let session = response {
                    state.path.append(.detail(FocusDetailFeature.State(
                        session: session
                    )))
                }
                
                return .none
            case let .startSessionResponse(.failure(error)):
                // TODO: - Toast 메시지
                
                if let apiError = error as? APIError {
                    print("startSessionResponse.failure: \(apiError)")
                    switch apiError {
                    case .httpError(let statusCode, let message):
                        print("HTTP Error: \(statusCode), message: \(message ?? "nil")")
                    case .decodingError(let message):
                        print("Decoding Error: \(message)")
                    case .networkError(let message):
                        print("Network Error: \(message)")
                    default:
                        print("Other Error: \(apiError)")
                    }
                } else {
                    print("startSessionResponse.failure: \(error.localizedDescription)")
                }
                
                return .none
            case let .reasonChanged(index):
                guard index >= 0 && index < state.suggestions.count else {
                    return .none
                }
                let suggestion = state.suggestions[index]
                state.inputText = suggestion.reason.title
                state.inputMethod = .chip
                state.selectedDuration = suggestion.duration
                
                return .none
            case let .durationChanged(duration):
                if state.selectedDuration != duration {
                    state.selectedDuration = duration
                    state.inputMethod = .manual
                }
                return .none
            case .toast:
                return .none
            case .pathRemoved:
                // path 제거 (sessionAbandoned 후 처리)
                state.path.removeAll()
                return .none
            case .delegate(.sessionCompleted):
                return .send(.pathRemoved)
            case .path(.element(id: _, action: .detail(.delegate(.sessionAbandoned(let reason))))):
                // FocusDetail에서 세션이 포기되었을 때 toast 전송 후 path 제거
                return .run { send in
                    await send(.toast(.show(reason.reason)))
                    // toast 전송 후 path 제거 (다음 액션에서 처리되도록)
                    try await Task.sleep(for: .milliseconds(100))
                    await send(.pathRemoved)
                }
            case .path(.element(id: _, action: .detail(.delegate(.sessionCompleted)))):
                // 세션 완료 시 delegate만 전달 (path 제거는 메인 reducer에서 처리)
                return .send(.delegate(.sessionCompleted))
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}


extension FocusHomeFeature.State {
    var reasons: [ReasonType] {
        return suggestions.compactMap{
            $0.reason
        }
    }
    
    var durations: [DurationType] {
        return suggestions.compactMap {
            $0.duration
        }
    }
}
