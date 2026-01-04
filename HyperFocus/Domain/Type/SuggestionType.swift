//
//  SuggestionType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation

public enum SuggestionType: String, CaseIterable {
    case defaults = "DEFAULT" // 기본 추천 (이전 기록 없음)
    case personalized = "REQUIRED" // 개인화 추천 (이전 기록 기반)
    case system = "NONE" // 시스템 추천 (특별 상황)
    
    public init?(rawValue: String) {
        let normalized = rawValue.uppercased().trimmingCharacters(in: .whitespaces)
        
        switch normalized {
        case "DEFAULT": self = .defaults
        case "REQUIRED": self = .personalized
        case "NONE": self = .system
        default: return nil
        }
    }
}
