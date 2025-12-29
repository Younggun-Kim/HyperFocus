//
//  FocusDetailFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FocusDetailFeature {
    @ObservableState
    struct State: Equatable {
        var timer: TimerFeature.State
        var focusGoal: FocusGoal
        var focusTime: BasicTime
        var isSoundOn: Bool = true
    }
    
    enum Action {
        case timer(TimerFeature.Action)
        case playToggled
        case sounctToggled
        case checkTapped
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .timer:
                return .none
            case .playToggled:
                if (state.timer.isRunning) {
                    return .send(.timer(.pause))
                }
                return .send(.timer(.start))
            case .sounctToggled:
                state.isSoundOn = !state.isSoundOn
                return .none
            case .checkTapped:
                
                state.timer.
                
                return .none
            }
        }
    }
}
