import Foundation

import Slipstream

extension Home {
  struct FeatureScreenshot: View {
    init(_ imageURL: URL, accessibilityLabel: String) {
      self.imageURL = imageURL
      self.accessibilityLabel = accessibilityLabel
    }

    let imageURL: URL
    let accessibilityLabel: String

    var body: some View {
      Div {
        Image(imageURL)
          .accessibilityLabel(accessibilityLabel)
          .margin(.horizontal, .auto)
          .margin(.horizontal, 0, condition: .desktop)
      }
      .padding(16)
      .padding(32, condition: .desktop)
      .margin(.bottom, 32)
      .margin(.bottom, 0, condition: .desktop)
      .frame(width: 0.5, condition: .desktop)
    }
  }
}
