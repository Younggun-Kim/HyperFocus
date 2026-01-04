//
//  FocusDetailFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct FocusDetailFeature {
    @ObservableState
    struct State: Equatable {
        var session: SessionEntity
        var timer: TimerFeature.State = TimerFeature.State()
        var playStatus: SessionStatusType?
        var isSoundOn: Bool = true
        var showWrappingUpAlert: Bool = false
        var showEarlyWrappingUpAlert: Bool = false
        var showCompletedBottomSheet: Bool = false
        var completed: FocusCompletedFeature.State = FocusCompletedFeature.State()
        
        init(session: SessionEntity) {
            self.session = session
            self.timer = TimerFeature.State(
                playbackRate: 1,
                totalSeconds: session.targetDurationSeconds,
                remainingSeconds: session.remainingDuration,
                isRunning: false,
                progress: session.progress,
            )
        }
        
        var tabBarVisibility: Visibility {
            return playStatus?.isPlaying == true ? .hidden : .automatic
        }
    }
    
    enum Action {
        case playToggled
        case sounctToggled
        case checkTapped
        case wrappingUpAlertDismissed
        case earlyWrappingUpAlertDismissed
        case saveAndComplete
        case resumeTimer
        case deleteProgress
        case completedBottomSheetDismissed
        case timer(TimerFeature.Action)
        case completed(FocusCompletedFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        
        Scope(state: \.completed, action: \.completed) {
            FocusCompletedFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .playToggled:
                
                if (state.timer.isRunning) {
                    state.playStatus = .paused
                    return .send(.timer(.pause))
                }
                
                state.playStatus = .inProgress
                return .send(.timer(.start))
            case .sounctToggled:
                state.isSoundOn = !state.isSoundOn
                return .none
            case .checkTapped:
                // 3분 이상 경과했는지 확인
                if state.timer.isThreeMinutesElapsed {
                    state.showWrappingUpAlert = true
                } else {
                    state.showEarlyWrappingUpAlert = true
                }
            
                return .send(.timer(.pause))
            case .wrappingUpAlertDismissed:
                state.showWrappingUpAlert = false
                return .none
            case .earlyWrappingUpAlertDismissed:
                state.showEarlyWrappingUpAlert = false
                return .none
            case .saveAndComplete:
                state.showWrappingUpAlert = false
                state.showCompletedBottomSheet = true
                return .none
            case .resumeTimer:
                state.showWrappingUpAlert = false
                return .send(.timer(.start))
            case .deleteProgress:
                state.showWrappingUpAlert = false
                return .none
            case .completedBottomSheetDismissed:
                state.showCompletedBottomSheet = false
                return .none
            case .completed(.finishSession):
                state.showCompletedBottomSheet = false
                // TODO: 세션 완료 처리 로직 추가
                return .none
            case .completed(.breakAction):
                state.showCompletedBottomSheet = false
                // TODO: 5분 휴식 처리 로직 추가
                return .none
            case .timer:
                return .none
            case .completed:
                return .none
            }
        }
    }
}
