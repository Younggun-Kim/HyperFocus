//
//  FeedbackMetadata.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation


enum FeedbackCategory: CaseIterable, Hashable {
    case featureIdea
    case bugReport
    case other
}

extension FeedbackCategory {
    var title: String {
        switch self {
        case .featureIdea: return "💡 Feature Idea"
        case .bugReport: return "🐞 Bug Report"
        case .other: return "💬 Other"
        }
    }
    
    var hint: String {
        switch self {
        case .featureIdea: return "Got a brilliant idea?\nI'm all ears!"
        case .bugReport: return "Oops! What went wrong?\nPlease describe the glitch."
        case .other: return "Anything on your mind?\nFeel free to share."
        }
    }
}
