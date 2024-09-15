import Foundation

import Slipstream

struct AppStoreLink: View {
  var body: some View {
    Link(URL(string: "https://apps.apple.com/us/app/electric-sidecar/id1663683832")!, openInNewTab: true) {
      Image(URL(string: "/gfx/AppStore.png")!)
        .accessibilityLabel("Download Sidecar from the App Store")
        .frame(maxHeight: 40)
    }
  }
}
