//
//  LogHomeView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import SwiftUI
import ComposableArchitecture

struct LogHomeView: View {
    @Bindable var store: StoreOf<LogHomeFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ZStack(alignment: .topLeading) {
                Color.black
                    .ignoresSafeArea(edges: .all)
                
                Header
            }
        } destination: { store in
            switch store.case {
            case let .setting(settingStore):
                SettingView(store: settingStore)
            }
        }
    }
    
    var Header: some View {
        GeometryReader { geometry in
            HStack {
                Text("HyperFocus")
                    .font(Font.CommoingSoon.title)
                    .foregroundStyle(.white)
                Spacer()
                Button(action: {
                    store.send(.settingTapped)
                }) {
                    Image(AssetSystem.icSetting.rawValue)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    LogHomeView(
        store: Store(initialState: LogHomeFeature.State()) {
            LogHomeFeature()
        }
    )
}
