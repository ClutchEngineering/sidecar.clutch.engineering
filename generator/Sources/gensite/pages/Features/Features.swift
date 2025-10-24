import Foundation

import Slipstream

struct Features: View {
  var body: some View {
    Page(
      "Features",
      path: "/features",
      description: "Explore Sidecar's powerful features for automation and vehicle diagnostics.",
      keywords: [
        "Apple Shortcuts",
        "automation",
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      FeaturesBreadcrumb()

      ContentContainer {
        ContentContainer {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/automation.png")!)

            Div {
              H1("Features")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Discover how Sidecar helps you understand and control your vehicle")
                .fontSize(.large)
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
        .margin(.bottom, 16)
      }

      PostView("""
Sidecar Shortcuts
-----------------

Build powerful workflows that react to and control your vehicle using Apple's Shortcuts app.

\(inlineHTML {
  Picture {
    Source(URL(string: "/gfx/vehicle-type-intent.dark.png"), colorScheme: .dark)
    Source(URL(string: "/gfx/vehicle-type-intent.png"), colorScheme: .light)
    Image(URL(string: "/gfx/vehicle-type-intent.png"))
      .margin(.horizontal, .auto)
      .frame(width: 0.8)
      .frame(width: 0.4, condition: .desktop)
  }
})

Sidecar provides a comprehensive set of actions for Apple's Shortcuts app, allowing you to automate climate control, read vehicle parameters, and build custom workflows.

[Learn more about Shortcuts →](/shortcuts)

---

OBD-II Scanning
---------------

Connect to your vehicle using an OBD-II scanner and unlock diagnostic capabilities.

\(inlineHTML {
  Image(URL(string: "/gfx/scanners.png"))
    .accessibilityLabel("OBD-II scanner")
    .frame(width: 96)
    .frame(width: 0.08, condition: .desktop)
    .margin(.horizontal, .auto)
    .cornerRadius(.extraLarge)
    .border(.white, width: 4)
    .border(.init(.zinc, darkness: 700), condition: .dark)
})

Sidecar includes a powerful, built-in OBD-II scanner designed for the everyday car owner. Read diagnostic trouble codes, monitor real-time parameters, and log your trips.

[Learn more about Scanning →](/scanning)

---

Leaderboard
-----------

Every mile driven with Sidecar contributes to the global leaderboard. See where your model stacks up and join the competition.

[Check out the leaderboard →](/leaderboard)

---

Beta program
------------

Join the Sidecar beta program and get early access to new features.

Beta testers help shape Sidecar by testing new features, providing feedback, and contributing to the community. You'll get access to upcoming functionality before it's released to everyone.

[Join the Beta →](/beta)
""")
      .padding(.bottom, 16)
    }
  }
}
