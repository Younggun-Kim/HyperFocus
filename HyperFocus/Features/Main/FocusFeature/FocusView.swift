//
//  FocusView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import SwiftUI

struct FocusView: View {
    @Bindable var store: StoreOf<FocusFeature>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Focus")
                    .font(.largeTitle)
                    .bold()
                
                Text("Focus 화면입니다")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Focus")
        }
    }
}

#Preview {
    FocusView(
        store: Store(initialState: FocusFeature.State()) {
            FocusFeature()
        }
    )
}

