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
    struct State {
        var inputText: String = ""
        var focusGoal: FocusGoal?
        var recommendGoals: [String] = ExampleGoal.allCases.compactMap { goal in
            goal.title
        }
        var goalTime: BasicTime = .twentyFive
        var errorMessage: String?
        var path = StackState<Path.State>()
    }
    
    @CasePathable
    enum Action {
        case inputTextChanged(String)
        case addBtnTapped
        case exampleGoalTapped(String)
        case timeChanged(BasicTime)
        case path(StackActionOf<Path>)
    }
    
    @Reducer()
    enum Path {
        case detail(FocusDetailFeature)
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
                
            case .addBtnTapped:
                guard let goal = FocusGoal(state.inputText) else {
                    // TODO: Toast
                    state.errorMessage = "목표는 최대 60자까지 입력 가능합니다."
                    return .none
                }
                
                state.focusGoal = goal
                state.errorMessage = nil
                state.path.append(.detail(FocusDetailFeature.State(
                    timer: TimerFeature.State(),
                    focusGoal: goal,
                    focusTime: state.goalTime
                )))
                return .none
            case let .exampleGoalTapped(goal):
                state.inputText = goal
                return .none
            case let .timeChanged(time):
                state.goalTime = time
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

