import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Core",
  targets: [
    .make(
      name: TargetName.common.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Core.Common",
      sources: ["Common/Sources/**"]
    ),
  ]
)
