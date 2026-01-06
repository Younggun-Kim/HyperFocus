//
//  RestCompletionResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct RestCompletionResponse: Codable, Sendable, Equatable {
    var id: String // UUID
    var status: String // IN_PROGRESS, COMPLETED, SKIPPED
    var completedAt: Date?
    var actualDurationSeconds: Int
    
}
