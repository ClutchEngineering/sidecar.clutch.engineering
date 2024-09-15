import Foundation

import Slipstream

extension Home {
  struct Hero: View {
    var body: some View {
      Comment("Hero")
      ContentContainer {
        Div {
          HeroIconPuck(url: URL(string: "/gfx/appicon.gif")!)

          VStack(alignment: .center, spacing: 16) {
            VStack(alignment: .center) {
              H1("Sidecar")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Paragraph("Your personal automotive assistant")
                .fontSize(.extraLarge)
                .fontSize(.extraExtraLarge, condition: .desktop)
            }

            Paragraph {
              DOMString("Stay in tune with your car")
              Span {
                DOMString("both on and off the road")
              }
              .display(.block)
            }
            .fontSize(.extraLarge)
            .fontSize(.extraExtraLarge, condition: .desktop)

            AppStoreLink()
              .hidden(condition: .desktop)

            Link(URL(string: "https://discord.gg/9QhpesqTSM")!) {
              Image(URL(string: "https://dcbadge.limes.pink/api/server/https://discord.gg/9QhpesqTSM?style=plastic")!)
                .accessibilityLabel("Join the Sidecar Discord server")
            }
          }
          .margin(.bottom, 16)
        }
        .padding(.vertical, 16)
        .textAlignment(.center)
      }
    }
  }
}
