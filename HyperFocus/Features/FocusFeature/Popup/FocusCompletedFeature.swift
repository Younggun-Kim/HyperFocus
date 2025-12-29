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
    @ObservableState
    struct State: Equatable {
        // 필요한 상태가 있다면 여기에 추가
    }
    
    enum Action {
        case finishSession
        case breakAction
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .finishSession:
                // 세션 완료 로직
                return .none
            case .breakAction:
                // 5분 휴식 로직
                return .none
            }
        }
    }
}
