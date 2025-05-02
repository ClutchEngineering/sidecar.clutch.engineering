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
        let yearRangeConnectables = supportMatrix.connectables(for: obdbID)
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
              let supportByModelYear = modelSupport.connectableSupportByModelYear(
                yearRangeSignalMap: yearRangeConnectables,
                saeConnectables: supportMatrix.saeConnectables
              )

              for (modelYearIndex, modelYear) in yearRange.enumerated() {
                if let support = supportByModelYear[modelYear] {
                  EnvironmentAwareRow(isLastRow: modelYearIndex == yearRange.count - 1) {
                    YearsCell(years: modelYear...modelYear)
                    TesterNeededStatusCell()
                    if modelSupport.engineType.hasBattery {
                      SupportStatusV2(supported: support[.stateOfCharge])
                      SupportStatusV2(supported: support[.stateOfHealth])
                      SupportStatusV2(supported: support[.isCharging])
                      SupportStatusV2(supported: support[.batteryModulesStateOfCharge])
                    } else {
                      NotApplicableCell(isLast: false)
                      NotApplicableCell(isLast: false)
                      NotApplicableCell(isLast: false)
                      NotApplicableCell(isLast: false)
                    }
                    if modelSupport.engineType.hasFuel {
                      SupportStatusV2(supported: support[.fuelTankLevel])
                    } else {
                      NotApplicableCell(isLast: false)
                    }
                    SupportStatusV2(supported: support[.speed])
                    SupportStatusV2(supported: max(support[.electricRange] ?? .unknown, support[.fuelRange] ?? .unknown))
                    SupportStatusV2(supported: support[.odometer])
                    SupportStatusV2(supported: max(
                      max(support[.frontLeftTirePressure] ?? .unknown, support[.frontLeftTirePressure] ?? .unknown),
                      max(support[.rearLeftTirePressure] ?? .unknown, support[.rearLeftTirePressure] ?? .unknown)
                    ), isLast: true)
                  }
                } else {
                  EnvironmentAwareRow(isLastRow: modelYearIndex == yearRange.count - 1) {
                    YearsCell(years: modelYear...modelYear)
                    TesterNeededStatusCell()
                  }
                }
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

struct SupportStatusV2: View {
  let supported: MergedSupportMatrix.ModelSupport.ConnectableSupportLevel??
  let isLast: Bool

  init(supported: MergedSupportMatrix.ModelSupport.ConnectableSupportLevel?, isLast: Bool = false) {
    self.supported = supported
    self.isLast = isLast
  }

  var body: some View {
    switch supported {
    case .confirmed:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          OBDStamp()
        }
      }
      .padding(.horizontal, 8)
    case .shouldBeSupported:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          HStack {
            OBDStamp()
              .opacity(0.25)
          }
          .justifyContent(.center)
        }
      }
      .padding(.horizontal, 8)
    case nil, .some(.none), .unknown:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          Text("")
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
      }
      .padding(.horizontal, 8)
    }
  }
}
