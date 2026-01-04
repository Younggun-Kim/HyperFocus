//
//  ToastModifier.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
    @Binding var message: String?
    let duration: TimeInterval
    
    public init(message: Binding<String?>, duration: TimeInterval = 2.0) {
        self._message = message
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let message = message {
                    Text(message)
                        .frame(maxWidth: .infinity)
                        .font(.body)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.systemBlue)
                        .cornerRadius(40)
                        .padding(.bottom, 50)
                        .padding(.horizontal, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            // duration 후 자동으로 dismiss
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                self.message = nil
                            }
                        }
                }
            }
            .animation(.easeInOut, value: message)
    }
}

public extension View {
    func toast(message: Binding<String?>, duration: TimeInterval = 2.0) -> some View {
        modifier(ToastModifier(message: message, duration: duration))
    }
}

