import Foundation

import Slipstream

extension Home {
  struct ThoughtfullyAccessible: View {
    var body: some View {
      Comment("Thoughtfully accessible")
      FeatureRow(imageOnLeft: true) {
        FeatureScreenshot(
          URL(string: "/gfx/accessible.png")!,
          accessibilityLabel: "Sidecar is deeply integrated with iOS features"
        )
      } explanation: {
        Div {
          FeatureCardHeader("Thoughtfully Accessible")
          FeatureCardSubheadline("Designed to meet a wide range of needs")
        }
        .textAlignment(.center)

        SubfeatureRow {
          Subfeature(
            "Dynamic Type",
            image: URL(string: "/gfx/symbols/textformat.size.png")!,
            accessibilityLabel: "Dynamic Type"
          )
          Subfeature(
            "Bold Text",
            image: URL(string: "/gfx/symbols/bold.png")!,
            accessibilityLabel: "Bold Text"
          )
        }

        SubfeatureRow {
          Subfeature(
            "Dark Mode",
            image: URL(string: "/gfx/symbols/circle.righthalf.filled.png")!,
            accessibilityLabel: "Dark Mode"
          )
          Subfeature(
            "VoiceOver",
            image: URL(string: "/gfx/symbols/voiceover.png")!,
            accessibilityLabel: "VoiceOver"
          )
        }
      }
    }
  }
}
