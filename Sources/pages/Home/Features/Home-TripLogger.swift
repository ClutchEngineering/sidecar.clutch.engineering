import Foundation

import Slipstream

extension Home {
  struct TripLogger: View {
    var body: some View {
      let header = Div {
        FeatureCardHeader("Trip Logger & OBD Scanner")
        FeatureCardSubheadline("Effortless journey history & detailed statistics")
      }.textAlignment(.center)

      Comment("Trip logger & OBD scanner")
      Container {
        header
          .hidden(condition: .desktop)

        ResponsiveStack {
          FeatureScreenshot(
            URL(string: "/gfx/triplogger.png")!,
            accessibilityLabel: "Sidecar's trip logger shows historical trip information"
          )

          Feature {
            header
              .hidden()
              .display(.block, condition: .desktop)

            SubfeatureRow {
              Subfeature(
                "Heavily optimized for all-day use",
                image: URL(string: "/gfx/symbols/clock.arrow.2.circlepath.png")!,
                accessibilityLabel: "Optimized daily use"
              )
              Subfeature(
                "Intelligently detects when trips begin and end",
                image: URL(string: "/gfx/symbols/switch.2.png")!,
                accessibilityLabel: "Intelligent trip detection"
              )
            }

            SubfeatureRow {
              Subfeature(
                "Tracks historic trip economy statistics",
                image: URL(string: "/gfx/symbols/chart.bar.xaxis.png")!,
                accessibilityLabel: "Trip economy"
              )
              Subfeature(
                "Connects to your OBD scanner for detailed logs",
                image: URL(string: "/gfx/symbols/obdii.plug.filled.png")!,
                accessibilityLabel: "OBD scanning"
              )
            }
          }
        }
      }
//      .flex(horizontalAlignment: .between, verticalAlignment: .center, direction: .column)
//      .flex(direction: .row, condition: .desktop)
      .padding(.vertical, 48)
    }
  }
}
