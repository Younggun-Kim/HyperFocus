//
//  FocusRestFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import Foundation
import ComposableArchitecture
import SwiftUI


@Reducer
struct FocusRestFeature: Reducer {
    @Dependency(\.amplitudeService) var amplitudeService
    
    @ObservableState
    struct State: Equatable {
        var timer: TimerFeature.State = TimerFeature.State()
        var toast: ToastFeature.State = ToastFeature.State()
        
        var session: SessionEntity
        var playStatus: SessionStatusType?
        
        init(session: SessionEntity) {
            self.session = session
            self.timer = TimerFeature.State(
                playbackRate: Environment.isDevelopment ? 10 : 1,
                totalSeconds: 5 * 60,
                remainingSeconds: 5 * 60,
                isRunning: false,
            )
        }
        
        var tabBarVisibility: Visibility {
            return playStatus?.isPlaying == true ? .hidden : .automatic
        }
    }
    
    @CasePathable
    enum Action {
        case timer(TimerFeature.Action)
        case toast(ToastFeature.Action)
        case inner(InnerAction)
        case delegate(Delegate)
        
        enum InnerAction: Equatable {
            case onAppear
            case checkTapped
            case start
            case stop
            case skip
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
        case .checkTapped:
            return .none
        case .start:
            return .send(.timer(.start))
        case .stop:
            return .send(.timer(.pause))
        case .skip:
            return .none
        }
    }
}
