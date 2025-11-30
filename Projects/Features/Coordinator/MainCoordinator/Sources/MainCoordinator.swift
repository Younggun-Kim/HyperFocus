import SwiftUI
import Main
import KakaoLogin
import CoreKit

public struct MainCoordinatorView: View {
  private let environment: CoreEnvironment

  public init(environment: CoreEnvironment) {
    self.environment = environment
  }

  public var body: some View {
    TabView {
      MainView(environment: environment)
        .tabItem { Label("Home", systemImage: "house.fill") }
      KakaoLoginView(environment: environment)
        .tabItem { Label("Kakao", systemImage: "person.crop.circle") }
    }
  }
}
