//
//  OnboardingView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    @Dependency(\.amplitudeService) var amplitudeService
    
    
    var body: some View {
        TabView(selection: Binding(
            get: { store.page },
            set: { store.send(.pageChanged($0)) }
        )) {
            OnboardingTodoView(store: store)
                .tag(OnboardingType.todo)
                .onAppear {
                    amplitudeService.track(.viewOnboardingIntro)
                }
            OnboardingTimerView(store: store)
                .tag(OnboardingType.timer)
                .onAppear {
                    amplitudeService.track(.viewOnboardingTimer)
                }
            OnboardingFinalView(store: store)
                .tag(OnboardingType.finally)
                .onAppear {
                    amplitudeService.track(.viewOnboardingStart)
                }
        }
        .onAppear{
            UIScrollView.appearance().bounces = false
        }
        .ignoresSafeArea()
        .tabViewStyle(.page(indexDisplayMode: .never))
        .safeAreaInset(edge: .top, alignment: .trailing) {
            Button(action: {
                store.send(.skipBtnTapped)
            }){
                Text(BaseText.skip)
                    .font(.system(
                        size: 17,
                        weight: .regular
                    ))
                    .foregroundStyle(.white)
            }.padding(EdgeInsets(
                top: 10,
                leading: 0,
                bottom: 0,
                trailing: 24,
            ))
        }
    }
}

#Preview {
    OnboardingView(
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
}
