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


extension SessionAbandonParams {
    func toRequest() -> SessionAbandonRequest {
        .init(actualDurationSeconds: actualDurationSeconds, failReason: failReason)
    }
}


extension MileStoneResponse {
    func toEntity() -> MileStoneEntity {
        .init(
            milestoneMinute: milestoneMinute,
            messageId: messageId,
            message: message,
            messageKo: messageKo,
            emoji: emoji
        )
    }
}


extension SessionCompletionParams {
    func toRequest() -> SessionCompletionRequest {
        .init(actualDurationSeconds: actualDurationSeconds, completionType: completionType.rawValue, saveToLog: saveToLog)
    }
}


extension SessionCompletionResponse {
    func toEntity()throws -> SessionCompletionEntity {
        guard let status = SessionStatusType(rawValue: self.status),
              let completionType = SessinCompletionType(rawValue: self.completionType) else {
            throw CommonError.invalidFormat
        }
        
        
        return SessionCompletionEntity(
            id: id,
            status: status,
            actualDurationSeconds: 1500,
            completionType: completionType,
            completedAt: completedAt,
            minimumDurationMet: minimumDurationMet,
            targetAchieved: targetAchieved,
        )
    }
}


extension SessionFeedbackResponse {
    func toEntity() throws -> FeedbackEntity? {
        guard let satisfaction = SatisfactionType(rawValue: self.satisfaction) else {
            throw CommonError.invalidFormat
        }
        
        return FeedbackEntity(
            id: id,
            satisfaction: satisfactionType,
            message: satisfactionFeedback
        )
    }
}
