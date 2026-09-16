import Foundation

import Slipstream

/// Watchmen collects nothing, so it gets a short policy of its own rather than
/// the Mobile App policy the other apps share.
struct WatchmenPrivacyPolicy: View {
  let publicationDate: String

  var body: some View {
    Page(
      "Watchmen Privacy Policy",
      path: "/privacy-policy/watchmen/",
      description: "Watchmen collects nothing about you and sends no data to Clutch Engineering.",
      keywords: [
        "privacy policy",
        "watchmen",
        "apple watch",
        "traffic cameras",
        "surveillance cameras",
      ]
    ) {
      Container {
        VStack(alignment: .center) {
          HeroIconPuck(url: URL(string: "/gfx/privacy.png")!)

          Div {
            H1("Watchmen Privacy Policy")
              .fontSize(.fourXLarge)
              .bold()
              .fontDesign("rounded")
            Text("Last updated \(publicationDate)")
          }
          .textAlignment(.center)
        }
        .padding(.vertical, 16)

        Article("""
Watchmen shows you the road cameras around you. It collects nothing about you and sends no data to Clutch Engineering.

What Watchmen collects
----------------------

Nothing. Clutch Engineering (Fearless Design, LLC) receives no personal information from your use of Watchmen. There is no analytics, no advertising, and no identifier that follows you between sessions.

Where you are
-------------

Watchmen asks for your location so it can draw the cameras around you, and so it can tell which region you are in and follow the local laws on showing cameras. Both of those go through Apple's own map and location frameworks, which are covered by [Apple's privacy policy](https://www.apple.com/legal/privacy/).

Watchmen downloads the same file of camera locations that everyone downloads, and reads it on your device. That download says nothing about where you are and carries no identifier.

Your location is never sent to Clutch Engineering, and no record of where you have been is kept.

Where the cameras come from
---------------------------

Camera locations come from [OpenStreetMap](https://www.openstreetmap.org/copyright), © OpenStreetMap contributors.

Children's data
---------------

Watchmen is not directed to children, and Clutch Engineering does not knowingly collect personal information from anyone, including children under the age of 13.

Changes to this policy
----------------------

Clutch Engineering may update this policy as the app changes and as privacy law evolves. Material changes will be said here.

Contact us
----------

For questions about your privacy or anything in this policy, including if you need it in another format, write to [privacy@clutch.engineering](mailto:privacy@clutch.engineering).
""")
      }
      .padding(.bottom, 16)
    }
  }
}
