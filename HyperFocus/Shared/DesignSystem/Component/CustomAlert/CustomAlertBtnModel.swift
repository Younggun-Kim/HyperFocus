//
//  CustomAlertBtnModel.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import Foundation


public struct CustomAlertBtnModel: Identifiable {
    public var id: UUID
    var title: String
    var style: CustomAlertBtnStyle
    var action: () -> Void
    
    init(
        id: UUID = UUID(),
        title: String,
        style: CustomAlertBtnStyle,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.style = style
        self.action = action
    }
}
