//
//  SessionEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct SessionEntity: Codable, Sendable, Equatable {
    var id: String
    var name: String?
    var targetDurationSeconds: Int
    var actualDurationSeconds: Int
    var startedAt: Date
    var pausedAt: Date?
    var completedAt: Date?
    var status: SessionStatusType?
}


extension SessionEntity {
    var remainingDuration: Int {
        max(0, targetDurationSeconds - actualDurationSeconds)
    }
    
    var progress: Double {
        Double(remainingDuration / targetDurationSeconds)
    }
    
    static var mock: SessionEntity {
        .init(
            id: UUID().uuidString,
            name: "Session Name",
            targetDurationSeconds: 3600,
            actualDurationSeconds: 300,
            startedAt: Date(),
            pausedAt: Date(),
            completedAt: Date()
        )
    }
}
