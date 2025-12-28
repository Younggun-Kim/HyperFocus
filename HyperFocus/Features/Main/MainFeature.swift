//
//  MainFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

enum MainTab: Hashable {
    case focus
    case log
}

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        var selectedTab: MainTab = .focus
        var focus: FocusFeature.State
        var log: LogFeature.State
        
        init() {
            self.focus = FocusFeature.State()
            self.log = LogFeature.State()
        }
    }
    
    enum Action {
        case tabChanged(MainTab)
        case focus(FocusFeature.Action)
        case log(LogFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .tabChanged(tab):
                state.selectedTab = tab
                return .none
            case .focus:
                return .none
            case .log:
                return .none
            }
        }
        Scope(state: \.focus, action: \.focus) {
            FocusFeature()
        }
        Scope(state: \.log, action: \.log) {
            LogFeature()
        }
    }
}

