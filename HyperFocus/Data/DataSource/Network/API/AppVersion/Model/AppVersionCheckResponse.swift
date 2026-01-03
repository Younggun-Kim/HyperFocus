//
//  AppVersionCheckResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation

/// 앱 버전 체크 응답 (BaseResponse의 typealias)
public typealias AppVersionCheckResponse = BaseResponse<AppVersionData>

/// 앱 버전 체크 데이터
public struct AppVersionData: Decodable, Equatable, Sendable {
    public let platform: String
    public let currentVersion: String
    public let latestVersion: String?
    public let minimumVersion: String?
    public let recommendedVersion: String?
    public let updateType: String
    public let updateRequired: Bool
    public let forceUpdate: Bool
    public let message: String?
    public let storeUrl: String?
    public let releaseNotes: String?
    
    public init(
        platform: String,
        currentVersion: String,
        latestVersion: String? = nil,
        minimumVersion: String? = nil,
        recommendedVersion: String? = nil,
        updateType: String,
        updateRequired: Bool,
        forceUpdate: Bool,
        message: String? = nil,
        storeUrl: String? = nil,
        releaseNotes: String? = nil
    ) {
        self.platform = platform
        self.currentVersion = currentVersion
        self.latestVersion = latestVersion
        self.minimumVersion = minimumVersion
        self.recommendedVersion = recommendedVersion
        self.updateType = updateType
        self.updateRequired = updateRequired
        self.forceUpdate = forceUpdate
        self.message = message
        self.storeUrl = storeUrl
        self.releaseNotes = releaseNotes
    }
}


extension AppVersionCheckResponse {
    // Mock 응답 반환
    static let mock = AppVersionCheckResponse(
        success: true,
        data: AppVersionData(
            platform: "IOS",
            currentVersion: "1.0.0",
            latestVersion: nil,
            minimumVersion: nil,
            recommendedVersion: nil,
            updateType: "NONE",
            updateRequired: false,
            forceUpdate: false,
            message: nil,
            storeUrl: nil,
            releaseNotes: nil
        ),
        code: "A001"
    )
}

