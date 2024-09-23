import Foundation

import Slipstream

let betaSubscriptionLength = "two"

struct BetaTesterHandbook: View {
  var body: some View {
    Page(
      "Beta tester handbook",
      path: "/beta/",
      description: "How to become a Sidecar beta tester .",
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

Sidecar is a product of [Clutch Engineering](https://clutch.engineering/), an indie startup founded by [Jeff Verkoeyen](http://jeffverkoeyen.com/) and committed to building best-in-class solutions for niche product categories. With a sustainable business model, Sidecar focuses on enhancing the way people interact with their cars.

As a beta tester, your feedback will be critical in improving the Sidecar experience. This guide explains the expectations of the role, the benefits of participating, and how to get started.

Beta Tester Requirements
------------------------

To become a Sidecar beta tester, you’ll need:

1.  **Access to a car**: Ideally, you’ll test with your daily driver, but infrequent drivers (even [garage queens](https://en.wiktionary.org/wiki/garage_queen)) are welcome.

2.  **iOS 17+ Device**: Testing should ideally be done on your primary iPhone. Android support isn’t available yet, but if you’re interested, email Jeff at support@clutch.engineering to express interest.

3.  **Willingness to Share Feedback**: You'll be asked to provide feedback regularly via Sidecar's companion forum, [cars.forum](https://meta.cars.forum/viewforum.php?f=12).

4.  **OBD Data Sharing (Optional)**: If you're testing OBD support, you should be comfortable sharing scan logs and screenshots to help with data accuracy.

Beta Tester Benefits
--------------------

As a thank you for your participation, approved beta testers will receive a free, **\(betaSubscriptionLength)-month** Sidecar subscription. This gives you access to all of Sidecar’s features to aid in testing the app.

Conditions
----------

*   Only one beta tester is allowed per vehicle make, model, and year, and only [when a tester is needed](/supported-cars/).

*   Registration operates on a first-come, first-served basis.

How to Register
---------------

To become a beta tester, you must first create an account on [cars.forum](https://cars.forum), the community forum for Sidecar and other Clutch Engineering products. If you don’t have an account yet, you can [register here](https://meta.cars.forum/ucp.php?mode=register).

Once logged in, [search the Beta Testing Registration forum](https://meta.cars.forum/search.php?fid[]=17) for your car’s make and model. If no thread exists for your vehicle, create one using this template:

```
Subject: [Make] [Model] [Year]
Body:
I am interested in becoming a Sidecar beta tester for this make/model/year.

My tester profile:

iOS Version: [e.g., iOS 17.1]
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

You will receive your subscription promo code after you have been approved as a beta tester,
installed the app, and initiated a discussion about your make/model on the
[Sidecar forum](https://meta.cars.forum/viewforum.php?f=12).
""")
      .padding(.bottom, 16)
    }
  }
}
