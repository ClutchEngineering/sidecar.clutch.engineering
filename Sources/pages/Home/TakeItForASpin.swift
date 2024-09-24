import Foundation

import Slipstream

struct TakeItForASpin: View {
  let subtitle: String

  init(subtitle: String = "Take it for a spin with a 2 week free trial") {
    self.subtitle = subtitle
  }

  var body: some View {
    Container {
      VStack(alignment: .center) {
        HeroIconPuck(url: URL(string: "/gfx/appicon.gif")!)

        VStack(alignment: .center, spacing: 16) {
          Div {
            H2("Sidecar")
              .fontSize(.fourXLarge)
              .bold()
              .fontDesign("rounded")
            Text(subtitle)
              .fontSize(.extraLarge)
              .fontSize(.extraExtraLarge, condition: .desktop)
          }
          .textAlignment(.center)

          AppStoreLink()
        }
      }
      .margin(.bottom, 64)
    }
  }
}
