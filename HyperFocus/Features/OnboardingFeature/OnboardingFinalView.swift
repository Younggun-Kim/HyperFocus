//
//  OnboardingFinalView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingFinalView: View {
    
    @Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        AmbientZStack(style: .black, alignment: .top) {
            VStack {
                Text(BaseText.onboardingFinalTitle)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text(BaseText.onboardingFinalDescription)
                    .font(.body)
                    .foregroundStyle(.white)
                Spacer()
                Text(BaseText.start)
                    .font(.title)
                    .foregroundStyle(.white)
                Image(AssetSystem.icPlay.rawValue)
                    .gesture(TapGesture().onEnded{ _ in
                        store.send(.startTapped)
                    })
            }
            .padding(.top, 200)
            .padding(.bottom, 169)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingFinalView(
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
}
