//
//  LogFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LogHomeFeature {
    @ObservableState
    struct State {
        var items: [String] = []
        var path = StackState<Path.State>()
    }
    
    @CasePathable
    enum Action {
        case settingTapped
        case path(StackActionOf<Path>)
    }
    
    @Reducer()
    enum Path {
        case setting(SettingFeature)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .settingTapped:
                // state.path.append(.setting(SettingFeature.State()))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

