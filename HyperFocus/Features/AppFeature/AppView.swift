//
//  AppView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        Group {
            if let splashStore = store.scope(state: \.splash, action: \.splash) {
                SplashView(store: splashStore)
                    .transition(.opacity)
            } else if let onboardingStore = store.scope(state: \.onboarding, action: \.onboarding) {
                OnboardingView(store: onboardingStore)
                    .transition(.opacity)
            } else if let mainStore = store.scope(state: \.main, action: \.main) {
                MainView(store: mainStore)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: store.currentScreen)
        .onAppear {
            store.send(.onAppear)
        }
        .alert("강제 업데이트", isPresented: Binding(
            get: { store.showForceUpdateAlert },
            set: { _ in store.send(.forceUpdateAlertDismissed) }
        )) {
            Button("업데이트") {
                store.send(.openAppStore)
            }
        } message: {
            Text("새로운 버전이 있습니다. 업데이트가 필요합니다.")
        }
        .alert(isPresented: Binding(
            get: { store.showRecommendUpdateAlert },
            set: { _ in store.send(.recommendUpdateAlertDismissed) }
        )) {
            Alert(
                title: Text("업데이트 안내"),
                message: Text("새로운 버전이 있습니다. 업데이트가 필요합니다."),
                primaryButton: .default(
                    Text("업데이트"),
                    action: {
                        store.send(.openAppStore)
                    }
                ) ,
                secondaryButton: .destructive(
                    Text("닫기")
                )
            )
        }
    }
}

#Preview("강제 업데이트") {
    AppView(
        store: Store(initialState: {
            var state = AppFeature.State()
            state.currentScreen = .splash
            state.splash = SplashFeature.State()
            state.showForceUpdateAlert = true
            return state
        }()) {
            AppFeature()
        } withDependencies: {
            $0.appConfigUseCase = .preview(updateType: .required)
        }
    )
}

#Preview("권장 업데이트") {
    AppView(
        store: Store(initialState: {
            var state = AppFeature.State()
            state.currentScreen = .splash
            state.splash = SplashFeature.State()
            state.showRecommendUpdateAlert = true
            return state
        }()) {
            AppFeature()
        } withDependencies: {
            $0.appConfigUseCase = .preview(updateType: .optional)
        }
    )
}

#Preview("업데이트 불필요") {
    AppView(
        store: Store(initialState: {
            var state = AppFeature.State()
            state.currentScreen = .splash
            state.splash = SplashFeature.State()
            return state
        }()) {
            AppFeature()
        } withDependencies: {
            $0.appConfigUseCase = .preview(updateType: .none)
        }
    )
}
