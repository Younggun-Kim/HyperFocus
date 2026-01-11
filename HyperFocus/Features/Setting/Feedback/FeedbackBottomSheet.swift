//
//  FeedbackBottomSheet.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct FeedbackBottomSheet: View {
    @Bindable var store: StoreOf<FeedbackFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView
                .padding(.top, 20)
                .padding(.bottom, 40)
            Text(SettingText.categories)
                .font(.body.bold())
                .foregroundStyle(Color.white)
                .padding(.bottom, 16)
            CategoryView
                .padding(.bottom, 50)
            InputView
                .padding(.bottom, 40)
            
            
            Button(action: {
                store.send(.inner(.sendTapped))
            }) {
                Text(SettingText.send)
                    .font(.body.bold())
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .background(Color.systemBlue)
                    .cornerRadius(24)
                    .glassEffect(.clear, in: .buttonBorder)
                    .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(Color(hex: "#1C1C1E"))
        .toast(message: Binding(
            get: { store.toast.message },
            set: { _ in store.send(.scope(.toast(.dismiss))) }
        ))
    }
    
    var HeaderView: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.systemGray.opacity(0.3))
                Image(systemName: "xmark")
                    .tint(.white)
                    .foregroundStyle(Color.white)
            }
            .frame(width: 44, height: 44)
            .onTapGesture {
                store.send(.delegate(.dismiss))
            }
            Spacer()
            Text(SettingText.talkToDeveloper)
                .font(.headline)
                .foregroundStyle(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var CategoryView: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(FeedbackCategory.allCases, id: \.self) { category in
                CommonChip(
                    title: category.title,
                    style: .grayFill,
                    selected: store.category == category,
                    action: {
                        store.send(.inner(.categoryTapped(category)))
                    }
                )
            }
        }
    }
    
    var InputView: some View {
        VStack {
            TextEditor(
                text: $store.inputText.sending(
                    \.inner.inputTextChanged)
            )
            .autocorrectionDisabled(true)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
            .font(.title)
            .foregroundStyle(Color.systemBlue)
            .multilineTextAlignment(.leading)
            .overlay(alignment: .topLeading) {
                if store.inputText.isEmpty {
                    CharWrappingText(
                        text: store.category.hint,
                        font: .preferredFont(forTextStyle: .title1),
                        color: .systemGray,
                        alignment: .left
                    )
                    .padding(26)
                }
            }
            HStack {
                Spacer()
                Text("\(store.inputText.count) / 500")
                    .font(.caption)
                    .foregroundStyle(Color.systemGray)
                    .padding(.bottom, 20)
                    .padding(.trailing, 20)
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.systemLightGray.opacity(0.3))
        .cornerRadius(16)
    }
}

#Preview {
    FeedbackBottomSheet(
        store: Store(initialState: FeedbackFeature.State()) {
            FeedbackFeature()
        } withDependencies: {
            $0.settingUseCase = .testValue
        }
    )
    .background(.black)
}
