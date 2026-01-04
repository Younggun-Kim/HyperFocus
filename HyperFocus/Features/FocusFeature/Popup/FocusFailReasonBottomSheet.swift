//
//  FocusFailReasonBottomSheet.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import ComposableArchitecture
import SwiftUI

struct FocusFailReasonBottomSheet: View {
    let onReasonSelected: (SessionFailReasonType) -> Void
    
    var body: some View {
        VStack{
            Text(FocusText.FailReationBottomSheet.title)
                .multilineTextAlignment(.center)
                .font(.largeTitle.bold())
                .foregroundStyle(Color.systemBlue)
                .shadow(
                    color: Color.systemBlue.opacity(0.50),
                    radius: 10
                )
                .padding(.bottom, 40)
            ForEach(SessionFailReasonType.allCases, id: \.self) { type in
                Button(action: {
                    onReasonSelected(type)
                }) {
                    Text(type.reason)
                        .frame(maxWidth: .infinity)
                        .font(.title3.bold())
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(40)
                }
            }
        }
        .padding(.top, 70)
        .padding(.horizontal, 24)
    }
}

#Preview {
    FocusFailReasonBottomSheet(onReasonSelected: { reason in
        print("Selected reason: \(reason)")
    })
}
