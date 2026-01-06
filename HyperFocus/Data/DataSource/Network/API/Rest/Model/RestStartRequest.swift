//
//  RestStartRequest.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct RestStartRequest: Codable, Sendable, Equatable {
    var focusSessionId: String // UUID
    var targetDurationSeconds: Int = 5 * 60
}
