import SwiftUI
import Common
import DesignSystem

@main
public struct HyperFocusApp: App {
  public init() {}

  public var body: some Scene {
    WindowGroup {
      HyperFocusRootView()
    }
  }
}

public struct HyperFocusRootView: View {
  private let greeting = CommonGreeting()
  @State private var selectedTab: Tab = .home

  private enum Tab: Hashable {
    case home
    case focus
    case settings
  }

  public init() {}

  public var body: some View {
    TabView(selection: $selectedTab) {
      home
        .tag(Tab.home)
        .tabItem {
          Label("홈", systemImage: "house.fill")
        }

      focus
        .tag(Tab.focus)
        .tabItem {
          Label("집중", systemImage: "timer")
        }

      settings
        .tag(Tab.settings)
        .tabItem {
          Label("설정", systemImage: "gearshape")
        }
    }
  }

  private var home: some View {
    VStack(spacing: 12) {
      Text(greeting.message())
        .font(.headline)
      Button("Tap me") {}
        .buttonStyle(DesignSystemButtonStyle())
    }
  }

  private var focus: some View {
    VStack(spacing: 16) {
      Image(systemName: "target")
        .font(.largeTitle)
      Text("집중 세션을 시작하세요")
        .font(.headline)
    }
  }

  private var settings: some View {
    VStack(spacing: 16) {
      Image(systemName: "slider.horizontal.3")
        .font(.largeTitle)
      Text("환경 설정")
        .font(.headline)
    }
  }
}
