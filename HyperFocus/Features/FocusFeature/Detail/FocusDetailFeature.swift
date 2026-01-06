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
    @Dependency(\.amplitudeService) var amplitudeService
    @Dependency(\.focusUseCase) var focusUseCase
    
    @ObservableState
    struct State: Equatable {
        var session: SessionEntity
        var playStatus: SessionStatusType?
        var isSoundOn: Bool = true
        var showWrappingUpAlert: Bool = false
        var showEarlyWrappingUpAlert: Bool = false
        var showCompletedBottomSheet: Bool = false
        var showFailReasonBottomSheet: Bool = false
        
        var completed: FocusCompletedFeature.State
        var timer: TimerFeature.State = TimerFeature.State()
        var toast: ToastFeature.State = ToastFeature.State()
        var mileStone: MileStoneFeature.State = MileStoneFeature.State()
        var shownMilestones: Set<Int> = [] // 이미 표시한 milestone (분 단위)
        
        init(session: SessionEntity) {
            self.session = session
            self.timer = TimerFeature.State(
                playbackRate: Environment.isDevelopment ? 50 : 1,
                totalSeconds: session.targetDurationSeconds,
                remainingSeconds: session.remainingDuration,
                isRunning: false,
                progress: session.progress,
            )
            self.completed = .init(sessionId: session.id)
        }
        
        var tabBarVisibility: Visibility {
            return playStatus?.isPlaying == true ? .hidden : .automatic
        }
    }
    
    enum Action {
        case stop
        case start
        case updateSession(SessionEntity)
        case sounctToggled
        case checkTapped
        case wrappingUpAlertDismissed
        case earlyWrappingUpAlertDismissed
        case saveAndComplete
        case resumeTimer
        case deleteProgress
        case completedBottomSheetDismissed
        case failReasonBottomSheetDismissed
        case failReasonSelected(SessionFailReasonType)
        case failReasonResponse(Result<SessionFailReasonType, Error>)
        case delegate(Delegate)
        
        case timer(TimerFeature.Action)
        case completed(FocusCompletedFeature.Action)
        case toast(ToastFeature.Action)
        case mileStone(MileStoneFeature.Action)
        
        enum Delegate: Equatable {
            case sessionCompleted
            case sessionAbandoned(SessionFailReasonType)
            case breakSession(SessionEntity)
        }
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        Scope(state: \.completed, action: \.completed) {
            FocusCompletedFeature()
        }
        Scope(state: \.toast, action: \.toast) {
            ToastFeature()
        }
        Scope(state: \.mileStone, action: \.mileStone) {
            MileStoneFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .toast(let action):
                return toastAction(&state, action: action)
            case .timer(let action):
                return timerAction(&state, action: action)
            case .completed(let action):
                return completedAction(&state, action: action)
            case .stop:
                let sessionId = state.session.id
                
                state.playStatus = .paused
                return .run { send in
                    do {
                        if let session = try await focusUseCase.pauseSession(sessionId) {
                            await send(.updateSession(session))
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    await send(.timer(.pause))
                }
                
            case .start:
                let sessionId = state.session.id
                
                state.playStatus = .inProgress
                return .run { send in
                    do {
                        if let session = try await focusUseCase.resumeSession(sessionId) {
                            await send(.updateSession(session))
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    await send(.timer(.start))
                }
            case .updateSession(let session):
                state.session = session
                return .none
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
                
                amplitudeService.track(
                    .viewStopAlert(
                        .init(
                            isUnderThreeMinutes: state.timer.isThreeMinutesElapsed,
                            elapsedTime: state.timer.remainingSeconds
                        )
                    )
                )
                
                return .send(.stop)
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
                return .send(.start)
            case .deleteProgress:
                state.showWrappingUpAlert = false
                state.showEarlyWrappingUpAlert = false
                state.showFailReasonBottomSheet = true
                
                return .none
            case .completedBottomSheetDismissed:
                state.showCompletedBottomSheet = false
                return .none
            case .failReasonBottomSheetDismissed:
                state.showFailReasonBottomSheet = false
                return .none
            case .failReasonSelected(let reason):
                state.showFailReasonBottomSheet = false
                
                let sessionId = state.session.id
                let actualDurationSeconds = state.session.targetDurationSeconds - state.timer.remainingSeconds
                let params = SessionAbandonParams(
                    actualDurationSeconds: actualDurationSeconds,
                    failReason: reason.rawValue
                )
                
                return .run { send in
                    do {
                        _ = try await focusUseCase.abandonSession(
                            sessionId,
                            params
                        )
                        await send(.failReasonResponse(.success(reason)))
                    } catch {
                        await send(.failReasonResponse(.failure(error)))
                    }
                }
            case let .failReasonResponse(.success(reason)):
                // Bottom sheet 닫기
                state.showFailReasonBottomSheet = false
                
                amplitudeService.track(
                    .clickSessionDiscard(.init(isUnderThreeMinutes: state.timer.isThreeMinutesElapsed))
                )
                
                // FocusHome으로 이동하기 위해 delegate 액션 전송
                return .send(.delegate(.sessionAbandoned(reason)))
                
            case let .failReasonResponse(.failure(error)):
                // TODO: - Toast
                print(error.localizedDescription)
                
                return .none
            case .delegate:
                return .none
            case .mileStone:
                return .none
            default:
                return .none
            }
        }
    }
    
    func toastAction(_ state: inout State, action: ToastFeature.Action) -> Effect<Action> {
        return .none
    }
    
    func timerAction(_ state: inout State, action: TimerFeature.Action) -> Effect<Action> {
        switch action {
        case .timerTick:
            // 경과 시간 계산 (초 단위)
            // milestone 체크할 시간들 (분 단위)
            let milestones = [5, 15, 25, 40, 60]
            let elapsedMinutes = (state.timer.remainingSeconds / 60) + 1
            
            if milestones.contains(elapsedMinutes),
               !state.shownMilestones.contains(elapsedMinutes) {
                state.shownMilestones.insert(elapsedMinutes)
                return .send(.mileStone(.show(state.session.id, elapsedMinutes)))
            }
            
            return .none
        case .delegate(.timerCompleted):
            state.showCompletedBottomSheet = true
            return .none
        default:
            return .none
        }
    }
    
    func completedAction(_ state: inout State, action: FocusCompletedFeature.Action) -> Effect<Action> {
        switch action {
        case .delegate(.finishSession(let completionType)):
            state.showCompletedBottomSheet = false
            let sessionId = state.session.id
            let actualSeconds = state.timer.actualSeconds
            let saveToLog = state.timer.isThreeMinutesElapsed
            
            state.playStatus = .completed
            
            
            amplitudeService.track(
                .completeFocusSession(
                    .init(
                        isAutoFinish: completionType == .auto,
                        duration: actualSeconds
                    )
                )
            )
            
            return .run { send in
                do {
                    let _ = try await focusUseCase.completeSession(
                        sessionId,
                        .init(
                            actualDurationSeconds: actualSeconds,
                            completionType: completionType,
                            saveToLog: saveToLog
                        )
                    )
                    await send(.delegate(.sessionCompleted))
                } catch {
                    await send(.toast(.show(error.localizedDescription)))
                }
            }
        case .delegate(.breakAction):
            state.showCompletedBottomSheet = false
            
            let session = state.session
            
            return .run { send in
                try await Task.sleep(for: .milliseconds(500))
                await send(.delegate(.breakSession(session)))
            }
        default:
            return .none
        }
    }
}
