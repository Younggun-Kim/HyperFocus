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
        var focus: FocusHomeFeature.State
        var log: LogFeature.State
        @Presents var focusDetail: FocusDetailFeature.State?
        
        init() {
            self.focus = FocusHomeFeature.State()
            self.log = LogFeature.State()
        }
    }
    
    enum Action {
        case tabChanged(MainTab)
        case focus(FocusHomeFeature.Action)
        case log(LogFeature.Action)
        case focusDetail(PresentationAction<FocusDetailFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .tabChanged(tab):
                state.selectedTab = tab
                return .none
            case .focus(.delegate(.navigateToDetail(let goal, let time))):
                state.focusDetail = FocusDetailFeature.State(focusGoal: goal, time: time)
                return .none
            case .focus:
                return .none
            case .log:
                return .none
            case .focusDetail:
                return .none
            }
        }
        Scope(state: \.focus, action: \.focus) {
            FocusHomeFeature()
        }
        Scope(state: \.log, action: \.log) {
            LogFeature()
        }
        .ifLet(\.$focusDetail, action: \.focusDetail) {
            FocusDetailFeature()
        }
    }
}

