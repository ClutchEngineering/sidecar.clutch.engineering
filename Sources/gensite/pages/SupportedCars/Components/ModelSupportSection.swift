import Foundation
import Slipstream
import VehicleSupport

struct ModelSupportSection: View {
  let make: Make
  let model: Model
  let statuses: [VehicleSupportStatus]
  let becomeBetaURL: URL?

  init(make: Make, model: Model, statuses: [VehicleSupportStatus], becomeBetaURL: URL? = URL(string: "/beta")) {
    self.make = make
    self.model = model
    self.statuses = statuses
    self.becomeBetaURL = becomeBetaURL
  }

  var body: some View {
    let id = "\(make)-\(model.name)"
    Div {
      VStack(alignment: .center, spacing: 4) {
        Link(URL(string: "#" + id)) {
          Text(model.name)
            .bold()
            .fontDesign("rounded")
            .fontSize(.large)
            .fontSize(.extraLarge, condition: .desktop)
            .underline(condition: .hover)
        }
        Link(URL(string: "https://github.com/OBDb/\(make)-\(model.name.replacingOccurrences(of: " ", with: "-"))")) {
          Text("OBDb")
            .bold()
            .fontDesign("rounded")
            .fontSize(.small)
            .textColor(.link, darkness: 700)
            .textColor(.link, darkness: 400, condition: .dark)
            .underline(condition: .hover)
        }
        if let symbolName = model.symbolName {
          Image(URL(string: "/gfx/model/\(symbolName).svg"))
            .colorInvert(condition: .dark)
            .display(.inlineBlock)
            .frame(width: 128)
        }
      }
      .justifyContent(.center)
      .margin(.bottom, 16)
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
            for (statusIndex, status) in statuses.sorted(by: { $0.years.lowerBound < $1.years.lowerBound }).enumerated() {
              EnvironmentAwareRow(isLastRow: statusIndex == statuses.count - 1) {
                YearsCell(years: status.years)
                TestingStatusCell(status: status, becomeBetaURL: becomeBetaURL)
                if case .testerNeeded = status.testingStatus {
                  // Do nothing.
                } else {
                  SupportStatus(supported: status.stateOfCharge)
                  SupportStatus(supported: status.stateOfHealth)
                  SupportStatus(supported: status.charging)
                  SupportStatus(supported: status.cells)
                  SupportStatus(supported: status.fuelLevel)
                  SupportStatus(supported: status.speed)
                  SupportStatus(supported: status.range)
                  SupportStatus(supported: status.odometer)
                  SupportStatus(supported: status.tirePressure, isLast: true)
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
    .id(id)
  }
}