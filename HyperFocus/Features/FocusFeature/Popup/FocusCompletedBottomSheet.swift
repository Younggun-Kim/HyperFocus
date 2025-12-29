//
//  FocusCompletedBottomSheet.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import ComposableArchitecture
import SwiftUI

struct FocusCompletedBottomSheet: View {
    @Bindable var store: StoreOf<FocusCompletedFeature>
    
    var body: some View {
        VStack{
            Text(FocusText.CompletedBottomSheet.title)
                .multilineTextAlignment(.center)
                .font(.largeTitle.bold())
                .foregroundStyle(Color.systemBlue)
                .shadow(
                    color: Color.systemBlue.opacity(0.50),
                    radius: 10
                )
            HStack {
                CommonChip(
                    title: FocusText.CompletedBottomSheet.hyperFocus,
                    style: .gray,
                    selected: false,
                    action: {}
                )
                Spacer()
                CommonChip(
                    title: FocusText.CompletedBottomSheet.good,
                    style: .gray,
                    selected: false,
                    action: {}
                )
                Spacer()
                CommonChip(
                    title: FocusText.CompletedBottomSheet.distracted,
                    style: .gray,
                    selected: false,
                    action: {}
                )
            }
            .padding(.top, 24)
            .padding(.bottom, 40)
            Button(action: {
                store.send(.finishSession)
            }) {
                Text(FocusText.CompletedBottomSheet.finishSession)
                    .frame(maxWidth: .infinity)
                    .font(.title3.bold())
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.secondary)
                    .cornerRadius(40)
            }
            Button(action: {
                store.send(.breakAction)
            }) {
                Text(FocusText.CompletedBottomSheet.fiveMinBreak)
                    .frame(maxWidth: .infinity)
                    .font(.title3.bold())
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(40)
            }
        }
        .padding(.top, 70)
        .padding(.horizontal, 24)
    }
}

#Preview {
    FocusCompletedBottomSheet(
        store: Store(initialState: FocusCompletedFeature.State()) {
            FocusCompletedFeature()
        }
    )
}
