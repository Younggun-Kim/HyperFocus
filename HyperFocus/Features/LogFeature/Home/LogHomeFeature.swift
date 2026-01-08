//
//  LogFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LogHomeFeature {
    @Dependency(\.logUseCase) var logUseCase
    @Dependency(\.amplitudeService) var amplitudeService
    
    @ObservableState
    struct State {
        var isEmpty: Bool = true
        var todayFocus: String = ""
        var diffMessage: String = ""
        var weekTotal: String = ""
        var timelines: [TimelineEntity] = []
        var path = StackState<Path.State>()
        var toast = ToastFeature.State()
    }
    
    @CasePathable
    enum Action {
        case path(StackActionOf<Path>)
        case inner(InnerAction)
        case effect(EffectAction)
        case delegate(DelegateAction)
        case scope(ScopeAction)
        
        enum InnerAction {
            case onAppear
            case settingTapped
        }
        
        enum EffectAction {
            case fetchResponse(Result<DashboardEntity?, Error>)
        }
        
        enum DelegateAction {
            case startFocus
        }
        
        @CasePathable
        enum ScopeAction {
            case toast(ToastFeature.Action)
        }
    }
    
    @Reducer()
    enum Path {
        case setting(SettingFeature)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.toast, action: \.scope.toast) {
            ToastFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .inner(let inner):
                return innerAction(&state, action: inner)
            case .effect(let effect):
                return effectAction(&state, action: effect)
            case .delegate(let delegate):
                return delegateAction(&state, action: delegate)
            case .scope(let scope):
                return scopeAction(&state, action: scope)
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    
    func delegateAction(_ state: inout State, action: Action.DelegateAction) -> Effect<Action> {
        switch action{
        case .startFocus:
            amplitudeService.track(.clickLogEmptyStart)
            return .none
        }
    }
    
    func scopeAction(_ state: inout State, action: Action.ScopeAction) -> Effect<Action> {
        switch action {
        case .toast:
            return .none
        }
    }
    
    func innerAction(_ state: inout State, action: Action.InnerAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                do {
                    let response = try await logUseCase.fetchDashboard()
                    await send(.effect(.fetchResponse(.success(response))))
                } catch {
                    await send(.effect(.fetchResponse(.failure(error))))
                }
            }
        case .settingTapped:
            state.path.append(.setting(SettingFeature.State()))
            return .none
        }
    }
    
    func effectAction(_ state: inout State, action: Action.EffectAction) -> Effect<Action> {
        switch action {
        case let .fetchResponse(.success(dashboard)):
            state.isEmpty = dashboard?.isEmpty ?? true
            state.timelines = dashboard?.timeline ?? []
            state.todayFocus = dashboard?.todayFocusDisplay ?? ""
            state.diffMessage = dashboard?.diffMessage ?? ""
            state.weekTotal = dashboard?.weekTotalDisplay ?? ""
            return .none
        case let .fetchResponse(.failure(error)):
            return .send(.scope(.toast(.show(error.localizedDescription))))
        }
    }
}

