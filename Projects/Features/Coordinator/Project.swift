import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Coordinator",
  targets: [
    .make(
      name: TargetName.mainCoordinator.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Features.Coordinator.Main",
      sources: ["MainCoordinator/Sources/**"],
      dependencies: [
        .project(target: .main, projectPath: .scene),
        .project(target: .kakaoLogin, projectPath: .scene),
        .project(target: .coreKit, projectPath: .core)
      ]
    ),
    .make(
      name: TargetName.appCoordinator.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Features.Coordinator.App",
      sources: ["AppCoordinator/Sources/**"],
      dependencies: [
        .target(name: .mainCoordinator),
        .project(target: .designSystem, projectPath: .designSystem),
        .project(target: .coreKit, projectPath: .core)
      ]
    )
  ]
)
