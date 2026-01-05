//
//  SessionCompletionParams.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation


public struct SessionCompletionParams: Sendable {
    var actualDurationSeconds: Int // 1500
    var completionType: SessionCompletionType
    var saveToLog:Bool // 기록 저장 여부 (3분 미만은 false)
}
