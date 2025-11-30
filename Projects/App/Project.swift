import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "App",
  targets: [
    .make(
      name: "HyperFocus",
      product: .app,
      bundleId: "com.conner.HyperFocus",
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: .appCoordinator, projectPath: .coordinator),
        .project(target: .designSystem, projectPath: .designSystem),
        .project(target: .coreKit, projectPath: .core)
      ]
    )
  ]
)
