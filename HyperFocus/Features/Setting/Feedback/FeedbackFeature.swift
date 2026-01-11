//
//  FeedbackFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//


import ComposableArchitecture
import Foundation
import SwiftUI
import UIKit

@Reducer
struct FeedbackFeature {
    @Dependency(\.settingUseCase) var settingUseCase
    @Dependency(\.amplitudeService) var amplitudeService
    @Dependency(\.deviceDataSource) var deviceDataSource
    
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
            case sendTapped
        }
        
        enum EffectAction {
        }
        
        enum DelegateAction {
            case dismiss
            case sendFeedbackSucceeded
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
        case .sendFeedbackSucceeded:
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
        case .sendTapped:
            if state.inputText.isEmpty {
                return .send(.scope(.toast(.show(SettingText.Feedback.pleaseEnterFeedback))))
            }
            
            let category = state.category
            let content = state.inputText
            
            return .run { send in
                // 디바이스 정보 수집
                let appVersion = deviceDataSource.getAppVersion()
                let deviceModel = await UIDevice.current.model
                let osVersion = await UIDevice.current.systemVersion
                
                // FeedbackRequest 생성
                let request = FeedbackRequest(
                    category: category.rawValue,
                    content: content,
                    appVersion: appVersion,
                    deviceModel: deviceModel,
                    osVersion: osVersion
                )
                
                do {
                    _ = try await settingUseCase.sendFeedback(request)
                    // 성공 시 피드백 닫기
                    await send(.delegate(.sendFeedbackSucceeded))
                } catch let error as APIError {
                    // 실패 시 에러 메시지를 토스트로 출력
                    await send(.scope(.toast(.show(error.userMessage))))
                } catch {
                    // 기타 에러 처리
                    await send(.scope(.toast(.show(SettingText.Feedback.failedToSendFeedback))))
                }
            }
        }
    }
    
    func effectAction(_ state: inout State, action: Action.EffectAction) -> Effect<Action> {
        
    }
}
