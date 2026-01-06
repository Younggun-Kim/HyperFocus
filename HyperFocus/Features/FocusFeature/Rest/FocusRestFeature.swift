//
//  FocusRestFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import Foundation
import ComposableArchitecture


@Reducer
struct FocusRestFeature: Reducer {
    @Dependency(\.amplitudeService) var amplitudeService
    
    @ObservableState
    struct State: Equatable {
        var timer: TimerFeature.State = TimerFeature.State()
        var toast: ToastFeature.State = ToastFeature.State()
    }
    
    @CasePathable
    enum Action {
        case timer(TimerFeature.Action)
        case toast(ToastFeature.Action)
        case inner(InnerAction)
        case delegate(Delegate)
        
        enum InnerAction: Equatable {
            case onAppear
        }
        enum Delegate: Equatable {}
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        Scope(state: \.toast, action: \.toast) {
            ToastFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .toast(let action):
                return toastAction(&state, action: action)
            case .timer(let action):
                return timerAction(&state, action: action)
            case .inner(let inner):
                return innerAction(&state, action: inner)
            case .delegate(let delegate):
                return delegateAction(&state, action: delegate)
            }
        }
    }
    
    
    func toastAction(_ state: inout State, action: ToastFeature.Action) -> Effect<Action> {
        return .none
    }
    
    func timerAction(_ state: inout State, action: TimerFeature.Action) -> Effect<Action> {
        switch action {
        case .timerTick:
            return .none
        case .delegate(.timerCompleted):
            return .none
        default:
            return .none
        }
    }
    
    func delegateAction(_ state: inout State, action: Action.Delegate) -> Effect<Action> {
        
    }
    
    func innerAction(_ state: inout State, action: Action.InnerAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        }
    }
}
