//
//  Environment.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation

public struct Environment: Equatable {
    enum Keys: String {
        case apiBaseURL = "API_BASE_URL"
    }
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let apiBaseURL: URL = {
        guard let rootURLstring = Environment.infoDictionary[Keys.apiBaseURL.rawValue] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()
}
