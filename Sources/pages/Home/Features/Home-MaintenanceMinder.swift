import Foundation

import Slipstream

extension Home {
  struct MaintenanceMinder: View {
    var body: some View {
      Comment("Maintenance minder")
      FeatureRow(imageOnLeft: false) {
        FeatureScreenshot(
          URL(string: "/gfx/maintenance-minder.png")!,
          accessibilityLabel: "Sidecar delivers full recall notices to your phone"
        )
      } explanation: {
        Div {
          FeatureCardHeader("Maintenance Minder")
          FeatureCardSubheadline("Take care of your car so it can take care of you")
        }
        .textAlignment(.center)

        SubfeatureRow {
          Subfeature(
            "Recalls delivered straight to your phone",
            image: URL(string: "/gfx/symbols/exclamationmark.triangle.fill.png")!,
            accessibilityLabel: "Recall notices"
          )
          Subfeature(
            "Stay on top of your maintenance schedule",
            image: URL(string: "/gfx/symbols/calendar.badge.checkmark.png")!,
            accessibilityLabel: "Maintenance schedule"
          )
        }

        Div {
          Paragraph("Recall notices are currently only supported in the USA")
          Paragraph("Maintenance schedules require Connected Accounts (Beta)")
        }
        .fontSize(.extraSmall)
        .textAlignment(.center)
      }
    }
  }
}
