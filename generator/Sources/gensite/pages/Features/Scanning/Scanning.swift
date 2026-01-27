import Foundation

import Slipstream

struct Scanning: View {
  var body: some View {
    Page(
      "Scanning",
      path: "/scanning",
      description: "Getting started with OBD-II scanning in Sidecar.",
      keywords: [
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ],
      additionalStylesheets: [
        URL(string: "/css/scanners.css")
      ],
      socialBannerPath: "/gfx/social/obdii.png"
    ) {
      FeaturesBreadcrumb()

      ScanningNavigation()

      Container {
        Section {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/scanners.png")!)

            Div {
              H1("OBD-II Scanning")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("How to talk to your car")
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
      }

      PostView("""
The basics
----------

Sidecar includes a powerful, built-in OBD-II scanner that's designed for the everyday car owner.

### What is OBD-II?

OBD stands for On-Board Diagnostics. It's how your car monitors its health. Think of it as your car's way of checking in on itself to make sure everything is running smoothly.

### How does OBD-II Work?

Modern cars rely on the **CAN bus** (the Controller Area Network) to enable car components, such as the engine control unit, transmission control unit, and anti-lock braking system to speak to each other.

OBD-II is like a translator for the data traveling over the CAN bus. OBD-II scanners transform data from the CAN bus into something car owners can understand.

### Codes and parameters

Your car's check engine light indicates a problem lurking under the hood. OBD-II scanners come to the rescue by pinpointing the issue. These scanners unveil diagnostic trouble **codes** (DTCs), which act as clues for mechanics to diagnose and fix your car's problems. They're a key tool in keeping your car in top shape.

In addition to DTCs, cars can also define **parameter** ids (PIDs). PIDs allow scanners to request sensor data from your car on demand, such as state of charge, car speed, and temperature sensors.

\(inlineHTML {
  Image(URL(string: "/gfx/parameters.png"))
    .accessibilityLabel("OBD-II parameters allow you to see various signals from your car")
    .frame(width: 320)
    .frame(width: 0.4, condition: .desktop)
    .margin(.horizontal, .auto)
})

---

Getting started
---------------

Sidecar aims to make OBD-II scanning intuitive and simple. Follow these steps to get started.

Note: OBD-II scanning in Sidecar for longer than 5 minutes requires a subscription or a ScanPass.

\(inlineHTML {
  Image(URL(string: "/gfx/scanners.png"))
    .accessibilityLabel("The OBD-II port")
    .frame(width: 96)
    .frame(width: 0.08, condition: .desktop)
    .margin(.horizontal, .auto)
    .cornerRadius(.extraLarge)
    .border(.white, width: 4)
    .border(.init(.zinc, darkness: 700), condition: .dark)
})

### Step 1: Find your OBD-II port

Make sure your car has an OBD-II port before buying a scanner. Most cars manufactured after 1996 will have one, but it's a good idea to make sure your car has one before buying a scanner.

The OBD-II port is located inside the cabin, under the dashboard, beneath the steering wheel. It can be difficult to find while seated in the car, so consider looking with a flashlight and your eyes rather than feeling with your hands.

### Step 2: Buy a scanner

Sidecar supports Bluetooth Low Energy (BTLE), Wi-Fi, and classic Bluetooth scanners.

**BTLE scanners work best** because they connect automatically when powered on and near your phone. Wi-Fi and classic Bluetooth scanners require you to manually connect them each time you want to use them, which can be a hassle if you intend to use the scanner for daily trip logging. BTLE scanners also work best with wireless CarPlay; WiFi scanners can't be used simultaneously with wireless CarPlay.

There are countless variations of OBD-II scanners on the market. A table of options is provided below. Select the country you're ordering from within to get directed to the right Amazon store.

Discouraged Scanners
--------------------

The following scanner hardware is known to use proprietary protocols that will not work with any general purpose scanning software, including Sidecar.

- Any BLCKTEC model (the 410 and 430 models, specifically).
- Any OBDEleven model.

Tested Scanners
---------------

\(inlineHTML {
  Div {
    ScannerTables()
  }
})

Performance tests to determine commands/second were ran by [ELMCheck](https://apps.apple.com/us/app/elmcheck/id6479630442), a companion app to Sidecar.

\(inlineHTML {
VStack(alignment: .center) {
  Link(URL(string: "https://apps.apple.com/us/app/elmcheck/id6479630442")) {
    HStack {
      Image(URL(string: "/gfx/elmcheck.png"))
        .accessibilityLabel("ELMCheck App Icon")
        .frame(width: 64, height: 64)
        .margin(.right, 16)
      VStack {
        Text("ELMCheck")
          .fontSize(.large)
          .fontWeight(.semibold)
        Text("Check the authenticity of your OBD-II scanner.")
          .textColor(.gray, darkness: 600)
          .textColor(.gray, darkness: 400, condition: .dark)
      }
    }
    .justifyContent(.center)
    .background(.zinc, darkness: 900, condition: .dark)
    .shadow(radius: 6)
    .cornerRadius(.medium)
    .padding(16)
  }
}
})

In summary: Vgate iCar Pro Bluetooth 4.0 is the best value, while OBDLink offers higher quality scanners with higher command speeds and support for a wider range of vehicles.

### Step 3: Connect Sidecar to your scanner

To connect to your scanner for the first time, follow these steps:

1.  Open Sidecar's Settings tab.

2.  Enable "Vehicle scanning".

3.  Enable connections over Wi-Fi and/or BTLE.

4.  Follow further instructions based on your scanner type.


If using a BTLE scanner:

1.  Tap your scanner in the list of vehicle scanners to connect to it.

If using a classic Bluetooth scanner:

1.  Pair your phone to your scanner using the system settings app.
2.  Once paired, you may need to refresh the vehicle scanners list in Sidecar for the scanner to appear.
3.  Tap your scanner in the list of vehicle scanners to connect to it.

If using a Wi-Fi scanner:

1.  Connect to the scanner's Wi-Fi network and that your Wi-Fi settings match the scanner's Wi-Fi settings.
2.  Tap your scanner in the list of vehicle scanners to connect to it.

\(inlineHTML {
  Image(URL(string: "/gfx/vehicle-scanning.png"))
    .accessibilityLabel("Vehicle scanning can be enabled in Sidecar's Settings")
    .frame(width: 0.4, condition: .desktop)
    .margin(.horizontal, .auto)
})

### Auto-connect mode

If "Auto-connect known scanners" is enabled then Sidecar will automatically scan for and connect to your scanner whenever the app opens or a trip begins.

### Daily use

If you plan to use your scanner for daily use, here's a couple things to keep in mind:

1.  Be cautious about leaving your scanner plugged in and powered on at all times. Most scanners allow anyone to connect to them when they're powered on, which can create a security issue for your vehicle if left unattended.
2.  If you plan to use your scanner daily, consider getting an OBDII cable with a power switch ([Amazon](https://www.amazon.com/dp/B01EW83OCQ?&_encoding=UTF8&tag=electricsidecar-20&linkCode=ur2&linkId=website-scanning&camp=1789&creative=9325) for $11.99 USD). You can then easily control the scanner's on/off state without having to plug and unplug it.

Note: all Amazon links on this page are affiliate links.
""")
    }
  }
}
