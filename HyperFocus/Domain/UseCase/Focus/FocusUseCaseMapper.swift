//
//  FocusUseCaseMapper.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation

extension SessionStartResponse {
    func toEntity() -> SessionEntity {
        return SessionEntity(
            id: self.id,
            name: self.name,
            targetDurationSeconds: self.targetDurationSeconds,
            actualDurationSeconds: self.actualDurationSeconds,
            startedAt: self.startedAt,
            pausedAt: self.pausedAt,
            completedAt: self.completedAt
        )
    }
}

extension CurrentSessionResponse {
    func toEntity() -> SessionEntity {
        return SessionEntity(
            id: self.id,
            name: self.name,
            targetDurationSeconds: self.targetDurationSeconds,
            actualDurationSeconds: self.actualDurationSeconds,
            startedAt: self.startedAt,
            pausedAt: self.pausedAt,
            completedAt: self.completedAt
        )
    }
}

extension SessionResponse {
    func toEntity() -> SessionEntity {
        return SessionEntity(
            id: self.id,
            name: self.name,
            targetDurationSeconds: self.targetDurationSeconds,
            actualDurationSeconds: self.actualDurationSeconds,
            startedAt: self.startedAt,
            pausedAt: self.pausedAt,
            completedAt: self.completedAt,
            status: .init(rawValue: self.status),
        )
    }
    
}
