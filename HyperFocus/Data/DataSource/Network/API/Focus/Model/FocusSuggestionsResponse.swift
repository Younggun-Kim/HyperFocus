//
//  FocusSuggestionsResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct FocusSuggestionsResponse: Decodable, Equatable, Sendable {
    public let type: String
    public let suggestions: [FocusSuggestionsItemResponse]
    
    public init(
        type: String,
        suggestions: [FocusSuggestionsItemResponse],
    ) {
        self.type = type
        self.suggestions = suggestions
    }
}

public struct FocusSuggestionsItemResponse: Decodable, Equatable, Sendable {
    public let label: String
    public let durationSeconds: Int
    public let reason: String
    public let rank: Int
    
    public init(
        label: String,
        durationSeconds: Int,
        reason: String,
        rank: Int,
    ) {
        self.label = label
        self.durationSeconds = durationSeconds
        self.reason = reason
        self.rank = rank
    }
}

