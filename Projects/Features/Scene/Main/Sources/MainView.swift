import SwiftUI
import DesignSystem
import CoreKit

public struct MainView: View {
  private let environment: CoreEnvironment

  public init(environment: CoreEnvironment = CoreEnvironment()) {
    self.environment = environment
  }

  public var body: some View {
    VStack(spacing: 12) {
      Text("Main Scene")
        .font(.headline)
      Button("Load tasks") {}
        .buttonStyle(DSButtonStyle.primary())
    }
    .padding()
    .background(DSColor.background)
  }
}
