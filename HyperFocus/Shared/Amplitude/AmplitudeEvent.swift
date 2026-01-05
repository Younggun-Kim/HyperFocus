//
//  AmplitudeEvent.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public protocol AmplitudeEventProtocol {
    var key: String { get }
    var properties: [String: Any] { get }
}

public enum AmplitudeEvent{
    // MARK: - Onboarding Event
    case viewOnboardingIntro
    case viewOnboardingTimer
    case viewOnboardingStart
    case clickOnboardingComplete
    
    // MARK: - Focus Event
    case viewHome(ViewHomeProps)
    case startFocusSession(StartFocusSessionProps)
    case viewStopAlert(ViewStopAlertProps)
    case clickSessionDiscard(ClickSessionDiscardProps)
    case viewMotivationToast(ViewMotivationToastProps)
    case completeFocusSession(CompleteFocusSessionProps)
    case clickSessionFeedback(ClickSessionFeedbackProps)
    case startRestTimer
}

extension AmplitudeEvent: AmplitudeEventProtocol {
    public var key: String {
        switch self {
        case .viewOnboardingIntro: return "view_onboarding_intro"
        case .viewOnboardingTimer: return "view_onboarding_timer"
        case .viewOnboardingStart: return "view_onboarding_start"
        case .clickOnboardingComplete: return "click_onboarding_complete"
        case .viewHome: return "view_home"
        case .startFocusSession: return "start_focus_session"
        case .viewStopAlert: return "view_stop_alert"
        case .clickSessionDiscard: return "click_session_discard"
        case .viewMotivationToast: return "view_motivation_toast"
        case .completeFocusSession: return "complete_focus_session"
        case .clickSessionFeedback: return "click_session_feedback"
        case .startRestTimer: return "start_rest_timer"
        }
    }
    
    public var properties: [String: Any] {
        switch self {
        case .viewHome(let properties): return properties.toDictionary()
        case .startFocusSession(let properties): return properties.toDictionary()
        case .viewStopAlert(let properties): return properties.toDictionary()
        case .clickSessionDiscard(let properties): return properties.toDictionary()
        case .viewMotivationToast(let properties): return properties.toDictionary()
        case .completeFocusSession(let properties): return properties.toDictionary()
        case .clickSessionFeedback(let properties): return properties.toDictionary()
            
        default: return [:]
        }
    }
}
