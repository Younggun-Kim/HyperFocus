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
    @ObservableState
    struct State {
        var currentScreen: AppScreen = .splash
        var splash: SplashFeature.State?
        var onboarding: OnboardingFeature.State?
        var main: MainFeature.State?
        
        init() {
            // 앱 시작 시 Splash 화면 표시
            self.splash = SplashFeature.State()
        }
    }
    
    enum Action {
        case splash(SplashFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case main(MainFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .splash(.delegate(.splashCompleted)):
                // Splash 완료 시 Onboarding으로 이동
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
