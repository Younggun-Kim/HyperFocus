//
//  CustomAlertBtnStyle.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import SwiftUI

public enum CustomAlertBtnStyle {
    case gray
    case grayRed
    case blue
}

public struct CustomAlertBtnStyleModel {
    var bgColor: Color
    var fgColor: Color
}

public extension CustomAlertBtnStyle {
    var model: CustomAlertBtnStyleModel {
        switch self {
        case .gray:
            return CustomAlertBtnStyleModel(
                bgColor: .secondary,
                fgColor: .white,
            )
        case .grayRed:
            return CustomAlertBtnStyleModel(
                bgColor: .secondary,
                fgColor: .error,
            )
        case .blue:
            return CustomAlertBtnStyleModel(
                bgColor: .systemBlue,
                fgColor: .white,
            )
        }
    }
}
