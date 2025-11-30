import SwiftUI

public enum DSColor {
  public static let primary = Color.accentColor
  public static let background = Color(.systemBackground)
}

public enum DSButtonStyle {
  public static func primary() -> some ButtonStyle {
    .borderedProminent
  }
}
