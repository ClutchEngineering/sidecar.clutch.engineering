import Foundation

import Slipstream

struct HeroIconPuck: View {
  let url: URL?
  var body: some View {
    Puck {
      Image(url)
        .accessibilityLabel("Sidecar app icon")
        .background("sidecar-gray")
        .frame(width: 112, height: 112)
        .margin(.horizontal, .auto)
        .margin(.top, 8)
        .margin(.bottom, 24)
        .cornerRadius(.extraExtraExtraLarge)
    }
    .border(.white, width: 4)
    .border(.init(.zinc, darkness: 700), condition: .dark)
  }
}
