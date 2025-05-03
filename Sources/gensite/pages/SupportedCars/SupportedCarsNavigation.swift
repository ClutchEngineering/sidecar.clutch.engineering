import Foundation

import Slipstream

struct SupportedCarsNavigation: View {
  var body: some View {
    ContentContainer {
      HStack(spacing: 16) {
        NavigationLink(URL(string: "/leaderboard"), text: "Leaderboard")
      }
      .justifyContent(.end)
      .padding(.vertical, 8)
    }
  }
}