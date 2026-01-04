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
        
        var timer: TimerFeature.State = TimerFeature.State()
        var completed: FocusCompletedFeature.State = FocusCompletedFeature.State()
        
        init(session: SessionEntity) {
            self.session = session
            self.timer = TimerFeature.State(
                playbackRate: 100,
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
        
        enum Delegate: Equatable {
            case sessionAbandoned(SessionFailReasonType)
        }
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
            case .delegate:
                return .none
                
            case let .failReasonResponse(.failure(error)):
                // TODO: - Toast
                print(error.localizedDescription)
                
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
