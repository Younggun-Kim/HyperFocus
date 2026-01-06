//
//  FocusRestFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import Foundation
import ComposableArchitecture
import SwiftUI


@Reducer
struct FocusRestFeature: Reducer {
    @Dependency(\.amplitudeService) var amplitudeService
    @Dependency(\.restUseCase) var restUseCase
    
    @ObservableState
    struct State: Equatable {
        var timer: TimerFeature.State = TimerFeature.State()
        var toast: ToastFeature.State = ToastFeature.State()
        
        var session: SessionEntity
        var restSession: RestEntity?
        var playStatus: SessionStatusType?
        var showCompletionPopup: Bool = false
        
        init(session: SessionEntity) {
            self.session = session
            self.timer = TimerFeature.State(
                playbackRate: Environment.isDevelopment ? 10 : 1,
                totalSeconds: 5 * 60,
                remainingSeconds: 5 * 60,
                isRunning: false,
            )
        }
        var initialized: Bool {
            return restSession != nil
        }
        var tabBarVisibility: Visibility {
            return playStatus?.isPlaying == true ? .hidden : .automatic
        }
    }
    
    @CasePathable
    enum Action {
        case timer(TimerFeature.Action)
        case toast(ToastFeature.Action)
        case inner(InnerAction)
        case effect(EffectAction)
        case delegate(Delegate)
        
        enum InnerAction: Equatable {
            case onAppear
            case checkTapped
            case start
            case stop
            case skip
            case completionPopupDismissed
            case startNextTaskTapped
            case moreBreakTapped
            case resumeFlowTapped
        }
        enum EffectAction {
            case startResponse(Result<RestEntity?, Error>)
            case skipResponse(Result<RestSkipEntity?, Error>)
            case completeResponse(Result<Bool, Error>)
            case extendResponse(Result<RestExtensionEntity?, Error>)
            case resumeFlowCompleteRespons(Result<Bool, Error>)
        }
        enum Delegate: Equatable {
            case skipRest
            case startNextTask
            case resumeFlow
        }
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        Scope(state: \.toast, action: \.toast) {
            ToastFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .toast(let action):
                return toastAction(&state, action: action)
            case .timer(let action):
                return timerAction(&state, action: action)
            case .inner(let inner):
                return innerAction(&state, action: inner)
            case .effect(let effect):
                return effectAction(&state, action: effect)
            case .delegate(let delegate):
                return delegateAction(&state, action: delegate)
            }
        }
    }
    
    
    func toastAction(_ state: inout State, action: ToastFeature.Action) -> Effect<Action> {
        return .none
    }
    
    func timerAction(_ state: inout State, action: TimerFeature.Action) -> Effect<Action> {
        switch action {
        case .timerTick:
            return .none
        case .delegate(.timerCompleted):
            return .send(.inner(.checkTapped))
        default:
            return .none
        }
    }
    
    func delegateAction(_ state: inout State, action: Action.Delegate) -> Effect<Action> {
        return .none
    }
    
    func innerAction(_ state: inout State, action: Action.InnerAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            if state.initialized { return .none }
            
            let focusSessionId = state.session.id
            
            return .run { send in
                do {
                    let rest = try await restUseCase.start(focusSessionId)
                    await send(.effect(.startResponse(.success(rest))))
                } catch {
                    await send(.effect(.startResponse(.failure(error))))
                }
            }
        case .checkTapped:
            state.showCompletionPopup = true
            return .none
        case .start:
            if !state.initialized || state.playStatus == .inProgress {
                return .send(.inner(.onAppear))
            }
            
            state.playStatus = .inProgress
            
            return .send(.timer(.start))
        case .stop:
            if !state.initialized || state.playStatus == .paused { return .none }
            
            state.playStatus = .paused
            
            return .send(.timer(.pause))
        case .skip:
            
            guard let restSessionId = state.restSession?.id else {
                return .none
            }
            
            return .run { send in
                do {
                    let rest = try await restUseCase.skip(restSessionId)
                    await send(.effect(.skipResponse(.success(rest))))
                } catch {
                    await send(.effect(.skipResponse(.failure(error))))
                }
            }
        case .completionPopupDismissed:
            state.showCompletionPopup = false
            return .none
        case .startNextTaskTapped:
            guard let restSessionId = state.restSession?.id else {
                return .none
            }
            
            let actualSeconds = state.timer.actualSeconds
            return .run { send in
                do {
                    let response = try await restUseCase.complete(restSessionId, actualSeconds)
                    
                    await send(.effect(.completeResponse(.success(response))))
                    
                } catch {
                    await send(.effect(.completeResponse(.failure(error))))
                }
            }
        case .moreBreakTapped:
            guard let restSessionId = state.restSession?.id,
                  state.restSession?.canExtend == true else {
                return .send(.toast(.show("휴식을 연장하실 수 없습니다.")))
            }
            
            return .run { send in
                do {
                    let response = try await restUseCase.extend(restSessionId)
                    
                    await send(.effect(.extendResponse(.success(response))))
                } catch {
                    await send(.effect(.extendResponse(.failure(error))))
                }
            }
        case .resumeFlowTapped:
            guard let restSessionId = state.restSession?.id else {
                return .none
            }
            
            let actualSeconds = state.timer.actualSeconds
            return .run { send in
                do {
                    let response = try await restUseCase.complete(restSessionId, actualSeconds)
                    
                    await send(.effect(.resumeFlowCompleteRespons(.success(response))))
                    
                } catch {
                    await send(.effect(.resumeFlowCompleteRespons(.failure(error))))
                }
            }
        }
    }
    
    func effectAction(_ state: inout State, action: Action.EffectAction) -> Effect<Action> {
        switch action {
        case let .startResponse(.success(rest)):
            
            if let rest = rest {
                var currentTimer = state.timer
                currentTimer.totalSeconds = rest.targetDurationSeconds
                currentTimer.remainingSeconds = rest.elapsedSeconds
                state.timer = currentTimer
                state.restSession = rest
            }
            
            return .send(.inner(.start))
        case let .startResponse(.failure(error)):
            return .send(.toast(.show(error.localizedDescription)))
        case  .skipResponse(.success(_)):
            return .send(.delegate(.skipRest))
        case let .skipResponse(.failure(error)):
            return .send(.toast(.show(error.localizedDescription)))
        case .completeResponse(.success(_)):
            return .send(.delegate(.startNextTask))
        case let .completeResponse(.failure(error)):
            return .send(.toast(.show(error.localizedDescription)))
        case let .extendResponse(.success(extendedRest)):
            if let extendedRest {
                var currentRest = state.restSession
                
                currentRest?.canExtend = extendedRest.canExtend
                currentRest?.targetDurationSeconds = extendedRest.targetDurationSeconds
                currentRest?.extensionCount = extendedRest.extensionCount
                currentRest?.remainingExtensions = extendedRest.remainingExtensions
                
                state.restSession = currentRest
                state.showCompletionPopup = false
            }
            return .send(.inner(.start))
        case let .extendResponse(.failure(error)):
            return .send(.toast(.show(error.localizedDescription)))
        case .resumeFlowCompleteRespons(.success(_)):
            return .send(.delegate(.resumeFlow))
        case let .resumeFlowCompleteRespons(.failure(error)):
            return .send(.toast(.show(error.localizedDescription)))
        }
    }
}
