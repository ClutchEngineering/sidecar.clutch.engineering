import Foundation

import Slipstream

extension Home {
  struct FocusOnTheJourney: View {
    var body: some View {
      Comment("Focus on the journey")
      Div {
        ContentContainer {
          ResponsiveStack {
            Div {
              Image(URL(string: "/gfx/hero.png")!)
                .accessibilityLabel("Sidecar running on an iPhone with features like battery history and trip efficiency statistics")
            }
            .padding(.horizontal, 16)
            .margin(.bottom, 32)
            .margin(.bottom, 0, condition: .desktop)
            .frame(width: 0.5, condition: .desktop)

            Div {
              H2("Focus on the journey")
                .fontSize(.extraExtraExtraLarge)
                .bold()
                .fontDesign("rounded")
                .margin(.bottom, 8)
              H3("Let Sidecar do the rest")
                .fontSize(.extraLarge)
                .fontSize(.extraExtraLarge, condition: .desktop)
                .fontDesign("rounded")
                .margin(.bottom, 24)
              Image(URL(string: "/gfx/journey.png")!)
                .accessibilityLabel("Sidecar's vehicle screen, Porsche Taycan with 88% charge, battery history widget and recent trip details")
                .margin(.bottom, 32)
                .margin(.top, -80)
                .margin(.top, -96, condition: .desktop)
              HStack(alignment: .center) {
                Image(URL(string: "/gfx/hero-watch-1.png")!)
                  .accessibilityLabel("Read tire pressure from your Apple Watch")
                  .frame(height: 128)
                  .frame(height: 192, condition: .desktop)
                  .margin(.top, -96)
                Image(URL(string: "/gfx/hero-watch-2.png")!)
                  .accessibilityLabel("See the state of multiple vehicles on your Apple Watch")
                  .frame(height: 128)
                  .frame(height: 192, condition: .desktop)
                  .margin(.top, -48)
                Image(URL(string: "/gfx/hero-watch-3.png")!)
                  .accessibilityLabel("Run commands for Connected Accounts from your Apple Watch")
                  .frame(height: 128)
                  .frame(height: 192, condition: .desktop)
              }
              .alignItems(.start, condition: .desktop)
              //            .flex(horizontalAlignment: .center)
              //            .justify(.start, condition: .desktop)
            }
            .frame(width: 0.5, condition: .desktop)
            .textAlignment(.right)
          }
          .alignItems(.center)
        }
//        .flex(horizontalAlignment: .between, verticalAlignment: .center, direction: .column)
//        .flex(direction: .row, condition: .desktop)
        .padding(.vertical, 48)
      }
      .background("sidecar-gray")
      .textColor(.white)
    }
  }
}
