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
    @Dependency(\.focusUseCase) var focusUseCase
    @Dependency(\.restUseCase) var restUseCase
    
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
        case currentSessionResponse(Result<SessionEntity, Error>)
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
        
        case effect(EffectAction)
        
        enum EffectAction {
            case currentRestResponse(Result<RestEntity?, Error>)
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
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
                        do {
                            print("🔍 [AppFeature] getCurrentSession 호출 시작")
                            if let session = try await focusUseCase.getCurrentSession() {
                                print("✅ [AppFeature] getCurrentSession 성공: \(session.id)")
                                await send(.currentSessionResponse(.success(session)))
                            } else {
                                print("⚠️ [AppFeature] getCurrentSession: 세션이 nil")
                                await send(.currentSessionResponse(.failure(APIError.unknown("세션이 없습니다"))))
                            }
                        } catch {
                            print("❌ [AppFeature] getCurrentSession 에러: \(error)")
                            await send(.currentSessionResponse(.failure(error)))
                        }
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
            case let .currentSessionResponse(.success(session)):
                print("✅ [AppFeature] currentSessionResponse success: \(session.id)")
                // Main > FocusHome > FocusDetail로 이동
                state.splash = nil
                state.currentScreen = .main
                var mainState = MainFeature.State()
                // FocusHome의 path에 FocusDetail 추가
                mainState.focus.path.append(.detail(FocusDetailFeature.State(session: session)))
                state.main = mainState
                print("✅ [AppFeature] Main 화면으로 이동 완료, path count: \(mainState.focus.path.count)")
                return .none
            case let .currentSessionResponse(.failure(error)):
                print("❌ [AppFeature] currentSessionResponse failure: \(error)")
                return .run { send in
                    await send(.login)
                }
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
                
            case .onboarding(.delegate(.onboardingCompleted)):
                // Onboarding 완료 시 Main으로 이동
                // delegate 액션은 ifLet 전에 처리되어야 함
                state.currentScreen = .main
                state.onboarding = nil
                state.main = MainFeature.State()
                return .none
                
            case .splash:
                return .none
            case .onboarding:
                // delegate 액션은 위에서 처리되므로 여기서는 다른 액션만 처리
                return .none
            case .main:
                return .none
            case .effect(let effect):
                return effectAction(&state, action: effect)
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
    
    
    
    func effectAction(_ state: inout State, action: Action.EffectAction) -> Effect<Action> {
        switch action {
            // TODO: - FocusRestFeature로 이동하기 위해서는 SessionEntity가 필요
        case let .currentRestResponse(.success(reset)):
            return .none
        case let .currentRestResponse(.failure(error)):
            return .none
        }
    }
}
