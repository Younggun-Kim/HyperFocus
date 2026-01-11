//
//  AppRepositoryTests.swift
//  HyperFocusTests
//
//  Created by 김영건 on 1/3/26.
//

import Testing
import ComposableArchitecture
@testable import HyperFocus
import Foundation

@Suite("AppRepository 테스트")
struct AppRepositoryTests {
    
    // MARK: - Live Value Tests
    
    @Test("Live Value로 앱 버전 조회 - DeviceDataSource를 통해 실제 버전 반환 확인")
    func testGetAppVersion_WithLiveValue_ReturnsVersion() {
        let repository = AppRepository.liveValue
        
        let version = repository.getAppVersion()
        
        // DeviceDataSource를 통해 실제 Bundle에서 버전을 읽어옴
        #expect(version != "Unknown")
        #expect(!version.isEmpty)
        // 버전 형식 검증
        #expect(version.contains(".") || version.allSatisfy { $0.isNumber })
    }
    
    @Test("Live Value로 빌드 번호 조회 - DeviceDataSource를 통해 실제 빌드 번호 반환 확인")
    func testGetBuildNumber_WithLiveValue_ReturnsBuildNumber() {
        let repository = AppRepository.liveValue
        
        let buildNumber = repository.getBuildNumber()
        
        // DeviceDataSource를 통해 실제 Bundle에서 빌드 번호를 읽어옴
        #expect(buildNumber != "Unknown")
        #expect(!buildNumber.isEmpty)
    }
    
