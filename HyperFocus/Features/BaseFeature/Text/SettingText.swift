//
//  SettingText.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation

struct SettingText {
    static let loginEmptyTitle = "Don't lose your journey"
    static let loginEmptyDescription = "Your focus history is stored locally.\nBack it up now"
    
    static let talkToDeveloper = "Talk To Developer"
    static let categories = "Categories"
    
    static let send = "Send"
    
    struct Feedback {
        static let pleaseEnterFeedback = "Please enter feedback"
        static let failedToSendFeedback = "Failed to send feedback."
        
        struct Category {
            struct FeatureIdea {
                static let title = "💡 Feature Idea"
                static let hint = "Got a brilliant idea?\nI'm all ears!"
            }
            
            struct BugReport {
                static let title = "🐞 Bug Report"
                static let hint = "Oops! What went wrong?\nPlease describe the glitch."
            }
            
            struct Other {
                static let title = "💬 Other"
                static let hint = "Anything on your mind?\nFeel free to share."
            }
        }
    }
}
