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
        case reasonChanged(ReasonType)
        case durationChanged(DurationType)
        case path(StackActionOf<Path>)
    }
    
    @Reducer()
    enum Path {
        case detail(FocusDetailFeature)
    }
    
    var body: some Reducer<State, Action> {
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
            case let .getSuggestionResponse(.failure(error)):
                // TODO: - Toast
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
            case let .reasonChanged(reason):
                state.inputText = reason.title
                state.inputMethod = .chip
                
                if let duration = state.suggestions
                    .filter({$0.reason == reason})
                    .first?.duration {
                    print(duration)
                    state.selectedDuration = duration
                }
                
                return .none
            case let .durationChanged(duration):
                if state.selectedDuration != duration {
                    state.selectedDuration = duration
                    state.inputMethod = .manual
                }
                return .none
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