    @Test("Live Value 앱 버전이 DeviceDataSource와 일치하는지 확인")
    func testGetAppVersion_WithLiveValue_MatchesDeviceDataSource() {
        let repository = AppRepository.liveValue
        let deviceDataSource = DeviceDataSource.liveValue
        
        let repositoryVersion = repository.getAppVersion()
        let dataSourceVersion = deviceDataSource.getAppVersion()
        
        #expect(repositoryVersion == dataSourceVersion,
                "AppRepository가 반환한 버전은 DeviceDataSource의 버전과 일치해야 합니다")
    }
    
    @Test("Live Value 빌드 번호가 DeviceDataSource와 일치하는지 확인")
    func testGetBuildNumber_WithLiveValue_MatchesDeviceDataSource() {
        let repository = AppRepository.liveValue
        let deviceDataSource = DeviceDataSource.liveValue
        
        let repositoryBuildNumber = repository.getBuildNumber()
        let dataSourceBuildNumber = deviceDataSource.getBuildNumber()
        
        #expect(repositoryBuildNumber == dataSourceBuildNumber,
                "AppRepository가 반환한 빌드 번호는 DeviceDataSource의 빌드 번호와 일치해야 합니다")
    }
    
    // MARK: - Test Value Tests
    
    @Test("Test Value로 앱 버전 조회 - Mock 값 반환 확인")
    func testGetAppVersion_WithTestValue_ReturnsMockVersion() {
        let repository = AppRepository.testValue
        
        let version = repository.getAppVersion()
        
        #expect(version == "1.0.0")
    }
    
    @Test("Test Value로 빌드 번호 조회 - Mock 값 반환 확인")
    func testGetBuildNumber_WithTestValue_ReturnsMockBuildNumber() {
        let repository = AppRepository.testValue
        
        let buildNumber = repository.getBuildNumber()
        
        #expect(buildNumber == "1")
    }
    
    @Test("Test Value로 앱 버전 체크 - Mock 응답 반환 확인")
    func testCheckAppVersion_WithTestValue_ReturnsMockResponse() async throws {
        let repository = AppRepository.testValue
        
        let response = try await repository.checkAppVersion("1.0.0")
        
        #expect(response.success == true)
        #expect(response.data != nil)
        #expect(response.data?.currentVersion == "1.0.0")
        #expect(response.data?.latestVersion == nil)
        #expect(response.data?.updateRequired == false)
        #expect(response.data?.forceUpdate == false)
    }
    
    @Test("Test Value로 Device UUID 조회 - nil 반환 확인")
    func testGetDeviceUUID_WithTestValue_ReturnsNil() async throws {
        let repository = AppRepository.testValue
        
        let uuid = try await repository.getDeviceUUID()
        
        #expect(uuid == nil)
    }
    
    @Test("Test Value로 디바이스 모델 조회 - Mock 값 반환 확인")
    func testGetDeviceModel_WithTestValue_ReturnsMockModel() async throws {
        let repository = AppRepository.testValue
        
        let deviceModel = try await repository.getDeviceModel()
        
        #expect(deviceModel == "iPhone")
    }
    
    @Test("Test Value로 OS 버전 조회 - Mock 값 반환 확인")
    func testGetOSVersion_WithTestValue_ReturnsMockOSVersion() async throws {
        let repository = AppRepository.testValue
        
        let osVersion = try await repository.getOSVersion()
        
        #expect(osVersion == "17.0")
    }
    
    @Test("Live Value로 Device UUID 조회 - DeviceDataSource를 통해 실제 UUID 반환 확인")
    func testGetDeviceUUID_WithLiveValue_ReturnsUUID() async throws {
        let repository = AppRepository.liveValue
        
        let uuid = try await repository.getDeviceUUID()
        
        // identifierForVendor는 nil일 수 있지만, 일반적으로는 UUID를 반환함
        // UUID 형식 검증 (36자, 하이픈 포함)
        if let uuid = uuid {
            #expect(uuid.count == 36, "UUID는 36자여야 합니다")
            #expect(uuid.split(separator: "-").count == 5, "UUID는 5개의 하이픈으로 구분된 섹션을 가져야 합니다")
        }
    }
    
    @Test("Live Value Device UUID가 DeviceDataSource와 일치하는지 확인")
    func testGetDeviceUUID_WithLiveValue_MatchesDeviceDataSource() async throws {
        let repository = AppRepository.liveValue
        let deviceDataSource = DeviceDataSource.liveValue
        
        let repositoryUUID = try await repository.getDeviceUUID()
        let dataSourceUUID = try await deviceDataSource.getDeviceUUID()
        
        #expect(repositoryUUID == dataSourceUUID,
                "AppRepository가 반환한 UUID는 DeviceDataSource의 UUID와 일치해야 합니다")
    }
    
    @Test("Live Value로 디바이스 모델 조회 - DeviceDataSource를 통해 실제 모델 반환 확인")
    func testGetDeviceModel_WithLiveValue_ReturnsDeviceModel() async throws {
        let repository = AppRepository.liveValue
        
        let deviceModel = try await repository.getDeviceModel()
        
        // DeviceDataSource를 통해 실제 디바이스 모델을 읽어옴
        #expect(!deviceModel.isEmpty)
        // 일반적인 iOS 디바이스 모델 형식 검증
        #expect(deviceModel.contains("iPhone") || deviceModel.contains("iPad") || deviceModel.contains("iPod") || deviceModel.contains("Apple"))
    }
    
    @Test("Live Value로 OS 버전 조회 - DeviceDataSource를 통해 실제 OS 버전 반환 확인")
    func testGetOSVersion_WithLiveValue_ReturnsOSVersion() async throws {
        let repository = AppRepository.liveValue
        
        let osVersion = try await repository.getOSVersion()
        
        // DeviceDataSource를 통해 실제 OS 버전을 읽어옴
        #expect(!osVersion.isEmpty)
        // OS 버전 형식 검증 (예: "17.0" 형식)
        let versionComponents = osVersion.split(separator: ".")
        #expect(!versionComponents.isEmpty, "OS 버전은 최소한 하나의 컴포넌트를 가져야 합니다")
    }
    
    @Test("Live Value 디바이스 모델이 DeviceDataSource와 일치하는지 확인")
    func testGetDeviceModel_WithLiveValue_MatchesDeviceDataSource() async throws {
        let repository = AppRepository.liveValue
        let deviceDataSource = DeviceDataSource.liveValue
        
        let repositoryModel = try await repository.getDeviceModel()
        let dataSourceModel = try await deviceDataSource.getDeviceModel()
        
        #expect(repositoryModel == dataSourceModel,
                "AppRepository가 반환한 디바이스 모델은 DeviceDataSource의 디바이스 모델과 일치해야 합니다")
    }
    
    @Test("Live Value OS 버전이 DeviceDataSource와 일치하는지 확인")
    func testGetOSVersion_WithLiveValue_MatchesDeviceDataSource() async throws {
        let repository = AppRepository.liveValue
        let deviceDataSource = DeviceDataSource.liveValue
        
        let repositoryOSVersion = try await repository.getOSVersion()
        let dataSourceOSVersion = try await deviceDataSource.getOSVersion()
        
        #expect(repositoryOSVersion == dataSourceOSVersion,
                "AppRepository가 반환한 OS 버전은 DeviceDataSource의 OS 버전과 일치해야 합니다")
    }
    
    // MARK: - Custom Repository Tests
    
    @Test("커스텀 AppRepository 생성 및 값 반환 확인")
    func testCustomRepository_ReturnsCustomValues() async throws {
        let customVersion = "2.5.0"
        let customBuildNumber = "100"
        let customUUID = "12345678-1234-1234-1234-123456789ABC"
        let customDeviceModel = "iPhone 15 Pro"
        let customOSVersion = "18.0"
        
        let repository = AppRepository(
            getAppVersion: { customVersion },
            getBuildNumber: { customBuildNumber },
            checkAppVersion: { _ in AppVersionCheckResponse.mock },
            getDeviceUUID: { customUUID },
            getDeviceModel: { customDeviceModel },
            getOSVersion: { customOSVersion }
        )
        
        #expect(repository.getAppVersion() == customVersion)
        #expect(repository.getBuildNumber() == customBuildNumber)
        
        let uuid = try await repository.getDeviceUUID()
        #expect(uuid == customUUID)
        
        let deviceModel = try await repository.getDeviceModel()
        #expect(deviceModel == customDeviceModel)
        
        let osVersion = try await repository.getOSVersion()
        #expect(osVersion == customOSVersion)
    }
    
    @Test("여러 커스텀 AppRepository의 독립성 확인")
    func testCustomRepository_WithDifferentValues() async throws {
        let version1 = "3.0.0"
        let buildNumber1 = "200"
        let uuid1 = "11111111-1111-1111-1111-111111111111"
        let deviceModel1 = "iPhone 14"
        let osVersion1 = "16.0"
        
        let repository1 = AppRepository(
            getAppVersion: { version1 },
            getBuildNumber: { buildNumber1 },
            checkAppVersion: { _ in AppVersionCheckResponse.mock },
            getDeviceUUID: { uuid1 },
            getDeviceModel: { deviceModel1 },
            getOSVersion: { osVersion1 }
        )
        
        let version2 = "4.0.0"
        let buildNumber2 = "300"
        let uuid2 = "22222222-2222-2222-2222-222222222222"
        let deviceModel2 = "iPad Pro"
        let osVersion2 = "17.0"
        
        let repository2 = AppRepository(
            getAppVersion: { version2 },
            getBuildNumber: { buildNumber2 },
            checkAppVersion: { _ in AppVersionCheckResponse.mock },
            getDeviceUUID: { uuid2 },
            getDeviceModel: { deviceModel2 },
            getOSVersion: { osVersion2 }
        )
        
        // 각 Repository가 독립적으로 동작하는지 확인
        #expect(repository1.getAppVersion() == version1)
        #expect(repository1.getBuildNumber() == buildNumber1)
        let repo1UUID = try await repository1.getDeviceUUID()
        #expect(repo1UUID == uuid1)
        let repo1DeviceModel = try await repository1.getDeviceModel()
        #expect(repo1DeviceModel == deviceModel1)
        let repo1OSVersion = try await repository1.getOSVersion()
        #expect(repo1OSVersion == osVersion1)
        
        #expect(repository2.getAppVersion() == version2)
        #expect(repository2.getBuildNumber() == buildNumber2)
        let repo2UUID = try await repository2.getDeviceUUID()
        #expect(repo2UUID == uuid2)
        let repo2DeviceModel = try await repository2.getDeviceModel()
        #expect(repo2DeviceModel == deviceModel2)
        let repo2OSVersion = try await repository2.getOSVersion()
        #expect(repo2OSVersion == osVersion2)
    }
    
    // MARK: - DeviceDataSource Integration Tests
    
    @Test("Mock DeviceDataSource와 함께 사용 시 올바른 값 반환 확인")
    func testAppRepository_WithMockDeviceDataSource() async throws {
        let mockVersion = "5.0.0"
        let mockBuildNumber = "500"
        let mockDeviceModel = "iPhone 15"
        let mockOSVersion = "17.1"
        
        let mockDataSource = DeviceDataSource(
            getAppVersion: { mockVersion },
            getBuildNumber: { mockBuildNumber },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { mockDeviceModel },
            getOSVersion: { mockOSVersion }
        )
        
        let repository = AppRepository(
            getAppVersion: {
                mockDataSource.getAppVersion()
            },
            getBuildNumber: {
                mockDataSource.getBuildNumber()
            },
            checkAppVersion: { _ in AppVersionCheckResponse.mock },
            getDeviceUUID: {
                try await mockDataSource.getDeviceUUID()
            },
            getDeviceModel: {
                try await mockDataSource.getDeviceModel()
            },
            getOSVersion: {
                try await mockDataSource.getOSVersion()
            }
        )
        
        #expect(repository.getAppVersion() == mockVersion)
        #expect(repository.getBuildNumber() == mockBuildNumber)
        
        let uuid = try await repository.getDeviceUUID()
        #expect(uuid == "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        
        let deviceModel = try await repository.getDeviceModel()
        #expect(deviceModel == mockDeviceModel)
        
        let osVersion = try await repository.getOSVersion()
        #expect(osVersion == mockOSVersion)
    }
    
    @Test("AppRepository가 DeviceDataSource 변경에 반응하는지 확인")
    func testAppRepository_RespondsToDeviceDataSourceChanges() async throws {
        let version1 = "6.0.0"
        let buildNumber1 = "600"
        let deviceModel1 = "iPhone 13"
        let osVersion1 = "16.5"
        
        let dataSource1 = DeviceDataSource(
            getAppVersion: { version1 },
            getBuildNumber: { buildNumber1 },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { deviceModel1 },
            getOSVersion: { osVersion1 }
        )
        
        let repository1 = AppRepository(
            getAppVersion: { dataSource1.getAppVersion() },
            getBuildNumber: { dataSource1.getBuildNumber() },
            checkAppVersion: { _ in AppVersionCheckResponse.mock },
            getDeviceUUID: {
                try await dataSource1.getDeviceUUID()
            },
            getDeviceModel: {
                try await dataSource1.getDeviceModel()
            },
            getOSVersion: {
                try await dataSource1.getOSVersion()
            }
        )
        
        let version2 = "7.0.0"
        let buildNumber2 = "700"
        let deviceModel2 = "iPhone 15 Pro Max"
        let osVersion2 = "17.2"
        
        let dataSource2 = DeviceDataSource(
            getAppVersion: { version2 },
            getBuildNumber: { buildNumber2 },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { deviceModel2 },
            getOSVersion: { osVersion2 }
        )
        
        let repository2 = AppRepository(
            getAppVersion: { dataSource2.getAppVersion() },
            getBuildNumber: { dataSource2.getBuildNumber() },
            checkAppVersion: { _ in AppVersionCheckResponse.mock },
            getDeviceUUID: {
                try await dataSource2.getDeviceUUID()
            },
            getDeviceModel: {
                try await dataSource2.getDeviceModel()
            },
            getOSVersion: {
                try await dataSource2.getOSVersion()
            }
        )
        
        #expect(repository1.getAppVersion() == version1)
        #expect(repository1.getBuildNumber() == buildNumber1)
        let repo1UUID = try await repository1.getDeviceUUID()
        #expect(repo1UUID == "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        let repo1DeviceModel = try await repository1.getDeviceModel()
        #expect(repo1DeviceModel == deviceModel1)
        let repo1OSVersion = try await repository1.getOSVersion()
        #expect(repo1OSVersion == osVersion1)
        
        #expect(repository2.getAppVersion() == version2)
        #expect(repository2.getBuildNumber() == buildNumber2)
        let repo2UUID = try await repository2.getDeviceUUID()
        #expect(repo2UUID == "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        let repo2DeviceModel = try await repository2.getDeviceModel()
        #expect(repo2DeviceModel == deviceModel2)
        let repo2OSVersion = try await repository2.getOSVersion()
        #expect(repo2OSVersion == osVersion2)
    }
    
    // MARK: - CheckAppVersion Tests
    
    @Test("커스텀 AppRepository로 checkAppVersion 호출 - 커스텀 응답 반환 확인")
    func testCheckAppVersion_WithCustomRepository_ReturnsCustomResponse() async throws {
        let customResponse = AppVersionCheckResponse(
            success: true,
            data: AppVersionData(
                platform: "IOS",
                currentVersion: "1.0.0",
                latestVersion: "2.0.0",
                minimumVersion: "1.0.0",
                recommendedVersion: "1.5.0",
                updateType: "OPTIONAL",
                updateRequired: true,
                forceUpdate: false,
                message: "새로운 기능이 추가되었습니다.",
                storeUrl: "https://apps.apple.com/app/id123456789",
                releaseNotes: "- 새로운 기능 추가"
            ),
            code: "A001",
            message: nil
        )
        
        let repository = AppRepository(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            checkAppVersion: { _ in customResponse },
            getDeviceUUID: { nil },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        let response = try await repository.checkAppVersion("1.0.0")
        
        #expect(response.success == true)
        #expect(response.data?.latestVersion == "2.0.0")
        #expect(response.data?.updateRequired == true)
        #expect(response.data?.forceUpdate == false)
        #expect(response.data?.updateType == "OPTIONAL")
    }
    
    @Test("checkAppVersion - 강제 업데이트 필요 케이스")
    func testCheckAppVersion_ForceUpdateRequired() async throws {
        let forceUpdateResponse = AppVersionCheckResponse(
            success: true,
            data: AppVersionData(
                platform: "IOS",
                currentVersion: "1.0.0",
                latestVersion: "2.0.0",
                minimumVersion: "1.5.0",
                recommendedVersion: "2.0.0",
                updateType: "REQUIRED",
                updateRequired: true,
                forceUpdate: true,
                message: "강제 업데이트가 필요합니다.",
                storeUrl: "https://apps.apple.com/app/id123456789",
                releaseNotes: "- 보안 업데이트"
            ),
            code: "A001",
            message: nil
        )
        
        let repository = AppRepository(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            checkAppVersion: { _ in forceUpdateResponse },
            getDeviceUUID: { nil },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        let response = try await repository.checkAppVersion("1.0.0")
        
        #expect(response.data?.forceUpdate == true)
        #expect(response.data?.updateRequired == true)
        #expect(response.data?.updateType == "REQUIRED")
        #expect(response.data?.message == "강제 업데이트가 필요합니다.")
    }
    
    @Test("checkAppVersion - 업데이트 불필요 케이스")
    func testCheckAppVersion_NoUpdateRequired() async throws {
        let noUpdateResponse = AppVersionCheckResponse(
            success: true,
            data: AppVersionData(
                platform: "IOS",
                currentVersion: "2.0.0",
                latestVersion: "2.0.0",
                minimumVersion: "1.0.0",
                recommendedVersion: "2.0.0",
                updateType: "NONE",
                updateRequired: false,
                forceUpdate: false,
                message: nil,
                storeUrl: nil,
                releaseNotes: nil
            ),
            code: "A001",
            message: nil
        )
        
        let repository = AppRepository(
            getAppVersion: { "2.0.0" },
            getBuildNumber: { "1" },
            checkAppVersion: { _ in noUpdateResponse },
            getDeviceUUID: { nil },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        let response = try await repository.checkAppVersion("2.0.0")
        
        #expect(response.data?.updateRequired == false)
        #expect(response.data?.forceUpdate == false)
        #expect(response.data?.updateType == "NONE")
        #expect(response.data?.currentVersion == "2.0.0")
        #expect(response.data?.latestVersion == "2.0.0")
    }
    
    @Test("checkAppVersion - 다양한 버전으로 호출 시 올바른 응답 반환")
    func testCheckAppVersion_WithDifferentVersions() async throws {
        let repository = AppRepository(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            checkAppVersion: { currentVersion in
                AppVersionCheckResponse(
                    success: true,
                    data: AppVersionData(
                        platform: "IOS",
                        currentVersion: currentVersion,
                        latestVersion: "2.0.0",
                        minimumVersion: "1.0.0",
                        recommendedVersion: "1.5.0",
                        updateType: currentVersion == "1.0.0" ? "OPTIONAL" : "NONE",
                        updateRequired: currentVersion != "2.0.0",
                        forceUpdate: false,
                        message: nil,
                        storeUrl: nil,
                        releaseNotes: nil
                    ),
                    code: "A001",
                    message: nil
                )
            },
            getDeviceUUID: { nil },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        let response1 = try await repository.checkAppVersion("1.0.0")
        #expect(response1.data?.currentVersion == "1.0.0")
        #expect(response1.data?.updateRequired == true)
        
        let response2 = try await repository.checkAppVersion("2.0.0")
        #expect(response2.data?.currentVersion == "2.0.0")
        #expect(response2.data?.updateRequired == false)
    }
    
    // MARK: - Preview Value Tests
    
    @Test("Preview Value가 Test Value와 동일한지 확인")
    func testPreviewValue_ReturnsTestValue() async throws {
        let previewRepository = AppRepository.previewValue
        let testRepository = AppRepository.testValue
        
        // previewValue는 testValue를 반환해야 함
        #expect(previewRepository.getAppVersion() == testRepository.getAppVersion())
        #expect(previewRepository.getBuildNumber() == testRepository.getBuildNumber())
        
        // checkAppVersion도 동일한지 확인
        let previewResponse = try await previewRepository.checkAppVersion("1.0.0")
        let testResponse = try await testRepository.checkAppVersion("1.0.0")
        #expect(previewResponse == testResponse)
        
        // getDeviceUUID도 동일한지 확인
        let previewUUID = try await previewRepository.getDeviceUUID()
        let testUUID = try await testRepository.getDeviceUUID()
        #expect(previewUUID == testUUID)
        
        // getDeviceModel도 동일한지 확인
        let previewDeviceModel = try await previewRepository.getDeviceModel()
        let testDeviceModel = try await testRepository.getDeviceModel()
        #expect(previewDeviceModel == testDeviceModel)
        
        // getOSVersion도 동일한지 확인
        let previewOSVersion = try await previewRepository.getOSVersion()
        let testOSVersion = try await testRepository.getOSVersion()
        #expect(previewOSVersion == testOSVersion)
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("다중 스레드 환경에서의 스레드 안전성 확인")
    func testRepository_IsThreadSafe() async {
        let repository = AppRepository.liveValue
        
        // 여러 스레드에서 동시에 호출해도 안전한지 확인
        await withTaskGroup(of: String.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    return repository.getAppVersion()
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
    
    @Test("빌드 번호 다중 스레드 안전성 확인")
    func testRepository_BuildNumberIsThreadSafe() async {
        let repository = AppRepository.liveValue
        
        await withTaskGroup(of: String.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    return repository.getBuildNumber()
                }
            }
            
            var buildNumbers: [String] = []
            for await buildNumber in group {
                buildNumbers.append(buildNumber)
            }
            
            let firstBuildNumber = buildNumbers.first
            #expect(firstBuildNumber != nil)
            #expect(buildNumbers.allSatisfy { $0 == firstBuildNumber },
                    "모든 스레드에서 동일한 빌드 번호를 반환해야 합니다")
        }
    }
    
    // MARK: - Parameterized Tests
    
    @Test("다양한 버전 형식으로 커스텀 AppRepository 테스트", arguments: repositoryValues)
    func testCustomRepository_VariousValues(version: String, buildNumber: String) async throws {
        let repository = AppRepository(
            getAppVersion: { version },
            getBuildNumber: { buildNumber },
            checkAppVersion: { _ in AppVersionCheckResponse.mock },
            getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        #expect(repository.getAppVersion() == version)
        #expect(repository.getBuildNumber() == buildNumber)
    }
    
    @Test("다양한 버전으로 checkAppVersion 테스트", arguments: checkAppVersionTestCases)
    func testCheckAppVersion_VariousVersions(currentVersion: String, expectedUpdateRequired: Bool) async throws {
        let repository = AppRepository(
            getAppVersion: { "1.0.0" },
            getBuildNumber: { "1" },
            checkAppVersion: { version in
                AppVersionCheckResponse(
                    success: true,
                    data: AppVersionData(
                        platform: "IOS",
                        currentVersion: version,
                        latestVersion: "2.0.0",
                        minimumVersion: "1.0.0",
                        recommendedVersion: "1.5.0",
                        updateType: expectedUpdateRequired ? "OPTIONAL" : "NONE",
                        updateRequired: expectedUpdateRequired,
                        forceUpdate: false,
                        message: expectedUpdateRequired ? "업데이트가 권장됩니다." : nil,
                        storeUrl: expectedUpdateRequired ? "https://apps.apple.com/app/id123456789" : nil,
                        releaseNotes: nil
                    ),
                    code: "A001",
                    message: nil
                )
            },
            getDeviceUUID: { nil },
            getDeviceModel: { "iPhone" },
            getOSVersion: { "17.0" }
        )
        
        let response = try await repository.checkAppVersion(currentVersion)
        #expect(response.data?.currentVersion == currentVersion)
        #expect(response.data?.updateRequired == expectedUpdateRequired)
    }
    
    // MARK: - Arguments for Parameterized Test
    
    static var repositoryValues: [(String, String)] {
        [
            ("1.0.0", "1"),
            ("2.5.3", "42"),
            ("10.0.0", "100"),
            ("0.1.0", "0"),
            ("99.99.99", "9999")
        ]
    }
    
    static var checkAppVersionTestCases: [(String, Bool)] {
        [
            ("1.0.0", true),   // 업데이트 필요
            ("1.5.0", true),   // 업데이트 필요
            ("2.0.0", false),  // 업데이트 불필요
            ("2.1.0", false)   // 업데이트 불필요
        ]
    }
}
