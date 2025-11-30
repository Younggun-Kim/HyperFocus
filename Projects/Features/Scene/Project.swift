import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Scene",
  targets: [
    .make(
      name: TargetName.main.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Features.Scene.Main",
      sources: ["Main/Sources/**"],
      dependencies: [
        .project(target: .designSystem, projectPath: .designSystem),
        .project(target: .coreKit, projectPath: .core)
      ]
    ),
    .make(
      name: TargetName.kakaoLogin.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Features.Scene.KakaoLogin",
      sources: ["KakaoLogin/Sources/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core)
      ]
    )
  ]
)
