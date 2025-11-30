// swift-tools-version:5.9
/**
 * 외부 종속성을 선언하는 인터페이스
 */
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings (
        productTypes: [
            "Alamofire": .framework,
        ]
    )
#endif

let package = Package(
    name: "HyperFocus",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
    ]
)
