import Foundation
import Slipstream

struct News_2025_10_23_NavigationWidgetsComparison: View {

  var body: some View {
    HStack(spacing: 8) {
      VStack(alignment: .center) {
        Text("Without Sidecar navigation widgets")
          .bold()
        Text("Teeeny tiny map area")
          .fontSize(.small)
          .italic()
          .padding(.bottom, 8)

        Image(URL(string: "/gfx/news/2025/10/carplay-navigation-before.png"))
      }
      VStack(alignment: .center) {
        Text("Without Sidecar navigation widgets")
          .bold()
        Text("The canvas if fully yours")
          .fontSize(.small)
          .italic()
          .padding(.bottom, 8)

        Image(URL(string: "/gfx/news/2025/10/carplay-navigation-after.png"))
      }
    }
    .padding(.vertical, 16)
  }
}
