import Foundation

import Slipstream

extension Home {
  struct FeatureCardHeader: View {
    init(_ text: String) {
      self.text = text
    }
    
    let text: String
    var body: some View {
      H2(text)
        .fontSize(.extraExtraExtraLarge)
        .bold()
        .fontDesign("rounded")
    }
  }
}
