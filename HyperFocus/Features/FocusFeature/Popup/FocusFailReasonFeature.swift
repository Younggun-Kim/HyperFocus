//
//  FocusFailReasonFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FocusFailReasonFeature {
    @Dependency(\.focusUseCase) var focusUseCase
    @ObservableState
    struct State: Equatable {
        // 필요한 상태가 있다면 여기에 추가
    }
    
    enum Action {
        case btnTapped(SessionFailReasonType)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .btnTapped:
                
                return
        }
    }
}
