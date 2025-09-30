import Foundation

import Slipstream

struct RedeemBetaCode: View {
  var body: some View {
    Page(
      "Redeem your Sidecar beta code",
      path: "/beta/redeem/",
      description: "Redeem a Sidecar beta code.",
      keywords: [
        "OBD-II",
        "beta testing",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ],
      scripts: [URL(string: "/scripts/redeem.js")],
    ) {
      Container {
        VStack(alignment: .center) {
          HeroIconPuck(url: URL(string: "/gfx/appicon.gif")!)

          VStack(alignment: .center, spacing: 16) {
            Div {
              H2("Your Sidecar beta code")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")

              Text("Thank you for testing Sidecar!")
                .fontSize(.large)
            }
            .textAlignment(.center)
          }
        }
        .padding(.vertical, 16)
      }

      ContentContainer {
        VStack(alignment: .center) {
          VStack(alignment: .center, spacing: 16) {
            Text("Use the code below to redeem your subscription.")
              .fontSize(.large)
            VStack(alignment: .center) {
              HStack(spacing: 8) {
                H1("placeholder")
                  .fontSize(.fourXLarge)
                  .bold()
                  .fontDesign(.monospaced)
                  .padding(16)
                  .background(.gray, darkness: 0)
                  .border(.palette(.gray, darkness: 300))
                  .cornerRadius(.medium)
                  .textColor(.gray, darkness: 900)
                  .id("code")

                Image(URL(string: "/gfx/copy.svg"))
                  .frame(width: 32, height: 32)
                  .pointerStyle(.pointer)
                  .colorInvert(condition: .dark)
                  .opacity(1.0)
                  .opacity(0.8, condition: .hover)
                  .opacity(1.0, condition: .active)
                  .id("copy-code-button")
              }
              .textAlignment(.center)

              Text("Copied!")
                .fontSize(.large)
                .fontWeight(600)
                .textColor(.text, darkness: 600)
                .id("copied-message")
                .opacity(0)
                .animation(.easeInOut)
                .position(.absolute)
                .placement(bottom: 0)
            }
            .position(.relative)
            .padding(.bottom, 32)

            Link("Redeem in the App Store", destination: URL(string: "https://apps.apple.com/redeem?ctx=offercodes&id=1663683832&code=placeholder"))
              .id("redeem-link")
              .textColor(.link, darkness: 700)
              .opacity(0.8, condition: .hover)
              .fontSize(.large)
              .fontWeight(500)
          }
          .padding(.vertical, 32)
          .textAlignment(.center)
        }
      }
      .margin(.bottom, 16)
    }
  }
}
