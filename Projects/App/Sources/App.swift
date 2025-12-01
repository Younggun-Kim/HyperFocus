import SwiftUI
import Common
import DesignSystem

public struct HyperFocusRootView: View {
  private let greeting = CommonGreeting()

  public init() {}

  public var body: some View {
    VStack(spacing: 12) {
      Text(greeting.message())
        .font(.headline)
      Button("Tap me") {}
        .buttonStyle(DesignSystemButtonStyle())
    }
  }
}
