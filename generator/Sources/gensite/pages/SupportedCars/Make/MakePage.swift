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

      Section {
        ContentContainer {
          VStack(alignment: .center, spacing: 8) {
            Link(becomeBetaURL) {
              VStack(alignment: .center, spacing: 4) {
                H1("Don't see your car?")
                  .fontSize(.large)
                  .fontSize(.extraLarge, condition: .desktop)
                  .bold()
                  .fontDesign("rounded")
                Text("Become a Sidecar beta tester, get \(betaSubscriptionLength) months free")
                  .fontSize(.small)
                  .fontSize(.base, condition: .desktop)
                  .fontWeight(.medium)
                  .fontDesign("rounded")
                Text("Learn more")
                  .fontWeight(.bold)
                  .fontDesign("rounded")
                  .fontSize(.large)
                  .underline(condition: .hover)
              }
              .textAlignment(.center)
              .classNames(["bg-gradient-to-tl", "from-cyan-500", "to-blue-600"])
              .transition(.all)
              .textColor(.white)
              .padding(.horizontal, 16)
              .padding(.vertical, 12)
              .background(.zinc, darkness: 100)
              .background(.zinc, darkness: 900, condition: .dark)
              .cornerRadius(.extraExtraLarge)
            }
          }
          .frame(width: 0.8)
          .frame(width: 0.6, condition: .desktop)
          .margin(.horizontal, .auto)
          .margin(.bottom, 32)

          // Grid of model cards
          Div {
            for obdbID in supportMatrix.getOBDbIDs(for: make) {
              if let modelSupport = supportMatrix.getModel(id: obdbID) {
                Link(ModelLink.url(for: make, model: modelSupport.model)) {
                  VStack(alignment: .center, spacing: 8) {
                    if !modelSupport.modelSVGs.isEmpty {
                      Image(URL(string: "/gfx/vehicle/\(modelSupport.modelSVGs[0])"))
                        .colorInvert(condition: .dark)
                        .display(.inlineBlock)
                        .frame(width: 96)
                    }
                    Text(modelSupport.model)
                      .bold()
                      .fontDesign("rounded")
                      .fontSize(.large)
                      .textAlignment(.center)
                    VStack(alignment: .center, spacing: 4) {
                      if modelSupport.numberOfMilesDriven > 0 {
                        Text("\(NumberFormatter.localizedString(from: NSNumber(value: modelSupport.numberOfMilesDriven), number: .decimal)) miles")
                          .fontSize(.small)
                          .textColor(.text, darkness: 600)
                          .textColor(.text, darkness: 400, condition: .dark)
                      }
                      if modelSupport.numberOfDrivers > 0 {
                        Text("\(NumberFormatter.localizedString(from: NSNumber(value: modelSupport.numberOfDrivers), number: .decimal)) drivers")
                          .fontSize(.small)
                          .textColor(.text, darkness: 600)
                          .textColor(.text, darkness: 400, condition: .dark)
                      }
                    }
                  }
                  .padding(16)
                  .background(.zinc, darkness: 100)
                  .background(.zinc, darkness: 800, condition: .dark)
                  .cornerRadius(.extraLarge)
                  .border(.init(.zinc, darkness: 300), width: 1)
                  .border(.init(.zinc, darkness: 700), width: 1, condition: .dark)
                  .transition(.all)
                }
                .textDecoration("none")
                .modifier(ClassModifier(add: "hover:scale-105"))
              }
            }
          }
          .display(.grid)
          .modifier(ClassModifier(add: "grid-cols-2"))
          .modifier(ClassModifier(add: "md:grid-cols-3"))
          .modifier(ClassModifier(add: "lg:grid-cols-4"))
          .modifier(ClassModifier(add: "gap-4"))
        }
      }
      .margin(.vertical, 32)
    }
  }
}
