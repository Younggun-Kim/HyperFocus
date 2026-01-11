//
//  FeedbackFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//


import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct FeedbackFeature {
    @Dependency(\.settingUseCase) var settingUseCase
    @Dependency(\.amplitudeService) var amplitudeService
    
    @ObservableState
    struct State: Equatable {
        var toast = ToastFeature.State()
        var category: FeedbackCategory = .featureIdea
        var inputText: String = ""
    }
    
    @CasePathable
    enum Action {
        case inner(InnerAction)
        case effect(EffectAction)
        case delegate(DelegateAction)
        case scope(ScopeAction)
        
        @CasePathable
        enum InnerAction {
            case onAppear
            case categoryTapped(FeedbackCategory)
            case inputTextChanged(String)
        }
        
        enum EffectAction {
        }
        
        enum DelegateAction {
            case dismiss
        }
        
        @CasePathable
        enum ScopeAction {
            case toast(ToastFeature.Action)
        }
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.toast, action: \.scope.toast) {
            ToastFeature()
        }
        
        Reduce { state, action in
            switch action {
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
    }
    
    func delegateAction(_ state: inout State, action: Action.DelegateAction) -> Effect<Action> {
        switch action {
        case .dismiss:
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
            return .none
        case .categoryTapped(let cateogry):
            state.category = cateogry
            return .none
        case .inputTextChanged(let text):
            if text.count > 500 {
                return .none
            }
            
            state.inputText = text
            return .none
        }
    }
    
    func effectAction(_ state: inout State, action: Action.EffectAction) -> Effect<Action> {
        
    }
}
