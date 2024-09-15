import Foundation

import Slipstream

extension Home {
  struct FeatureCardSubheadline: View {
    init(_ text: String) {
      self.text = text
    }

    let text: String
    var body: some View {
      Paragraph(text)
        .fontSize(.large, condition: .desktop)
    }
  }
}
