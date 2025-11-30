import SwiftUI
import MainCoordinator
import DesignSystem
import CoreKit

public struct AppCoordinatorView: View {
  public init() {}

  public var body: some View {
    NavigationStack {
      MainCoordinatorView(environment: CoreEnvironment())
        .navigationTitle("HyperFocus")
        .toolbarBackground(DSColor.background, for: .navigationBar)
    }
  }
}
