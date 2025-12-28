//
//  SplashFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SplashFeature {
    @ObservableState
    struct State: Equatable {
        var isTimerCompleted = false
    }
    
    enum Action {
        case onAppear
        case timerCompleted
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case splashCompleted
        }
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 3초 후 타이머 완료
                return .run { send in
                    try? await clock.sleep(for: .seconds(3))
                    await send(.timerCompleted)
                }
                
            case .timerCompleted:
                state.isTimerCompleted = true
                return .send(.delegate(.splashCompleted))
                
            case .delegate:
                return .none
            }
        }
    }
}
