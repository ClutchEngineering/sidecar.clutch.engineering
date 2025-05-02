import Foundation
import Slipstream
import VehicleSupportMatrix

struct SupportedCarsV2: View {
  let supportMatrix: MergedSupportMatrix
  let makes: [String]

  init(supportMatrix: MergedSupportMatrix) {
    self.supportMatrix = supportMatrix
    let gfxURL = outputURL.appending(path: "gfx/make")
    let fm = FileManager.default

    self.makes = supportMatrix.getAllMakes().filter {
      if !fm.fileExists(atPath: gfxURL.appending(component: makeNameForIcon($0)).appendingPathExtension("svg").path()) {
        print("Dropping make: \($0) because no SVG found")
        return false
      }
      return true
    }.sorted(by: { makeNameForSorting($0) < makeNameForSorting($1) })
  }

  var body: some View {
    Page(
      "Supported Cars",
      path: "/supported-cars/",
      description: "Sidecar supports a wide range of makes and models.",
      keywords: [
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      ContentContainer {
        VStack(alignment: .center) {
          HeroIconPuck(url: URL(string: "/gfx/supported-vehicle.png")!)

          Div {
            H1("Supported Cars")
              .fontSize(.extraLarge)
              .fontSize(.fourXLarge, condition: .desktop)
              .bold()
              .fontDesign("rounded")
            Text("Check which Sidecar features work with your car")
          }
          .textAlignment(.center)
        }
        .padding(.vertical, 16)
      }

      Section {
        ContentContainer {
          VStack(alignment: .center, spacing: 8) {
            Link(becomeBetaURL) {
              VStack(alignment: .center, spacing: 4) {
                H1("Don't see your car?")
                  .fontSize(.extraLarge)
                  .fontSize(.fourXLarge, condition: .desktop)
                  .bold()
                  .fontDesign("rounded")
                Text("Become a Sidecar beta tester, get \(betaSubscriptionLength) months free")
                  .fontSize(.large)
                  .fontSize(.extraLarge, condition: .desktop)
                  .fontWeight(.medium)
                  .fontDesign("rounded")
                Text("Learn more ")
                  .fontWeight(.bold)
                  .fontDesign("rounded")
                  .fontSize(.large)
                  .underline(condition: .hover)
              }
              .textAlignment(.center)
              .classNames(["bg-gradient-to-tl", "from-cyan-500", "to-blue-600"])
              .transition(.all)
              .textColor(.white)
              .padding(.horizontal, 32)
              .padding(.vertical, 24)
              .background(.zinc, darkness: 100)
              .background(.zinc, darkness: 900, condition: .dark)
              .cornerRadius(.extraExtraLarge)
            }
          }
          .frame(width: 0.8)
          .frame(width: 0.6, condition: .desktop)
          .margin(.horizontal, .auto)
        }
        .padding(.vertical, 8)
        .padding(.vertical, 16, condition: .desktop)
      }
      .margin(.bottom, 32)

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
            Article("Sidecar supports the [SAEJ1979 OBD-II standard](https://en.wikipedia.org/wiki/OBD-II_PIDs) for vehicles produced in the USA since 1996. For vehicles that support OBD-II — typically combustion and hybrid vehicles — this enables out-of-the-box support for odometer, speed, fuel tank levels, and 100s of other parameters. You can test your vehicle's OBD-II support with Sidecar for free.")
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
              Text("Feature is supported via Connected Accounts.")
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

      Section {
        H1("Jump to your make")
          .fontSize(.extraLarge)
          .fontSize(.fourXLarge, condition: .desktop)
          .bold()
          .fontDesign("rounded")
          .textAlignment(.center)
          .margin(.bottom, 32)

        Div {
          for make in makes {
            MakeLink(make: make)
          }
        }
        .display(.flex)
        .padding(.horizontal, 32)
        .classNames([
          "flex-wrap",
          "justify-center",
          "gap-10",
          "w-full"
        ])
      }
      .margin(.vertical, 64)

      HorizontalRule()

      VStack(alignment: .center, spacing: 64) {
        for make in makes {
          MakeSupportSectionV2(
            make: make,
            models: supportMatrix.getModels(for: make),
            betaSubscriptionLength: betaSubscriptionLength,
            becomeBetaURL: becomeBetaURL
          )
        }
      }
      .margin(.vertical, 32)
    }
  }
}
