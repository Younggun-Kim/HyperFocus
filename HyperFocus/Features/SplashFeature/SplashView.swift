//
//  SplashView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import ComposableArchitecture
import SwiftUI

struct SplashView: View {
    @Bindable var store: StoreOf<SplashFeature>
    
    var body: some View {
        AmbientZStack(style: .black) {
            Text("HyperFocus")
                .font(.commingSoon)
                .foregroundStyle(.white)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        }
    )
}
