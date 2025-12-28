//
//  FocusFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FocusHomeFeature {
    @ObservableState
    struct State: Equatable {
        var inputText: String = ""
        var focusGoal: FocusGoal?
        var recommendGoals: [String] = ExampleGoal.allCases.compactMap { goal in
            goal.title
        }
        var errorMessage: String?
        var time: BasicTime?
    }
    
    enum Action {
        case inputTextChanged(String)
        case addBTapped
        case exampleGoalTapped(String)
        case timeChanged(BasicTime)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .inputTextChanged(let text):
                if(text.count > FocusGoal.maxLength) {
                    // TODO: Toast
                    state.errorMessage = "목표는 최대 60자까지 입력 가능합니다."
                    return .none
                }
                state.inputText = text
                state.errorMessage = nil
                return .none
                
            case .addBTapped:
                guard let goal = FocusGoal(state.inputText) else {
                    // TODO: Toast
                    state.errorMessage = "목표는 최대 60자까지 입력 가능합니다."
                    return .none
                }
                state.focusGoal = goal
                state.errorMessage = nil
                return .none
            case let .exampleGoalTapped(goal):
                state.inputText = goal
                return .none
            case let .timeChanged(time):
                state.time = time
                return .none
            }
        }
    }
}

