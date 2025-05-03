import Foundation

import VehicleSupport
import VehicleSupportMatrix

import Slipstream

struct ModelVehicleImage: View {
  let filename: String

  var body: some View {
    Image(URL(string: "/gfx/vehicle/\(filename)"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 128)
  }
}

struct ModelSupportSectionV2: View {
  let make: Make
  let modelSupport: MergedSupportMatrix.ModelSupport
  let obdbID: MergedSupportMatrix.OBDbID
  let supportMatrix: MergedSupportMatrix
  let becomeBetaURL: URL?

  var body: some View {
    Div {
      VStack(alignment: .center, spacing: 4) {
        Link(URL(string: "#" + modelSupport.obdbID)) {
          Text(modelSupport.model)
            .bold()
            .fontDesign("rounded")
            .fontSize(.large)
            .fontSize(.extraLarge, condition: .desktop)
            .underline(condition: .hover)
        }
        Link(URL(string: "https://github.com/OBDb/\(modelSupport.obdbID)")) {
          Text("OBDb")
            .bold()
            .fontDesign("rounded")
            .fontSize(.small)
            .textColor(.link, darkness: 700)
            .textColor(.link, darkness: 400, condition: .dark)
            .underline(condition: .hover)
        }
        if modelSupport.numberOfDrivers > 0 || modelSupport.numberOfMilesDriven > 0 {
          VStack(alignment: .center) {
            if modelSupport.numberOfMilesDriven > 0 {
              Text("\(NumberFormatter.localizedString(from: NSNumber(value: modelSupport.numberOfMilesDriven), number: .decimal)) mile\(modelSupport.numberOfMilesDriven != 1 ? "s" : "" ) driven")
            }
            if modelSupport.numberOfDrivers > 0 {
              Text("\(NumberFormatter.localizedString(from: NSNumber(value: modelSupport.numberOfDrivers), number: .decimal)) driver\(modelSupport.numberOfDrivers != 1 ? "s" : "")")
            }
          }
          .fontSize(.small)
          .textColor(.text, darkness: 600)
          .textColor(.text, darkness: 400, condition: .dark)
        }
        if !modelSupport.modelSVGs.isEmpty {
          HStack {
            for modelSVGFilename in modelSupport.modelSVGs {
              ModelVehicleImage(filename: modelSVGFilename)
            }
          }
        }
      }
      .justifyContent(.center)
      .margin(.bottom, 16)

      let yearRangeConnectables = supportMatrix.connectables(for: obdbID)
      Div {
        Table {
          TableHeader {
            HeaderCell { Text("Year") }.frame(width: 108)
            HeaderCell { Text("Overall") }
            HeaderCell { ParameterHeader(icon: "bolt", name: "SoC", secondary: !modelSupport.engineType.hasBattery) }
            HeaderCell { ParameterHeader(icon: "health", name: "SoH", secondary: !modelSupport.engineType.hasBattery) }
            HeaderCell { ParameterHeader(icon: "plug", name: "State", secondary: !modelSupport.engineType.hasBattery) }
            HeaderCell { ParameterHeader(icon: "battery", name: "Cells", secondary: !modelSupport.engineType.hasBattery) }
            HeaderCell { ParameterHeader(icon: "fuel", name: "Fuel", secondary: !modelSupport.engineType.hasFuel) }
            HeaderCell { ParameterHeader(icon: "speed", name: "Speed", secondary: false) }
            HeaderCell { ParameterHeader(icon: "length", name: "Range", secondary: false) }
            HeaderCell { ParameterHeader(icon: "length", name: "Odom", secondary: false) }
            HeaderCell(isLast: true) { ParameterHeader(icon: "tirepressure", name: "Tires", secondary: false) }
          }
          .background(.gray, darkness: 100)
          .background(.zinc, darkness: 950, condition: .dark)

          TableBody {
            // Use the grouped model year ranges instead of individual years
            let supportByModelYearRange = modelSupport.connectableSupportGroupByModelYearRange(
              yearRangeSignalMap: yearRangeConnectables,
              saeConnectables: supportMatrix.saeConnectables
            )

            let modelYearRanges = Array(supportByModelYearRange.keys).sorted { $0.lowerBound < $1.lowerBound }

            if modelYearRanges.isEmpty {
              // No support for this model yet.
              EnvironmentAwareRow(isLastRow: true) {
                AllYearsCell()
                TesterNeededStatusCell()
              }
            } else {
              for (rangeIndex, yearRangeKey) in modelYearRanges.enumerated() {
                let support = supportByModelYearRange[yearRangeKey]!
                EnvironmentAwareRow(isLastRow: rangeIndex == modelYearRanges.count - 1) {
                  YearsCell(years: yearRangeKey) // Using the actual year range instead of single year
                  TesterNeededStatusCell()
                  if modelSupport.engineType.hasBattery {
                    SupportStatusV2(support: support, connectables: [.stateOfCharge], make: make, isLast: false)
                    SupportStatusV2(support: support, connectables: [.stateOfHealth], make: make, isLast: false)
                    SupportStatusV2(support: support, connectables: [.isCharging, .pluggedIn], make: make, isLast: false)
                    SupportStatusV2(support: support, connectables: [.batteryModulesStateOfCharge], make: make, isLast: false)
                  } else {
                    NotApplicableCell(isLast: false)
                    NotApplicableCell(isLast: false)
                    NotApplicableCell(isLast: false)
                    NotApplicableCell(isLast: false)
                  }
                  if modelSupport.engineType.hasFuel {
                    SupportStatusV2(support: support, connectables: [.fuelTankLevel], make: make, isLast: false)
                  } else {
                    NotApplicableCell(isLast: false)
                  }
                  SupportStatusV2(support: support, connectables: [.speed], make: make, isLast: false)
                  SupportStatusV2(support: support, connectables: [.electricRange, .fuelRange], make: make, isLast: false)
                  SupportStatusV2(support: support, connectables: [.odometer], make: make, isLast: false)
                  SupportStatusV2(support: support, connectables: [.frontLeftTirePressure, .frontLeftTirePressure, .rearLeftTirePressure, .rearLeftTirePressure], make: make, isLast: true)
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
    .padding(.vertical, 16)
    .padding(32, condition: .desktop)
    .cornerRadius(.extraExtraLarge)
    .background(.zinc, darkness: 200)
    .background(.zinc, darkness: 800, condition: .dark)
    .id(modelSupport.obdbID)
  }
}

struct SupportStatusV2: View {
  let support: [MergedSupportMatrix.Connectable : MergedSupportMatrix.ModelSupport.ConnectableSupportLevel]
  let connectables: Set<MergedSupportMatrix.Connectable>
  let make: String
  let isLast: Bool

  var supported: MergedSupportMatrix.ModelSupport.ConnectableSupportLevel? {
    return connectables.compactMap { support[$0] }.max()
  }

  var body: some View {
    Bordered(showTrailingBorder: !isLast) {
      TableCell {
        HStack {
          switch supported {
          case .confirmed:
            OBDStamp()
          case .shouldBeSupported:
            OBDStamp()
              .opacity(0.25)
          case nil, .unknown:
            Text("")
              .textColor(.text, darkness: 600)
              .textColor(.text, darkness: 400, condition: .dark)
          }
          if makeConnectedAccountSupport[make]?.intersection(connectables).isEmpty == false {
            OTAStamp()
          }
        }
        .justifyContent(.center)
      }
    }
    .padding(.horizontal, 8)
  }
}
