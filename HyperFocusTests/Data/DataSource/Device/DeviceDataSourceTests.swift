//
//  DeviceDataSourceTests.swift
//  HyperFocusTests
//
//  Created by 김영건 on 1/3/26.
//

import Testing
import ComposableArchitecture
@testable import HyperFocus
import Foundation
import UIKit

@Suite("DeviceDataSource 테스트")
struct DeviceDataSourceTests {
    
    // MARK: - Live Value Tests
    
    @Test("Live Value로 앱 버전 조회 - Bundle에서 실제 버전 반환 확인")
    func testGetAppVersion_WithLiveValue_ReturnsVersionFromBundle() {
        let dataSource = DeviceDataSource.liveValue
        
        let version = dataSource.getAppVersion()
        
        // Bundle에서 실제 버전을 읽어오므로 "Unknown"이 아니어야 함
        #expect(version != "Unknown")
        #expect(!version.isEmpty)
        
        // 버전 형식 검증 (예: "1.0.0" 형식)
        let versionComponents = version.split(separator: ".")
        #expect(!versionComponents.isEmpty, "버전은 최소한 하나의 컴포넌트를 가져야 합니다")
    }
    
    @Test("Live Value로 빌드 번호 조회 - Bundle에서 실제 빌드 번호 반환 확인")
    func testGetBuildNumber_WithLiveValue_ReturnsBuildNumberFromBundle() {
        let dataSource = DeviceDataSource.liveValue
        
        let buildNumber = dataSource.getBuildNumber()
        
        // Bundle에서 실제 빌드 번호를 읽어오므로 "Unknown"이 아니어야 함
        #expect(buildNumber != "Unknown")
        #expect(!buildNumber.isEmpty)
        
        // 빌드 번호는 숫자여야 함
        #expect(buildNumber.allSatisfy { $0.isNumber || $0 == "." },
                "빌드 번호는 숫자여야 합니다")
    }
    
    @Test("Live Value 앱 버전이 Bundle 정보와 일치하는지 확인")
    func testGetAppVersion_WithLiveValue_MatchesBundleInfo() {
        let dataSource = DeviceDataSource.liveValue
        let version = dataSource.getAppVersion()
        
        // Bundle에서 직접 읽은 값과 비교
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        
        #expect(version == bundleVersion,
                "DeviceDataSource가 반환한 버전은 Bundle의 CFBundleShortVersionString과 일치해야 합니다")
    }
    
    @Test("Live Value 빌드 번호가 Bundle 정보와 일치하는지 확인")
    func testGetBuildNumber_WithLiveValue_MatchesBundleInfo() {
        let dataSource = DeviceDataSource.liveValue
        let buildNumber = dataSource.getBuildNumber()
        
        // Bundle에서 직접 읽은 값과 비교
        let bundleBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        
        #expect(buildNumber == bundleBuildNumber,
                "DeviceDataSource가 반환한 빌드 번호는 Bundle의 CFBundleVersion과 일치해야 합니다")
    }
    
    // MARK: - Test Value Tests
    
    @Test("Test Value로 앱 버전 조회 - Mock 값 반환 확인")
    func testGetAppVersion_WithTestValue_ReturnsMockVersion() {
        let dataSource = DeviceDataSource.testValue
        
        let version = dataSource.getAppVersion()
        
        #expect(version == "1.0.0")
    }
    
    @Test("Test Value로 빌드 번호 조회 - Mock 값 반환 확인")
    func testGetBuildNumber_WithTestValue_ReturnsMockBuildNumber() {
        let dataSource = DeviceDataSource.testValue
        
        let buildNumber = dataSource.getBuildNumber()
        
        #expect(buildNumber == "1")
    }
    
    @Test("Test Value로 디바이스 모델 조회 - Mock 값 반환 확인")
    func testGetDeviceModel_WithTestValue_ReturnsMockModel() async throws {
        let dataSource = DeviceDataSource.testValue
        
        let deviceModel = try await dataSource.getDeviceModel()
        
        #expect(deviceModel == "iPhone")
    }
    
    @Test("Test Value로 OS 버전 조회 - Mock 값 반환 확인")
    func testGetOSVersion_WithTestValue_ReturnsMockOSVersion() async throws {
        let dataSource = DeviceDataSource.testValue
        
        let osVersion = try await dataSource.getOSVersion()
        
        #expect(osVersion == "17.0")
    }
    
    // MARK: - Custom DataSource Tests
    
    @Test("Live Value로 디바이스 모델 조회 - 실제 모델 반환 확인")
    func testGetDeviceModel_WithLiveValue_ReturnsDeviceModel() async throws {
        let dataSource = DeviceDataSource.liveValue
        
        let deviceModel = try await dataSource.getDeviceModel()
        
        // UIDevice.current.model은 빈 문자열이 아니어야 함
        #expect(!deviceModel.isEmpty)
        // 일반적인 iOS 디바이스 모델 형식 검증
        #expect(deviceModel.contains("iPhone") || deviceModel.contains("iPad") || deviceModel.contains("iPod") || deviceModel.contains("Apple"))
    }
    
    @Test("Live Value로 OS 버전 조회 - 실제 OS 버전 반환 확인")
    func testGetOSVersion_WithLiveValue_ReturnsOSVersion() async throws {
        let dataSource = DeviceDataSource.liveValue
        
        let osVersion = try await dataSource.getOSVersion()
        
        // OS 버전은 빈 문자열이 아니어야 함
        #expect(!osVersion.isEmpty)
        // OS 버전 형식 검증 (예: "17.0" 형식)
        let versionComponents = osVersion.split(separator: ".")
        #expect(!versionComponents.isEmpty, "OS 버전은 최소한 하나의 컴포넌트를 가져야 합니다")
    }
    
    @Test("Live Value 디바이스 모델이 UIDevice와 일치하는지 확인")
    func testGetDeviceModel_WithLiveValue_MatchesUIDevice() async throws {
        let dataSource = DeviceDataSource.liveValue
        let deviceModel = try await dataSource.getDeviceModel()
        
        // UIDevice에서 직접 읽은 값과 비교
        let uiDeviceModel = await MainActor.run {
            UIDevice.current.model
        }
        
        #expect(deviceModel == uiDeviceModel,
                "DeviceDataSource가 반환한 디바이스 모델은 UIDevice.current.model과 일치해야 합니다")
    }
    
    @Test("Live Value OS 버전이 UIDevice와 일치하는지 확인")
    func testGetOSVersion_WithLiveValue_MatchesUIDevice() async throws {
        let dataSource = DeviceDataSource.liveValue
        let osVersion = try await dataSource.getOSVersion()
        
        // UIDevice에서 직접 읽은 값과 비교
        let uiDeviceOSVersion = await MainActor.run {
            UIDevice.current.systemVersion
        }
        
        #expect(osVersion == uiDeviceOSVersion,
                "DeviceDataSource가 반환한 OS 버전은 UIDevice.current.systemVersion과 일치해야 합니다")
    }
    
    @Test("커스텀 DataSource 생성 및 값 반환 확인")
    func testCustomDataSource_ReturnsCustomValues() {
        let customVersion = "2.5.0"
        let customBuildNumber = "42"
        
        let dataSource = DeviceDataSource(
            getAppVersion: { customVersion },
            getBuildNumber: { customBuildNumber },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        #expect(dataSource.getAppVersion() == customVersion)
        #expect(dataSource.getBuildNumber() == customBuildNumber)
    }
    
    @Test("여러 커스텀 DataSource의 독립성 확인")
    func testCustomDataSource_WithDifferentValues() async throws {
        let version1 = "3.0.0"
        let buildNumber1 = "100"
        let deviceModel1 = "iPhone 14"
        let osVersion1 = "16.0"
        
        let dataSource1 = DeviceDataSource(
            getAppVersion: { version1 },
            getBuildNumber: { buildNumber1 },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { deviceModel1 },
            getOSVersion: { osVersion1 }
        )
        
        let version2 = "4.0.0"
        let buildNumber2 = "200"
        let deviceModel2 = "iPad Pro"
        let osVersion2 = "17.0"
        
        let dataSource2 = DeviceDataSource(
            getAppVersion: { version2 },
            getBuildNumber: { buildNumber2 },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { deviceModel2 },
            getOSVersion: { osVersion2 }
        )
        
        // 각 DataSource가 독립적으로 동작하는지 확인
        #expect(dataSource1.getAppVersion() == version1)
        #expect(dataSource1.getBuildNumber() == buildNumber1)
        #expect(try await dataSource1.getDeviceModel() == deviceModel1)
        #expect(try await dataSource1.getOSVersion() == osVersion1)
        #expect(dataSource2.getAppVersion() == version2)
        #expect(dataSource2.getBuildNumber() == buildNumber2)
        #expect(try await dataSource2.getDeviceModel() == deviceModel2)
        #expect(try await dataSource2.getOSVersion() == osVersion2)
    }
    
    // MARK: - Preview Value Tests
    
    @Test("Preview Value가 Test Value와 동일한지 확인")
    func testPreviewValue_ReturnsTestValue() {
        let previewDataSource = DeviceDataSource.previewValue
        let testDataSource = DeviceDataSource.testValue
        
        // previewValue는 testValue를 반환해야 함
        #expect(previewDataSource.getAppVersion() == testDataSource.getAppVersion())
        #expect(previewDataSource.getBuildNumber() == testDataSource.getBuildNumber())
    }
    
    // MARK: - GetDeviceUUID Tests
    
    @Test("Test Value로 Device UUID 조회 - Mock 값 반환 확인")
    func testGetDeviceUUID_WithTestValue_ReturnsMockUUID() async throws {
        let dataSource = DeviceDataSource.testValue
        
        let uuid = try await dataSource.getDeviceUUID()
        
        #expect(uuid == "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
    }
    
    @Test("Live Value로 Device UUID 조회 - 실제 UUID 반환 확인")
    func testGetDeviceUUID_WithLiveValue_ReturnsUUID() async throws {
        let dataSource = DeviceDataSource.liveValue
        
        let uuid = try await dataSource.getDeviceUUID()
        
        // identifierForVendor는 nil일 수 있지만, 일반적으로는 UUID를 반환함
        // UUID 형식 검증 (36자, 하이픈 포함)
        if let uuid = uuid {
            #expect(uuid.count == 36, "UUID는 36자여야 합니다")
            #expect(uuid.split(separator: "-").count == 5, "UUID는 5개의 하이픈으로 구분된 섹션을 가져야 합니다")
        }
    }
    
    @Test("커스텀 DataSource로 Device UUID 조회 - 커스텀 값 반환 확인")
    func testGetDeviceUUID_WithCustomDataSource_ReturnsCustomUUID() async throws {
        let customUUID = "12345678-1234-1234-1234-123456789ABC"
        
        let dataSource = DeviceDataSource(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            getDeviceUUID: { customUUID },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        let uuid = try await dataSource.getDeviceUUID()
        
        #expect(uuid == customUUID)
    }
    
    @Test("커스텀 DataSource로 디바이스 모델 조회 - 커스텀 값 반환 확인")
    func testGetDeviceModel_WithCustomDataSource_ReturnsCustomModel() async throws {
        let customModel = "iPhone 15 Pro"
        
        let dataSource = DeviceDataSource(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { customModel },
            getOSVersion: { "17.0" }
        )
        
        let deviceModel = try await dataSource.getDeviceModel()
        
        #expect(deviceModel == customModel)
    }
    
    @Test("커스텀 DataSource로 OS 버전 조회 - 커스텀 값 반환 확인")
    func testGetOSVersion_WithCustomDataSource_ReturnsCustomOSVersion() async throws {
        let customOSVersion = "18.0"
        
        let dataSource = DeviceDataSource(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { "iPhone" },
            getOSVersion: { customOSVersion }
        )
        
        let osVersion = try await dataSource.getOSVersion()
        
        #expect(osVersion == customOSVersion)
    }
    
    @Test("Device UUID가 nil을 반환할 수 있는지 확인")
    func testGetDeviceUUID_CanReturnNil() async throws {
        let dataSource = DeviceDataSource(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            getDeviceUUID: { nil },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        let uuid = try await dataSource.getDeviceUUID()
        
        #expect(uuid == nil)
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("다중 스레드 환경에서의 스레드 안전성 확인")
    func testDataSource_IsThreadSafe() async {
        let dataSource = DeviceDataSource.liveValue
        
        // 여러 스레드에서 동시에 호출해도 안전한지 확인
        await withTaskGroup(of: String.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    return dataSource.getAppVersion()
                }
            }
            
            var versions: [String] = []
            for await version in group {
                versions.append(version)
            }
            
            // 모든 버전이 동일해야 함
            let firstVersion = versions.first
            #expect(firstVersion != nil)
            #expect(versions.allSatisfy { $0 == firstVersion },
                    "모든 스레드에서 동일한 버전을 반환해야 합니다")
        }
    }
    
    // MARK: - Parameterized Tests
    
    @Test("다양한 버전 형식으로 커스텀 DataSource 테스트", arguments: versionFormats)
    func testCustomDataSource_VariousVersionFormats(version: String, buildNumber: String) async throws {
        let dataSource = DeviceDataSource(
            getAppVersion: { version },
            getBuildNumber: { buildNumber },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        #expect(dataSource.getAppVersion() == version)
        #expect(dataSource.getBuildNumber() == buildNumber)
    }
    
    // MARK: - Arguments for Parameterized Test
    
    static var versionFormats: [(String, String)] {
        [
            ("1.0.0", "1"),
            ("2.5.3", "42"),
            ("10.0.0", "100"),
            ("0.1.0", "0")
        ]
    }
}
