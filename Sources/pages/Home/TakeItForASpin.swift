import Foundation

import Slipstream

extension Home {
  struct TakeItForASpin: View {
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
              Text("Take it for a spin with a 2 week free trial")
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
}
