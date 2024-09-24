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
""")
      .padding(.bottom, 16)
    }
  }
}
