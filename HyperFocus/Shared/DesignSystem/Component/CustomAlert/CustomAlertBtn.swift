//
//  CustomAlertBtn.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import SwiftUI

public struct CustomAlertBtn: View {
    var params: CustomAlertBtnModel
    
    public var body: some View {
        Button(params.title) {
            params.action()
        }
        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
        .background{
            RoundedRectangle(cornerRadius: 24)
                .fill(params.style.model.bgColor)
        }
        .font(.body.bold())
        .foregroundStyle(params.style.model.fgColor)
    }
}
