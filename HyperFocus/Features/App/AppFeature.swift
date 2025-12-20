//
//  AppFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/9/25.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    
    var body: some Reducer<State, Action> {
        // AppFeature의 일부 상태와 액션을 자식에게 위임
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        
        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}
