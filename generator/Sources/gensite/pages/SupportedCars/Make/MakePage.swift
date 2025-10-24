import Foundation
import Slipstream
import VehicleSupportMatrix

struct MakeHeroIconPuck: View {
  let make: String
  var body: some View {
    Puck {
      Div {
        Image(URL(string: "/gfx/make/\(makeNameForIcon(make)).svg"))
          .frame(width: 104, height: 104)
          .padding(8)
          .colorInvert(condition: .dark)
      }
      .background(.white)
      .background("sidecar-gray", condition: .dark)
      .margin(.horizontal, .auto)
      .margin(.top, 8)
      .margin(.bottom, 24)
      .cornerRadius(.extraExtraExtraLarge)
    }
    .border(.init(.zinc, darkness: 700), width: 4)
    .border(.white, condition: .dark)
  }
}

struct MakePage: View {
  let supportMatrix: MergedSupportMatrix
  let make: String

  var body: some View {
    Page(
      "\(make) OBD support",
      path: "/supported-cars/\(make.lowercased())/",
      description: "Check which Sidecar features work with your \(make).",
      keywords: [
        make,
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      ContentContainer {
        VStack(alignment: .center) {
          HStack(spacing: 32) {
            Link(URL(string: "/supported-cars/")) {
              HeroIconPuck(url: URL(string: "/gfx/supported-vehicle.png")!)
            }
            MakeHeroIconPuck(make: make)
          }

          Div {
            H1(make + " OBD Support")
              .fontSize(.extraLarge)
              .fontSize(.fourXLarge, condition: .desktop)
              .bold()
              .fontDesign("rounded")
            Text("Check which Sidecar features work with your \(make)")
          }
          .textAlignment(.center)
        }
        .padding(.vertical, 16)
      }

      Section {
        ContentContainer {
          VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
              Image(URL(string: "/gfx/symbols/checkmark.seal.png"))
                .colorInvert(condition: .dark)
                .display(.inlineBlock)
                .frame(width: 36)

              H1("General support")
                .fontSize(.extraLarge)
                .fontSize(.fourXLarge, condition: .desktop)
                .bold()
                .fontDesign("rounded")
            }
            Article("Sidecar supports the [SAEJ1979 OBD-II standard](https://en.wikipedia.org/wiki/OBD-II_PIDs) for vehicles produced in the USA since 1996 and vehicles worldwide in the 2000's. For vehicles that support OBD-II — typically combustion and hybrid vehicles — this enables out-of-the-box support for odometer, speed, fuel tank levels, and 100s of other parameters. You can test your vehicle's OBD-II support with Sidecar for free.")
          }
          .padding([.top, .horizontal], 16)
          .background(.zinc, darkness: 0)
          .background(.zinc, darkness: 900, condition: .dark)
          .cornerRadius(.extraExtraLarge)
          .margin(.horizontal, .auto, condition: .desktop)
          .frame(width: 0.5, condition: .desktop)
        }
      }
      .margin(.bottom, 32)

      Section {
        ContentContainer {
          VStack(alignment: .leading, spacing: 16) {
            H1("Legend")
              .fontSize(.extraLarge)
              .fontSize(.fourXLarge, condition: .desktop)
              .bold()
              .fontDesign("rounded")

            HStack(spacing: 16) {
              SupportedSeal()
              Text("Vehicle is fully onboarded and does not currently need new beta testers.")
            }
            HStack(spacing: 16) {
              OBDStamp()
              Text {
                DOMString("Feature is supported via OBD. ")
                Link("Requires a connected OBD-II scanner.", destination: URL(string: "/scanning/"))
                  .textColor(.link, darkness: 700)
                  .textColor(.link, darkness: 400, condition: .dark)
                  .fontWeight(600)
                  .underline(condition: .hover)
              }
            }
            HStack(spacing: 16) {
              OTAStamp()
              Text("Feature is supported via Connected Accounts (Beta).")
            }
            HStack(spacing: 16) {
              NotApplicableStamp()
              Text("Not applicable to this vehicle.")
            }
            HStack(spacing: 16) {
              Text {
                Span("PID?")
                  .bold()
                DOMString(" The OBD parameter identifier (PID) is unknown.")
              }
            }
          }
          .alignItems(.center, condition: .desktop)
          .textAlignment(.center, condition: .desktop)
          .padding(.vertical, 16)
        }
      }
      .margin(.bottom, 32)

      HorizontalRule()

      MakeSupportSectionV2(
        make: make,
        modelIDs: supportMatrix.getOBDbIDs(for: make),
        supportMatrix: supportMatrix,
        betaSubscriptionLength: betaSubscriptionLength,
        becomeBetaURL: becomeBetaURL
      )
      .margin(.vertical, 32)
    }
  }
}
