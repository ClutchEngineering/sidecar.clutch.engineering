import Foundation

import Slipstream
import SwiftSoup

struct NavigationFooter: View {
  var body: some View {
    Footer {
      Container {
        VStack(alignment: .leading, spacing: 16) {
          Text("Apple Watch, watchOS and iPhone are trademarks of Apple Inc., registered in the U.S. and other countries and regions.")
          Text("Third party logos and brand names are used for information purposes only and do not necessarily indicate affiliation with Sidecar or Clutch Engineering.")
          Text {
            DOMString("Copyright © \(Calendar.current.component(.year, from: Date())) ")
            Link("Clutch Engineering", destination: URL(string: "https://clutch.engineering"))
              .textColor(.link, darkness: 300)
              .fontWeight(.medium)
              .underline(condition: .hover)
            DOMString(". All rights reserved.")
          }
        }
      }
    }
    .background("sidecar-gray")
    .textColor(.white)
    .padding(.vertical, 32)
  }
}
