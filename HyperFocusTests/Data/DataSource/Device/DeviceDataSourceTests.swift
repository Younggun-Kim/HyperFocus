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
    
    // MARK: - Custom DataSource Tests
    
    @Test("커스텀 DataSource 생성 및 값 반환 확인")
    func testCustomDataSource_ReturnsCustomValues() {
        let customVersion = "2.5.0"
        let customBuildNumber = "42"
        
        let dataSource = DeviceDataSource(
            getAppVersion: { customVersion },
            getBuildNumber: { customBuildNumber }
        )
        
        #expect(dataSource.getAppVersion() == customVersion)
        #expect(dataSource.getBuildNumber() == customBuildNumber)
    }
    
    @Test("여러 커스텀 DataSource의 독립성 확인")
    func testCustomDataSource_WithDifferentValues() {
        let version1 = "3.0.0"
        let buildNumber1 = "100"
        
        let dataSource1 = DeviceDataSource(
            getAppVersion: { version1 },
            getBuildNumber: { buildNumber1 }
        )
        
        let version2 = "4.0.0"
        let buildNumber2 = "200"
        
        let dataSource2 = DeviceDataSource(
            getAppVersion: { version2 },
            getBuildNumber: { buildNumber2 }
        )
        
        // 각 DataSource가 독립적으로 동작하는지 확인
        #expect(dataSource1.getAppVersion() == version1)
        #expect(dataSource1.getBuildNumber() == buildNumber1)
        #expect(dataSource2.getAppVersion() == version2)
        #expect(dataSource2.getBuildNumber() == buildNumber2)
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
            getBuildNumber: { buildNumber }
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
