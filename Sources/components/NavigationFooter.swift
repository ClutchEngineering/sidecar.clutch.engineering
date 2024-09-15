import Foundation

import Slipstream
import SwiftSoup

struct NavigationFooter: View {
  var body: some View {
    Footer {
      Container {
        VStack(alignment: .leading, spacing: 16) {
          Paragraph("Apple Watch, watchOS and iPhone are trademarks of Apple Inc., registered in the U.S. and other countries and regions.")
          Paragraph("Third party logos and brand names are used for information purposes only and do not necessarily indicate affiliation with Sidecar.")
          Paragraph("Copyright © \(Calendar.current.component(.year, from: Date())) fearless design, LLC. All rights reserved.")
        }
      }
    }
    .background("sidecar-gray")
    .textColor(.white)
    .padding(.vertical, 32)
  }
}
