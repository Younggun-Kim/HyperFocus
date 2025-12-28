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
        var focusGoal: FocusGoal
        var time: BasicTime?
    }
    
    enum Action {
        // 추후 액션 추가
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
