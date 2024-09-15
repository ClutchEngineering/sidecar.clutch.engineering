import Foundation

import Slipstream

extension Home {
  struct Subfeature: View {
    init(_ text: String, image: URL, accessibilityLabel: String) {
      self.text = text
      self.image = image
      self.accessibilityLabel = accessibilityLabel
    }

    let text: String
    let image: URL
    let accessibilityLabel: String

    var body: some View {
      VStack(alignment: .center) {
        Image(image)
          .accessibilityLabel(accessibilityLabel)
          .colorInvert(condition: .dark)
          .frame(height: 32)
          .margin(.bottom, 8)
        Paragraph(text)
          .fontSize(.base, condition: .desktop)
          .fontSize(.small)
          .fontLeading(.tight)
      }
      .textAlignment(.center)
    }
  }
}
