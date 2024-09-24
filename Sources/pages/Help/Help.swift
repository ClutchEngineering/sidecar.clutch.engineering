import Foundation

import Slipstream

struct Help: View {
  var body: some View {
    Page(
      "Sidecar help",
      path: "/help/",
      description: "Stuck? Get guidance in the Sidecar help guide.",
      keywords: [
        "OBD-II",
        "beta testing",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      ContentContainer {
        ContentContainer {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/help.png")!)

            Div {
              H1("Help resources")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Stuck? Find the guidance you need here")
                .fontSize(.large)
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
        .margin(.bottom, 16)
      }

      PostView("""
How to export OBD scan logs
---------------------------

Sidecar logs all OBD commands sent to and received from your vehicle when scanning is active. This
log is stored privately on your phone.

To export the logs from your phone, follow these steps from within the Sidecar app:

1. Tap the Settings tab.
2. Scroll down and tap the "Storage" button.
3. Tap "Scanning sessions".
4. A share sheet will appear. You can now airdrop the file, send it via email, or perform any other share action with the data.

Note: your OBD scan logs will typically contain your vehicle identification number (VIN).

![100%](/gfx/help/export-scan-sessions.png)

How to export vehicle data
--------------------------

Connected Account (Beta) vehicle data can be exported from Sidecar, which can be a helpful way to fix bugs and identify new data that can be incorporated into the Sidecar user interface.

To export your vehicle data, follow these steps from within the Sidecar app:

1. Tap your vehicle tab. If you have more than one vehicle, tap the Garage tab and then tap your vehicle.
2. Scroll down to and tap the "Export this vehicle's data" button.
3. Keep "Redact identifying data" enabled if you're sharing this data with someone else.
4. Tap "Export cached data" to export the most recent data that Sidecar has available. If you want to ensure all data is as fresh as possible, tap "Export fresh data" instead.
5. Tap the data export.
6. Tap "Share all documents", or share individual documents.
7. A share sheet will appear. You can now airdrop the file, send it via email, or perform any other share action with the data.

![100%](/gfx/help/export-vehicle-data.png)

""")
      .padding(.bottom, 16)
    }
  }
}
