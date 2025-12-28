//
//  LogFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LogFeature {
    @ObservableState
    struct State: Equatable {
        // 추후 Log 상태 추가
    }
    
    enum Action {
        // 추후 Log 액션 추가
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}

