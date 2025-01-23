import Foundation

import Slipstream

let betaSubscriptionLength = "two"

struct BetaTesterHandbook: View {
  var body: some View {
    Page(
      "Beta tester handbook",
      path: "/beta/",
      description: "How to become a Sidecar beta tester.",
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
            HeroIconPuck(url: URL(string: "/gfx/supported-vehicle.png")!)

            Div {
              H1("Become a Sidecar beta tester")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Get a free \(betaSubscriptionLength) month subscription")
                .fontSize(.large)
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
        .margin(.bottom, 16)
      }

      PostView("""
About the Beta Tester Program
-----------------------------

As a beta tester, your feedback is critical to improving the Sidecar experience. This guide explains the requirements to become a beta tester, the benefits of participating, and how to get started.

Beta Tester Requirements
------------------------

To become a Sidecar beta tester, you’ll need:

1.  **Access to a car**: Ideally, you’ll test with your daily driver, but infrequent drivers (even [garage queens](https://en.wiktionary.org/wiki/garage_queen)) are welcome.

2.  **iOS 18+ device**: Testing should ideally be done on your primary iPhone. Android support isn’t available yet, but if you’re interested, email Jeff at support@clutch.engineering to express interest.

3.  **Willingness to share feedback**: You'll be asked to provide feedback regularly via Sidecar's companion forum, [cars.forum](https://meta.cars.forum/viewforum.php?f=12).

4.  **OBD data sharing**: If you're testing OBD support, you will need to share scan logs and screenshots to help with data accuracy.

Note: if you do not have an OBD scanner yet but would like to purchase one, a set of tested scanners
is available in the [OBD-II Scanning guide](/scanning/).

Beta Tester Benefits
--------------------

As a thank you for your participation, approved beta testers will receive a free, **\(betaSubscriptionLength)-month** Sidecar subscription. This gives you access to all of Sidecar’s features to aid in testing the app.

Conditions
----------

*   A finite number of beta testers are allowed per vehicle make, model, and year, and only [when a tester is needed](/supported-cars/). If your car is not listed in the supported cars list at all, it probably needs a tester :)

*   Registration operates on a first-come, first-served basis.

How to Register
---------------

To become a beta tester, you must first create an account on [cars.forum](https://cars.forum), the community forum for Sidecar and other Clutch Engineering products. If you don’t have an account yet, you can [register here](https://meta.cars.forum/ucp.php?mode=register). It's free.

Once logged in, [search the Beta Testing Registration forum](https://meta.cars.forum/search.php?fid[]=17) for your car’s make and model. If no thread exists for your vehicle, create one using this template:

```
Subject: [Make] / [Model] / [Year]
Body:
I am interested in becoming a Sidecar beta tester for this make/model/year.

My tester profile:

iOS Version: [e.g., iOS 18.2]
Apple Watch Available: [Yes/No]
watchOS Version (if you have a watch): [e.g., watch 11.1]
Internet connected vehicle: [Yes/No]
OBD Device Available: [Yes/No]
OBD Device model: [e.g. OBDLink CX]
Testing Availability: [e.g., Daily, Weekly, Monthly]
Time zone: [e.g. PST, UTC−08:00]
Additional Notes: [e.g., Has aftermarket parts, modifications, etc.]
```

If a thread already exists, simply reply using the same template.

If a beta tester is needed for your vehicle, Jeff will reach out to onboard you with the next steps.

You will receive your subscription promo code after you have:

1. been added to the beta tester group on cars.forum,
2. [installed Sidecar](https://apps.apple.com/us/app/electric-sidecar/id1663683832) and connected
it to your car either with a Connected Account or via [OBD-II](https://sidecar.clutch.engineering/scanning/)
(you can connect your car without a subscription),
3. started or contributed to a thread in the [vehicle onboarding forum](https://meta.cars.forum/viewforum.php?f=12), and
3. if you are testing OBD logs, you've emailed an [export of your OBD logs](https://sidecar.clutch.engineering/help/#how-to-export-obd-scan-logs) to support@clutch.engineering.
""")
      .padding(.bottom, 16)

      TakeItForASpin(subtitle: "Start your test drive")
    }
  }
}
