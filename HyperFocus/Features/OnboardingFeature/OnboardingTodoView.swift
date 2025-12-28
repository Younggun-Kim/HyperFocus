//
//  OnboardingTodoView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/26/25.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingTodoView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    @State private var ambientStyle: AmbientStyleType = .allBlack
    @State private var offset = CGSize(width: 0, height: 0)
    @State private var titleOffset: CGFloat = 0
    @State private var showText: Bool = false
    @State private var animation: Animation = .easeInOut(duration: 1)
    
    var body: some View {
        AmbientZStack(style: ambientStyle) {
            VStack(alignment: .center){
                Text("Don't Plan. Just Flow.")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(.init(top: 200, leading: 0, bottom: 0, trailing: 0))
                Text("Rigid plans block your brain.\nWe just let you flow.")
                    .font(.body)
                    .foregroundStyle(.white)
                Spacer()
            }
            .opacity(showText ? 1 : 0)
            VStack(spacing: 15){
                TodoPlaceholderView(animatedOffset: .init(width: -150, height: 0))
                TodoPlaceholderView(animatedOffset: .init(width: 120, height: -150))
                TodoPlaceholderView(animatedOffset: .init(width: 80, height: -100))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(animation) {
                self.ambientStyle = .black
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.showText = true
                }
            }
        }
        .gesture(TapGesture().onEnded{_ in
            if(!showText) {
                return
            }
            
            store.send(.todoCompleted)
        })
    }
}

struct TodoPlaceholderView: View {
    let animatedOffset: CGSize
    
    @State private var size:CGSize = .init(width: 269, height: 60)
    @State private var offset = CGSize(width: 0, height: 0)
    @State private var cornerRadius: CGFloat = 10
    @State private var opacity: Double = 0.3
    private var animation: Animation = .easeInOut(duration: 1)
    
    init(animatedOffset: CGSize = .zero) {
        self.animatedOffset = animatedOffset
    }
    
    var body: some View {
        Text("To do..")
            .frame(width: size.width, height: size.height)
            .background(Color(.systemGray))
            .opacity(opacity)
            .cornerRadius(cornerRadius)
            .foregroundStyle(.white)
            .offset(offset)
            .onAppear {
                withAnimation(animation) {
                    self.size = .init(
                        width: 300,
                        height: 300
                    )
                    self.cornerRadius = 150
                    self.opacity = 0
                    self.offset = animatedOffset
                }
            }
    }
}

#Preview {
    OnboardingTodoView(
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
}
