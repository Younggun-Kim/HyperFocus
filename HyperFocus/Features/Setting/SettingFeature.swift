//
//  SettingFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//


import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct SettingFeature {
    @Dependency(\.settingUseCase) var settingUseCase
    @Dependency(\.amplitudeService) var amplitudeService
    
    @ObservableState
    struct State: Equatable {
        var soundOn: Bool = false
        var hapticOn: Bool = false
        var alarmOn: Bool = false
        var toast = ToastFeature.State()
        var feedback: FeedbackFeature.State?
        var showFeedbackBottomSheet: Bool = false
    }
    
    @CasePathable
    enum Action {
        case inner(InnerAction)
        case effect(EffectAction)
        case delegate(DelegateAction)
        case scope(ScopeAction)
        
        enum InnerAction {
            case onAppear
            case soundToggled(Bool)
            case hapticToggled(Bool)
            case alarmToggled(Bool)
            case aboutUsTapped(SettingMetadata.AboutUs)
            case feedbackBottomSheetDismissed
        }
        
        enum EffectAction {
            case getSettingResponse(Result<SettingEntity?, Error>)
            case patchSettingResponse(Result<SettingEntity?, Error>)
        }
        
        enum DelegateAction {}
        
        @CasePathable
        enum ScopeAction {
            case toast(ToastFeature.Action)
            case feedback(FeedbackFeature.Action)
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
        .ifLet(\.feedback, action: \.scope.feedback) {
            FeedbackFeature()
        }
    }
    
    func delegateAction(_ state: inout State, action: Action.DelegateAction) -> Effect<Action> {
        
    }
    
    func scopeAction(_ state: inout State, action: Action.ScopeAction) -> Effect<Action> {
        switch action {
        case .toast:
            return .none
        case .feedback(.delegate(.dismiss)):
            state.showFeedbackBottomSheet = false
            state.feedback = nil
            return .none
        case .feedback(.delegate(.sendFeedbackSucceeded)):
            state.showFeedbackBottomSheet = false
            state.feedback = nil
            return .send(.scope(.toast(.show("Message received! Thanks. 💌"))))
        case .feedback:
            return .none
        }
    }
    
    func innerAction(_ state: inout State, action: Action.InnerAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                do {
                    let response = try await settingUseCase.getSetting()
                    await send(.effect(.getSettingResponse(.success(response))))
                } catch {
                    await send(.effect(.getSettingResponse(.failure(error))))
                }
            }

        case let .soundToggled(isOn):
            state.soundOn = isOn
            amplitudeService.track(.changeAppSetting(.init(settingName: "sound")))
            return .run { [soundOn = state.soundOn, hapticOn = state.hapticOn, alarmOn = state.alarmOn] send in
                do {
                    let response = try await settingUseCase.patchSetting(soundOn, hapticOn, alarmOn)
                    await send(.effect(.patchSettingResponse(.success(response))))
                } catch {
                    await send(.effect(.patchSettingResponse(.failure(error))))
                }
            }
        case let .hapticToggled(isOn):
            state.hapticOn = isOn
            amplitudeService.track(.changeAppSetting(.init(settingName: "haptic")))
            return .run { [soundOn = state.soundOn, hapticOn = state.hapticOn, alarmOn = state.alarmOn] send in
                do {
                    let response = try await settingUseCase.patchSetting(soundOn, hapticOn, alarmOn)
                    await send(.effect(.patchSettingResponse(.success(response))))
                } catch {
                    await send(.effect(.patchSettingResponse(.failure(error))))
                }
            }
        case let .alarmToggled(isOn):
            state.alarmOn = isOn
            amplitudeService.track(.changeAppSetting(.init(settingName: "alarm")))
            return .run { [soundOn = state.soundOn, hapticOn = state.hapticOn, alarmOn = state.alarmOn] send in
                do {
                    let response = try await settingUseCase.patchSetting(soundOn, hapticOn, alarmOn)
                    await send(.effect(.patchSettingResponse(.success(response))))
                } catch {
                    await send(.effect(.patchSettingResponse(.failure(error))))
                }
            }
        case let .aboutUsTapped(aboutUs):
            switch aboutUs {
            case .talkToDeveloper:
                state.showFeedbackBottomSheet = true
                state.feedback = FeedbackFeature.State()
                return .none
            case .privacyPolicy, .termsOfService:
                // TODO: Handle other cases
                return .none
            }
        case .feedbackBottomSheetDismissed:
            state.showFeedbackBottomSheet = false
            state.feedback = nil
            return .none
        }
    }
    
    func effectAction(_ state: inout State, action: Action.EffectAction) -> Effect<Action> {
        switch action {
        case let .getSettingResponse(.success(setting)):
            if let setting = setting {
                state.soundOn = setting.soundEnabled
                state.hapticOn = setting.hapticEnabled
                state.alarmOn = setting.alarmEnabled
            }
            return .none
        case let .getSettingResponse(.failure(error)):
            return .send(.scope(.toast(.show(error.localizedDescription))))
        case .patchSettingResponse(.success):
            // 성공 시 별도 처리 없음 (이미 state가 업데이트됨)
            return .none
        case let .patchSettingResponse(.failure(error)):
            return .send(.scope(.toast(.show(error.localizedDescription))))
        }
    }
}

extension StoreOf<SettingFeature> {
    func binding(for setting: SettingMetadata.DeviceSetting) -> Binding<Bool> {
        switch setting {
        case .sound:
            return Binding(
                get: { self.soundOn },
                set: { self.send(.inner(.soundToggled($0))) }
            )
        case .haptic:
            return Binding(
                get: { self.hapticOn },
                set: { self.send(.inner(.hapticToggled($0))) }
            )
        case .alarm:
            return Binding(
                get: { self.alarmOn },
                set: { self.send(.inner(.alarmToggled($0))) }
            )
        }
    }
}

