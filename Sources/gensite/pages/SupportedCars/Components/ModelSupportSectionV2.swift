import Foundation

import VehicleSupport
import VehicleSupportMatrix

import Slipstream

struct ModelSupportSectionV2: View {
  let make: Make
  let modelSupport: MergedSupportMatrix.ModelSupport
  let obdbID: MergedSupportMatrix.OBDbID
  let supportMatrix: MergedSupportMatrix
  let becomeBetaURL: URL?

  var body: some View {
    Div {
      VStack(alignment: .center, spacing: 4) {
        Link(URL(string: "#" + obdbID)) {
          Text(modelSupport.model)
            .bold()
            .fontDesign("rounded")
            .fontSize(.large)
            .fontSize(.extraLarge, condition: .desktop)
            .underline(condition: .hover)
        }
        // TODO: Use the model's OBDb slug here.
        Link(URL(string: "https://github.com/OBDb/\(obdbID)")) {
          Text("OBDb")
            .bold()
            .fontDesign("rounded")
            .fontSize(.small)
            .textColor(.link, darkness: 700)
            .textColor(.link, darkness: 400, condition: .dark)
            .underline(condition: .hover)
        }
        // if let symbolName = model.symbolName {
        //   Image(URL(string: "/gfx/model/\(symbolName).svg"))
        //     .colorInvert(condition: .dark)
        //     .display(.inlineBlock)
        //     .frame(width: 128)
        // }
      }
      .justifyContent(.center)
      .margin(.bottom, 16)

      if let yearRange = modelSupport.modelYearRange {
        Div {
          Table {
            TableHeader {
              HeaderCell { Text("Year") }
              HeaderCell { Text("Overall") }
              HeaderCell { ParameterHeader(icon: "bolt", name: "SoC") }
              HeaderCell { ParameterHeader(icon: "health", name: "SoH") }
              HeaderCell { ParameterHeader(icon: "plug", name: "State") }
              HeaderCell { ParameterHeader(icon: "battery", name: "Cells") }
              HeaderCell { ParameterHeader(icon: "fuel", name: "Fuel") }
              HeaderCell { ParameterHeader(icon: "speed", name: "Speed") }
              HeaderCell { ParameterHeader(icon: "length", name: "Range") }
              HeaderCell { ParameterHeader(icon: "length", name: "Odom") }
              HeaderCell(isLast: true) { ParameterHeader(icon: "tirepressure", name: "Tires") }
            }
            .background(.gray, darkness: 100)
            .background(.zinc, darkness: 950, condition: .dark)

            TableBody {
              let years = Array(modelSupport.yearCommandSupport.keys.sorted().enumerated())
              for (modelYearIndex, modelYear) in yearRange.enumerated() {
                // if let confirmedSignals = modelSupport.yearConfirmedSignals[modelYear] {
                  // Text(confirmedSignals.joined(separator: ", "))
                  EnvironmentAwareRow(isLastRow: modelYearIndex == years.count - 1) {
                    YearsCell(years: modelYear...modelYear)
                    // TestingStatusCell(status: status, becomeBetaURL: becomeBetaURL)
                    // if case .testerNeeded = status.testingStatus {
                    //   // Do nothing.
                    // } else {
                    //   SupportStatus(supported: status.stateOfCharge)
                    //   SupportStatus(supported: status.stateOfHealth)
                    //   SupportStatus(supported: status.charging)
                    //   SupportStatus(supported: status.cells)
                    //   SupportStatus(supported: status.fuelLevel)
                    //   SupportStatus(supported: status.speed)
                    //   SupportStatus(supported: status.range)
                    //   SupportStatus(supported: status.odometer)
                    //   SupportStatus(supported: status.tirePressure, isLast: true)
                    // }
                  }
                // }
              }
            }
          }
          .frame(width: .full, condition: .desktop)
        }
        .fontSize(.extraSmall, condition: .mobileOnly)
        .textAlignment(.center)
        .margin(.horizontal, .auto, condition: .desktop)
        .border(.init(.zinc, darkness: 400), width: 1)
        .border(.init(.zinc, darkness: 600), width: 1)
        .cornerRadius(.large)
      }
    }
    .padding(.vertical, 16)
    .padding(32, condition: .desktop)
    .cornerRadius(.extraExtraLarge)
    .background(.zinc, darkness: 200)
    .background(.zinc, darkness: 800, condition: .dark)
    .id(obdbID)
  }
}
