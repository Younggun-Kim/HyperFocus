//
//  SessionFeedbackResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation

public struct SessionFeedbackResponse: Codable {
    var id: String // uuid
    var satisfaction: String // GOOD
    var satisfactionFeedback: String
}
