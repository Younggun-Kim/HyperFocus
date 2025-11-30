import SwiftUI
import CoreKit

public struct KakaoLoginView: View {
  private let environment: CoreEnvironment

  public init(environment: CoreEnvironment = CoreEnvironment()) {
    self.environment = environment
  }

  public var body: some View {
    VStack(spacing: 8) {
      Text("Kakao Login")
      Text("Service injected: \(String(describing: type(of: environment.todoService)))")
        .font(.footnote)
    }
  }
}
