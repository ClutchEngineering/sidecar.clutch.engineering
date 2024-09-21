iimport Foundation

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
              Text("Your personal automotive assistant")
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
          }
          .margin(.bottom, 16)
        }
        .padding(.vertical, 16)
        .textAlignment(.center)
      }
    }
  }
}
