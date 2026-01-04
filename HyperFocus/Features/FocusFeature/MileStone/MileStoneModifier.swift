//
//  ToastModifier.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import SwiftUI

public struct MileStoneModifier: ViewModifier {
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
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.systemBlue)
                        .padding(.bottom, 280)
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
    func mileStone(message: Binding<String?>, duration: TimeInterval = 3.0) -> some View {
        modifier(MileStoneModifier(message: message, duration: duration))
    }
}

