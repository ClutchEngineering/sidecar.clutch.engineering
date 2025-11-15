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
                ModelCard(make: make, modelSupport: modelSupport)
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
