import Foundation
import Slipstream
import VehicleSupport

struct MakeSupportSectionV2: View {
  let make: Make
  // let models: [Model: [VehicleSupportStatus]]
  let betaSubscriptionLength: String
  let becomeBetaURL: URL?

  var body: some View {
    Section {
      ContentContainer {
        MakeCard(make: make)
          .margin(.bottom, 16)

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
        .margin(.bottom, 16)

        // VStack(alignment: .leading, spacing: 16) {
        //   for (model, statuses) in models.sortedByLocalizedStandard() {
        //     ModelSupportSection(make: make, model: model, statuses: statuses, becomeBetaURL: becomeBetaURL)
        //   }
        // }
        // .alignItems(.center, condition: .desktop)
      }
    }
    .id(make)
  }
}