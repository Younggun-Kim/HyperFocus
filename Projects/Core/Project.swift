import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Core",
  targets: [
    .make(
      name: TargetName.models.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Core.Models",
      sources: ["Models/Sources/**"]
    ),
    .make(
      name: TargetName.services.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Core.Services",
      sources: ["Services/Sources/**"],
      dependencies: [
        .target(name: .models)
      ]
    ),
    .make(
      name: TargetName.common.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Core.Common",
      sources: ["Common/Sources/**"]
    ),
    .make(
      name: TargetName.coreKit.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Core.CoreKit",
      sources: ["CoreKit/Sources/**"],
      dependencies: [
        .target(name: .models),
        .target(name: .services),
        .target(name: .common)
      ]
    )
  ]
)
