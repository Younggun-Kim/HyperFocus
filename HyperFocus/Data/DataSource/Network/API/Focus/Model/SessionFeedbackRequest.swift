//
//  SessionFeedbackRequest.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation

public struct SessionFeedbackRequest: Codable {
    var satisfaction: String // 만족도 (필수) - HYPERFOCUS | GOOD | DISTRACTED
}
