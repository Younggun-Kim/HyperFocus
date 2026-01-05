//
//  FocusCompletedFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FocusCompletedFeature {
    @Dependency(\.focusUseCase) var focusUseCase
    @Dependency(\.amplitudeService) var amplitudeService
    
    @ObservableState
    struct State: Equatable {
        var sessionId: String
        var selectedSatisfaction: SatisfactionType?
    }
    
    enum Action {
        case inner(InnerAction)
        case delegate(Delegate)
        
        enum InnerAction {
            case satisfactionTapped(SatisfactionType)
        }
        
        enum Delegate {
            case finishSession(SessionCompletionType)
            case breakAction
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .delegate(let action):
                return delegateAction(&state, action: action)
            case .inner(let action):
                return innerAction(&state, action: action)
            }
        }
    }
    
    
    func delegateAction(_ state: inout State, action: Action.Delegate) -> Effect<Action> {
        return .none
    }
    
    func innerAction(_ state: inout State, action: Action.InnerAction) -> Effect<Action> {
        switch action {
        case .satisfactionTapped(let satisfaction):
            state.selectedSatisfaction = satisfaction
            
            let sessionId = state.sessionId
            
            amplitudeService.track(
                .clickSessionFeedback(
                    .init(
                        satisfaction: satisfaction.rawValue,
                        sessionId: sessionId
                    )
                )
            )
            
            return .run { _ in
                do {
                    let _ = try await focusUseCase.feedbackSession(sessionId, satisfaction)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


