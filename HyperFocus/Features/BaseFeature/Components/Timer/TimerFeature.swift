//
//  TimerFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/26/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TimerFeature {
    @ObservableState
    struct State: Equatable {
        var totalSeconds: Int = 25 * 60 // 25분 (기본값)
        var remainingSeconds: Int = 25 * 60
        var isRunning: Bool = false
        var progress: Double = 1.0
        
        var timeString: String {
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        var isThreeMinutesElapsed: Bool {
            return (totalSeconds - remainingSeconds) > 3 * 60
        }
    }
    
    enum Action {
        case start
        case pause
        case reset
        case timerTick
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case timerCompleted
        }
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .start:
                state.isRunning = true
                return .run { send in
                    for await _ in clock.timer(interval: .milliseconds(7)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: TimerID.timer, cancelInFlight: true)
                
            case .pause:
                state.isRunning = false
                return .cancel(id: TimerID.timer)
                
            case .reset:
                state.isRunning = false
                state.remainingSeconds = state.totalSeconds
                state.progress = 1.0
                return .cancel(id: TimerID.timer)
                
            case .timerTick:
                guard state.isRunning else { return .none }
                
                if state.remainingSeconds > 0 {
                    state.remainingSeconds -= 1
                    state.progress = Double(state.remainingSeconds) / Double(state.totalSeconds)
                } else {
                    state.isRunning = false
                    // 타이머 종료 처리
                    return .send(.delegate(.timerCompleted))
                }
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}

private enum TimerID: Hashable, Sendable {
    case timer
}
