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
    struct State {
        var selectedTab: MainTab
        var focus: FocusHomeFeature.State
        var log: LogHomeFeature.State
        
        init() {
            self.selectedTab = .focus
            self.focus = FocusHomeFeature.State()
            self.log = LogHomeFeature.State()
        }
    }
    
    @CasePathable
    enum Action {
        case tabChanged(MainTab)
        case focus(FocusHomeFeature.Action)
        case log(LogHomeFeature.Action)
    }
    
    
    var body: some Reducer<State, Action> {
        Scope(state: \.focus, action: \.focus) {
            FocusHomeFeature()
        }
        Scope(state: \.log, action: \.log) {
            LogHomeFeature()
        }

        focusHomeReducer
        
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
    }
        
    var focusHomeReducer: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .focus(.delegate(.sessionCompleted)):
                // 세션 완료 시 Log 탭으로 전환
                state.selectedTab = .log
                return .none
            default:
                return .none
            }
        }
    }
}

