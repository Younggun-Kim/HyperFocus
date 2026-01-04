//
//  StartFocusSessionProperties.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct StartFocusSessionProperties: Codable {
    let targetDuration: Int // Seconds
    let inputMethod: InputMethodType
    let setssionTitle: String
    
    enum CodingKeys: String, CodingKey {
        case targetDuration = "target_duration"
        case inputMethod = "input_method"
        case setssionTitle = "session_title"
    }
}
