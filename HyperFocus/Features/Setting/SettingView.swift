//
//  SettingView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    @Bindable var store: StoreOf<SettingFeature>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AppleLoginView(isLoggedIn: false)
                    .padding(.bottom, 40)
                
                // Device Settings
                VStack(spacing: 16) {
                    ForEach([SettingMetadata.DeviceSetting.sound, .haptic, .alarm], id: \.self) { setting in
                        SettingToggleItem(
                            icon: setting.icon,
                            iconSize: setting.iconSize,
                            title: setting.title,
                            isOn: store.binding(for: setting)
                        )
                    }
                }
                
                // About Us
                VStack(spacing: 16) {
                    ForEach([SettingMetadata.AboutUs.privacyPolicy, .termsOfService, .talkToDeveloper], id: \.self) { setting in
                        SettingButtonItem(
                            icon: setting.icon,
                            iconSize: setting.iconSize,
                            title: setting.title
                        )
                        .onTapGesture {
                            store.send(.inner(.aboutUsTapped(setting)))
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            store.send(.inner(.onAppear))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(.black)
        .toast(message: Binding(
            get: { store.toast.message },
            set: { _ in store.send(.scope(.toast(.dismiss))) }
        ))
        .sheet(isPresented: Binding(
            get: { store.showFeedbackBottomSheet },
            set: { newValue in
                if !newValue && store.showFeedbackBottomSheet {
                    store.send(.inner(.feedbackBottomSheetDismissed))
                }
            }
        )) {
            if let feedbackStore = store.scope(state: \.feedback, action: \.scope.feedback) {
                FeedbackBottomSheet(store: feedbackStore)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large])
            }
        }
    }
}

#Preview {
    SettingView(
        store: Store(initialState: SettingFeature.State()) {
            SettingFeature()
        } withDependencies: {
            $0.settingUseCase = .testValue
        }
    )
}
