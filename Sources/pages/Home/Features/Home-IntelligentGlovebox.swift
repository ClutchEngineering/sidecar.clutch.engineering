import Foundation

import Slipstream

extension Home {
  struct IntelligentGlovebox: View {
    var body: some View {
      Comment("Intelligent glovebox")
      FeatureRow(imageOnLeft: false) {
        FeatureScreenshot(
          URL(string: "/gfx/glovebox.png")!,
          accessibilityLabel: "Scan and import documents"
        )
      } explanation: {
        Div {
          FeatureCardHeader("Intelligent Glovebox")
          FeatureCardSubheadline("Secure document scanning with on-device vision")
        }
        .textAlignment(.center)

        SubfeatureRow {
          Subfeature(
            "Scan and import documents",
            image: URL(string: "/gfx/symbols/text.stamp.on.text.rectangle.angled.fill.badge.plus.png")!,
            accessibilityLabel: "Scan and import documents"
          )
          Subfeature(
            "Automatically extracts dates, VINs, and barcodes",
            image: URL(string: "/gfx/symbols/sparkles.png")!,
            accessibilityLabel: "Automatic extraction"
          )
        }
      }
    }
  }
}
