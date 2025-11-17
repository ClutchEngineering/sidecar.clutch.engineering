import Foundation
import Slipstream
import VehicleSupportMatrix

let becomeBetaURL = URL(string: "/beta")

struct MakeGridPage: View {
  let supportMatrix: MergedSupportMatrix
  let makes: [String]

  init(supportMatrix: MergedSupportMatrix, outputURL: URL) {
    self.supportMatrix = supportMatrix
    let gfxURL = outputURL.appending(path: "gfx/make")
    let fm = FileManager.default

    self.makes = supportMatrix.getAllMakes().filter {
      let svgPath = gfxURL.appending(component: makeNameForIcon($0)).appendingPathExtension("svg").path()
      if !fm.fileExists(atPath: svgPath) {
        print("Dropping make: \($0) because no SVG found at \(svgPath)")
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
      ],
      scripts: [URL(string: "/scripts/vehicle-search.js")]
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

      // Search bar - always visible, sticky below header
      Section {
        ContentContainer {
          VehicleSearchBar()
        }
        .padding(.vertical, 16)
        .background(.white)
        .background(.zinc, darkness: 950, condition: .dark)
        .position(.sticky)
        .classNames(["top-0", "z-40"])
        .border(.init(.zinc, darkness: 200), width: 1, edges: .bottom)
        .border(.init(.zinc, darkness: 800), width: 1, edges: .bottom, condition: .dark)
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
          Div {
            for make in makes {
              MakeLink(make: make)
            }
          }
          .display(.grid)
          .classNames(["grid-cols-3", "md:grid-cols-5", "gap-x-4", "gap-y-8"])
        }
      }
      .margin(.vertical, 64)
    }
  }
}
