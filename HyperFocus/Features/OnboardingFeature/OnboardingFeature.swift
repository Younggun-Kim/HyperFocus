//
//  OnboardingFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import ComposableArchitecture
import Foundation

enum OnboardingType: Hashable {
    case todo
    case timer
    case finally
}
extension OnboardingType {
    static var last: Self {
        return .finally
    }
}

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var page: OnboardingType = .todo
        var timer: TimerFeature.State?
    }
    
    enum Action {
        case pageChanged(OnboardingType)
        case skipBtnTapped
        case todoCompleted
        case initializeTimer
        case timer(TimerFeature.Action)
        case startTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case onboardingCompleted
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .pageChanged(newPage):
                state.page = newPage
                // Timer 페이지로 이동 시 Timer 초기화
                if newPage == .timer && state.timer == nil {
                    state.timer = TimerFeature.State()
                }
                return .none
            case .skipBtnTapped:
                state.page = OnboardingType.last
                return .none
            case .todoCompleted:
                state.page = .timer
                return .none
            case .initializeTimer:
                if state.timer == nil {
                    state.timer = TimerFeature.State()
                }
                return .none
            case .timer(.delegate(.timerCompleted)):
                state.page = .finally
                return .none
            case .timer:
                return .none
            case .startTapped:
                return .none
            case .delegate:
                return .none
            }
        }
        .ifLet(\.timer, action: \.timer) {
            TimerFeature()
        }
    }
}
