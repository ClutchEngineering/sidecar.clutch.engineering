import Foundation

import Slipstream

struct FeaturesBreadcrumb: View {
  @Environment(\.path) var path

  var body: some View {
    if !path.hasPrefix("/features") {
      ContentContainer {
        HStack(spacing: 16) {
          NavigationLink(URL(string: "/scanning"), text: "Scanning")
          NavigationLink(URL(string: "/shortcuts"), text: "Shortcuts")
          NavigationLink(URL(string: "/leaderboard"), text: "Leaderboard")
          NavigationLink(URL(string: "/beta"), text: "Beta")
        }
        .justifyContent(.end)
        .padding(.vertical, 8)
      }
    }
  }
}
