//
//  FocusFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FocusFeature {
    @ObservableState
    struct State: Equatable {
        // 추후 Focus 상태 추가
    }
    
    enum Action {
        // 추후 Focus 액션 추가
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}

