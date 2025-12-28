//
//  FocusDetailView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import SwiftUI

struct FocusDetailView: View {
    @Bindable var store: StoreOf<FocusDetailFeature>
    
    var body: some View {
        AmbientZStack(style: .black) {
            VStack {
                Text("목표: \(store.focusGoal.value)")
                    .foregroundColor(.white)
                    .font(.title)
                
                if let time = store.time {
                    Text("시간: \(time.title)")
                        .foregroundColor(.white)
                        .font(.body)
                }
            }
        }
    }
}

#Preview {
    FocusDetailView(
        store: Store(initialState: FocusDetailFeature.State(
            focusGoal: FocusGoal("테스트 목표")!,
            time: nil
        )) {
            FocusDetailFeature()
        }
    )
}
