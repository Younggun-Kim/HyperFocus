//
//  AppleLoginView.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import SwiftUI
import AuthenticationServices


struct AppleLoginView: View {
    var isLoggedIn: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: 5,
                ) {
                    Text(SettingText.loginEmptyTitle)
                        .font(.body.bold())
                        .foregroundStyle(.white)
                    Text(SettingText.loginEmptyDescription)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
                Spacer()
                Text("🚀")
                    .font(.largeTitle.bold())
            }
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        print(authResults)
                        break
                    case .failure(let error) :
                        print(error.localizedDescription)
                        break
                    }
                },
                
            )
            .frame(maxWidth: .infinity, maxHeight: 50)
            .cornerRadius(10)
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 24)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.systemLightGray)
        }
    }
}

#Preview {
    AppleLoginView(
        isLoggedIn: false
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.all, 24)
    .background(.black)
}
