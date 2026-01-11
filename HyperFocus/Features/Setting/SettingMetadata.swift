//
//  SettingMetadata.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation

enum SettingMetadata {
    
    enum DeviceSetting {
        case sound
        case haptic
        case alarm
    }
    
    enum AboutUs {
        case privacyPolicy
        case termsOfService
        case talkToDeveloper
    }
}

extension SettingMetadata.DeviceSetting {
    var icon: String {
        switch self {
        case .sound: return "speaker.wave.2.fill"
        case .haptic: return "hand.tap.fill"
        case .alarm: return "bell.fill"
        }
    }
    
    var iconSize: CGSize {
        switch self {
        case .sound: return .init(width: 24, height: 24)
        case .haptic: return .init(width: 24, height: 24)
        case .alarm: return .init(width: 24, height: 24)
        }
    }
    
    var title: String {
        switch self {
        case .sound: return "Sound"
        case .haptic: return "Haptic"
        case .alarm: return "Alarm"
        }
    }
}

extension SettingMetadata.AboutUs {
    var icon: String {
        switch self {
        case .privacyPolicy: return "figure.2"
        case .termsOfService: return "book.circle"
        case .talkToDeveloper: return "paperplane.fill"
        }
    }
    var iconSize: CGSize {
        switch self {
        case .privacyPolicy: return .init(width: 28, height: 20)
        case .termsOfService: return .init(width: 29, height: 29)
        case .talkToDeveloper: return .init(width: 21, height: 21)
            
        }
    }
    
    var title: String {
        switch self {
        case .privacyPolicy: return "Privacy Policy"
        case .termsOfService: return "Terms of Service"
        case .talkToDeveloper: return "Talk to Developer"
        }
    }
}
