import SwiftUI

public struct DesignSystemButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding()
      .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor.opacity(configuration.isPressed ? 0.6 : 1)))
      .foregroundStyle(.white)
  }
}
