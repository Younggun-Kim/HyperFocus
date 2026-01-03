//
//  AppFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import ComposableArchitecture
import Foundation
import UIKit

enum AppScreen: Equatable {
    case splash
    case onboarding
    case main
}

@Reducer
struct AppFeature {
    @Dependency(\.appConfigUseCase) var appConfigUseCase
    @Dependency(\.loginUseCase) var loginUseCase
    
    @ObservableState
    struct State {
        var currentScreen: AppScreen?
        var splash: SplashFeature.State?
        var onboarding: OnboardingFeature.State?
        var main: MainFeature.State?
        var showForceUpdateAlert: Bool = false
        var showRecommendUpdateAlert: Bool = false
    }
    
    enum Action {
        case onAppear
        case splash(SplashFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case main(MainFeature.Action)
        case moveOnboarding
        case needAppUpdateResponse(Result<VersionUpdateType, Error>)
        case forceUpdateAlertDismissed
        case recommendUpdateAlertDismissed
        case openAppStore
        case login
        case loginResponse(Result<Bool, Error>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("AppFeature.onAppear")
                state.currentScreen = .splash
                state.splash = SplashFeature.State()
                return .none
                
            case .splash(.delegate(.splashCompleted)):
                return .run { send in
                    do {
                        let response = try await appConfigUseCase.needAppUpdate()
                        await send(.needAppUpdateResponse(.success(response)))
                    } catch {
                        await send(.needAppUpdateResponse(.failure(error)))
                    }
                }
            case .moveOnboarding:
                state.currentScreen = .onboarding
                state.splash = nil
                state.onboarding = OnboardingFeature.State()
                
                return .none
                
            case let .needAppUpdateResponse(.success(updateType)):
                switch(updateType) {
                case .none:
                    return .run { send in
                        await send(.login)
                    }
                case .optional:
                    state.showRecommendUpdateAlert = true
                case .required:
                    state.showForceUpdateAlert = true
                }
                
                return .none
                
            case .needAppUpdateResponse(.failure):
                // TODO: - Toast 메시지
                return .none
                
            case .forceUpdateAlertDismissed:
                state.showForceUpdateAlert = false
                return .none
                
            case .recommendUpdateAlertDismissed:
                state.showRecommendUpdateAlert = false
                
                return .run { send in
                    await send(.login)
                }
                
            case .openAppStore:
                // TODO: - 앱 스토어 URL 설정
                if let url = URL(string: "https://apps.apple.com/kr/app/withu-%EC%9C%84%EB%93%9C%EC%9C%A0/id6739505809") {
                    return .run { @MainActor send in
                        await UIApplication.shared.open(url)
                    }
                }
                return .none
                
            case .onboarding(.delegate(.onboardingCompleted)):
                // Onboarding 완료 시 Main으로 이동
                state.currentScreen = .main
                state.onboarding = nil
                state.main = MainFeature.State()
                return .none
            case .login:
                return .run { send in
                    do {
                        let result = try await loginUseCase.autoLogin()
                        await send(.loginResponse(.success(result)))
                    } catch {
                        await send(.loginResponse(.failure(error)))
                    }
                }
            case let .loginResponse(.success(login)):
                if login {
                    return .run { send in
                        await send(.moveOnboarding)
                    }
                }
                
                // TODO: - Toast 로그인 실패 메시지
                return .none
            case .loginResponse(.failure):
                // TODO: - Toast
                return .none
                
            case .splash:
                return .none
            case .onboarding:
                return .none
            case .main:
                return .none
            }
        }
        .ifLet(\.splash, action: \.splash) {
            SplashFeature()
        }
        .ifLet(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
        .ifLet(\.main, action: \.main) {
            MainFeature()
        }
        ._printChanges()
    }
}
