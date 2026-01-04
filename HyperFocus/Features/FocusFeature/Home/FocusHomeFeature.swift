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
        var inputText: String = ""
        var suggestions: [SuggestionEntity] = []
        var selectedDuration: DurationType? = .min25
        
        var path = StackState<Path.State>()
    }
    
    @CasePathable
    enum Action {
        case viewDidAppear
        case getSuggestionResponse(Result<[SuggestionEntity], Error>)
        case inputTextChanged(String)
        case addBtnTapped
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
            case let .getSuggestionResponse(.success(suggestions)):
                state.suggestions = suggestions
                
                return .none
            case let .getSuggestionResponse(.failure(error)):
                return .none
            case .inputTextChanged(let text):
                if(text.count > 60) {
                    // TODO: Toast - "목표는 최대 60자까지 입력 가능합니다."
                    return .none
                }
                state.inputText = text
                return .none
                
            case .addBtnTapped:
                let reason = ReasonType(rawValue: state.inputText)
                
                guard reason.isValid else {
                    // TODO: - Toast "목표는 최대 60자까지 입력 가능합니다."
                    return .none
                }
                
                guard let duration = state.selectedDuration else {
                    // TODO: - Toast "집중 시간을 선택해주세요."
                    return .none
                }
                
                // TODO: Detail로 Reason, Duration 전달하기
                state.path.append(.detail(FocusDetailFeature.State(
                    timer: TimerFeature.State(),
                    focusTime: duration
                )))
                return .none
            case let .reasonChanged(reason):
                state.inputText = reason.title
                
                if let duration = state.suggestions
                    .filter({$0.reason == reason})
                    .first?.duration {
                    print(duration)
                    state.selectedDuration = duration
                }
                
                return .none
            case let .durationChanged(duration):
                state.selectedDuration = duration
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
