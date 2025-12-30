//
//  AppFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import ComposableArchitecture
import Foundation

enum AppScreen: Equatable {
    case splash
    case onboarding
    case main
}

@Reducer
struct AppFeature {
    @Dependency(\.appConfigUseCase) var appConfigUseCase
    
    @ObservableState
    struct State {
        var currentScreen: AppScreen?
        var splash: SplashFeature.State?
        var onboarding: OnboardingFeature.State?
        var main: MainFeature.State?
    }
    
    enum Action {
        case onAppear
        case splash(SplashFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case main(MainFeature.Action)
        case needUpdateRseponse(Result<Bool, Error>)
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
                        let needUpdate = try await appConfigUseCase.needAppUpdate()
                        await send(.needUpdateRseponse(.success(needUpdate)))
                    } catch {
                        await send(.needUpdateRseponse(.failure(error)))
                    }
                }
                
            case let .needUpdateRseponse(.success(needUpdate)):
                if needUpdate {
                    // TODO: 앱 업데이트 필요 처리
                    return .none
                } else {
                    // Onboarding으로 이동
                    state.currentScreen = .onboarding
                    state.splash = nil
                    state.onboarding = OnboardingFeature.State()
                    return .none
                }
                
            case .needUpdateRseponse(.failure):
                // 에러 발생 시 Onboarding으로 이동 (또는 에러 처리)
                state.currentScreen = .onboarding
                state.splash = nil
                state.onboarding = OnboardingFeature.State()
                return .none
                
            case .onboarding(.delegate(.onboardingCompleted)):
                // Onboarding 완료 시 Main으로 이동
                state.currentScreen = .main
                state.onboarding = nil
                state.main = MainFeature.State()
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
