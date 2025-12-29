//
//  CustomAlertParams.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import SwiftUI


public struct CustomAlertParams {
    var title: String
    var description: String?
    var btns: [CustomAlertBtnModel]
    
    init(title: String, description: String? = nil, btns: [CustomAlertBtnModel]) {
        self.title = title
        self.description = description
        self.btns = btns
    }
}
