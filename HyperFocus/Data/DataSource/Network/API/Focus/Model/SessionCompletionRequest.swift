//
//  SessionCompletionRequest.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation

public struct SessionCompletionRequest: Codable {
    var actualDurationSeconds: Int // 1500
    var completionType: String // AUTO(00:00 도달) | MANUAL(Save 클릭)
    var saveToLog:Bool // 기록 저장 여부 (3분 미만은 false)
}
