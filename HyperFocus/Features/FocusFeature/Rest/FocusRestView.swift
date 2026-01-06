//
//  FocusRestView.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import SwiftUI
import ComposableArchitecture

struct FocusRestView: View {
    @Bindable var store: StoreOf<FocusRestFeature>
    
    var body: some View {
        AmbientZStack(style: .calmDark) {
            Text("fef")
        }
        .toast(message: Binding(
            get: { store.toast.message },
            set: { _ in store.send(.toast(.dismiss)) }
        ))
    }
}

#Preview {
    FocusRestView(
        store: Store(initialState: FocusRestFeature.State()) {
            FocusRestFeature()
        }
    )
}
