//
//  CustomAlertModifier.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import SwiftUI


public struct CustomAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let customAlert: CustomAlert
    
    public func body(content: Content) -> some View {
        content
            .transparentFullScreenCover(isPresented: $isPresented) {
                customAlert
            }
            .transaction({ transaction in
                transaction.disablesAnimations = isPresented
            })
    }
}


public extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        params: CustomAlertParams
    ) -> some View {
        return modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                customAlert: CustomAlert(params: params)
            )
        )
    }
}
