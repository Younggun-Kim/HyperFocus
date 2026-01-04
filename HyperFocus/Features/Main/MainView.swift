//
//  MainView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    @Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        TabView(selection: Binding(
            get: { store.selectedTab },
            set: { store.send(.tabChanged($0)) }
        )) {
            FocusHomeView(
                store: store.scope(state: \.focus, action: \.focus)
            )
            .tabItem {
                Label("Focus", systemImage: "play")
                    .foregroundStyle(.white)
            }
            .tag(MainTab.focus)
            
            LogHomeView(store: store.scope(state: \.log, action: \.log))
                .tabItem {
                    Label("Log", systemImage: "watch.analog")
                        .foregroundStyle(.white)
                }
                .tag(MainTab.log)
        }
    }
}

#Preview {
    MainView(
        store: Store(initialState: MainFeature.State()) {
            MainFeature()
        }
    )
}

