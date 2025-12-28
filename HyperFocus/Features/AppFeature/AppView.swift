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
        .animation(.easeInOut, value: store.splash != nil)
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}

