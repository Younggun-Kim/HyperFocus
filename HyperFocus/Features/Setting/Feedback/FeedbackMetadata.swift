//
//  FeedbackMetadata.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation


enum FeedbackCategory: String, CaseIterable, Hashable {
    case featureIdea = "feature"
    case bugReport = "bug"
    case other = "other"
}

extension FeedbackCategory {
    var title: String {
        switch self {
        case .featureIdea: return SettingText.Feedback.Category.FeatureIdea.title
        case .bugReport: return SettingText.Feedback.Category.BugReport.title
        case .other: return SettingText.Feedback.Category.Other.title
        }
    }
    
    var hint: String {
        switch self {
        case .featureIdea: return SettingText.Feedback.Category.FeatureIdea.hint
        case .bugReport: return SettingText.Feedback.Category.BugReport.hint
        case .other: return SettingText.Feedback.Category.Other.hint
        }
    }
}
