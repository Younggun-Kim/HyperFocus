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
    
    @ObservableState
    struct State: Equatable {
        // 필요한 상태가 있다면 여기에 추가
    }
    
    enum Action {
        case inner(InnerAction)
        case delegate(Delegate)
        
        enum InnerAction {
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
        default:
            return .none
        }
    }
}


