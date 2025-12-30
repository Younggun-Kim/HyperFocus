//
//  LogView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import SwiftUI

struct LogView: View {
    @Bindable var store: StoreOf<LogFeature>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Log")
                    .font(.largeTitle)
                    .bold()
                
                Text("Log 화면입니다")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Log")
        }
    }
}

#Preview {
    LogView(
        store: Store(initialState: LogFeature.State()) {
            LogFeature()
        }
    )
}

