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
        }
        enum EffectAction {
            case startResponse(Result<RestEntity?, Error>)
            case skipResponse(Result<RestSkipEntity?, Error>)
        }
        enum Delegate: Equatable {
            case skipRest
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
            return .none
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
        }
    }
}
