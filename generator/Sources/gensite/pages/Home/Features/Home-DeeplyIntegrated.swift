import Foundation

import Slipstream

extension Home {
  struct DeeplyIntegrated: View {
    var body: some View {
      Comment("Deeply integrated")
      FeatureRow(imageOnLeft: true) {
        FeatureScreenshot(
          URL(string: "/gfx/integrated.png")!,
          accessibilityLabel: "Sidecar is deeply integrated with iOS features"
        )
      } explanation: {
        Div {
          FeatureCardHeader("Deeply Integrated")
          FeatureCardSubheadline("Make the best use of your connected devices")
        }
        .textAlignment(.center)

        SubfeatureRow {
          Subfeature(
            "Accessibility",
            image: URL(string: "/gfx/symbols/accessibility.png")!,
            accessibilityLabel: "Accessible"
          )
          Subfeature(
            "Siri shortcuts",
            image: URL(string: "/gfx/symbols/waveform.png")!,
            accessibilityLabel: "Siri shortcuts"
          )
          Subfeature(
            "Watch app",
            image: URL(string: "/gfx/symbols/applewatch.png")!,
            accessibilityLabel: "Apple watch"
          )
        }

        SubfeatureRow {
          Subfeature(
            "Live Activities",
            image: URL(string: "/gfx/symbols/platter.filled.bottom.iphone.png")!,
            accessibilityLabel: "Live Activities"
          )
          Subfeature(
            "Complications",
            image: URL(string: "/gfx/symbols/watchface.applewatch.case.png")!,
            accessibilityLabel: "Complications"
          )
          Subfeature(
            "Widgets",
            image: URL(string: "/gfx/symbols/square.grid.3x3.square.png")!,
            accessibilityLabel: "Widgets"
          )
        }

        Image(URL(string: "/gfx/complications.png")!)
          .accessibilityLabel("Watch complications")
          .frame(height: 240)
          .margin(.horizontal, .auto)
      }
    }
  }
}
