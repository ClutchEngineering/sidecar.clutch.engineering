import Foundation

import Slipstream

let becomeBetaURL = URL(string: "/beta")

struct ParameterHeader: View {
  let icon: String
  let name: String
  var body: some View {
    VStack(alignment: .center) {
      Image(URL(string: "/gfx/parameters/\(icon).png"))
        .colorInvert(condition: .dark)
        .display(.inlineBlock)
        .frame(width: 24)
      Text(name)
    }
    .justifyContent(.center)
  }
}

struct SupportedSeal: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/checkmark.seal.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 24)
  }
}

struct OBDStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/obdii.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 24)
  }
}

struct OTAStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/ota.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 24)
  }
}

struct NotApplicableStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/slash.circle.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 18)
  }
}

struct SupportStatus: View {
  let supported: VehicleSupportStatus.SupportState
  let isLast: Bool

  init(supported: VehicleSupportStatus.SupportState, isLast: Bool = false) {
    self.supported = supported
    self.isLast = isLast
  }

  var body: some View {
    switch supported {
    case .all:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          HStack {
            OTAStamp()
            OBDStamp()
          }
          .justifyContent(.center)
        }
      }
      .padding(.horizontal, 8)
    case .obd:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          OBDStamp()
        }
      }
      .padding(.horizontal, 8)
    case .ota:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          OTAStamp()
        }
      }
      .padding(.horizontal, 8)
    case .unk:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          Text("No PID")
        }
      }
      .padding(.horizontal, 8)
    case .na:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          NotApplicableStamp()
        }
      }
      .padding(.horizontal, 8)
    }
  }
}

struct Bordered<Content: View>: View {
  let showTrailingBorder: Bool
  init(showTrailingBorder: Bool = true, @ViewBuilder content: @escaping () -> Content) {
    self.showTrailingBorder = showTrailingBorder
    self.content = content
  }
  @ViewBuilder let content: () -> Content
  @Environment(\.isLastRow) var isLastRow

  var edges: Edge.Set {
    var set: Edge.Set = []
    if !isLastRow {
      set.insert(.bottom)
    }
    if showTrailingBorder {
      set.insert(.right)
    }
    return set
  }

  var body: some View {
    content()
      .border(.init(.zinc, darkness: 400), width: 1, edges: edges)
      .border(.init(.zinc, darkness: 600), width: 1, edges: edges, condition: .dark)
  }
}

struct Borderless<Content: View>: View {
  @ViewBuilder let content: () -> Content

  var body: some View {
    content()
      .className("border-0")
  }
}

struct HeaderCell<Content: View>: View {
  let isLast: Bool
  @ViewBuilder let content: () -> Content

  init(isLast: Bool = false, @ViewBuilder content: @escaping () -> Content) {
    self.isLast = isLast
    self.content = content
  }

  var body: some View {
    Bordered(showTrailingBorder: !isLast) {
      TableHeaderCell(content: content)
        .padding(8)
        .background(.zinc, darkness: 200)
        .background(.zinc, darkness: 900, condition: .dark)
        .textAlignment(.center)
        .fontSize(.extraSmall, condition: .mobileOnly)
        .className("first:rounded-tl-lg")
        .className("last:rounded-tr-lg")
    }
  }
}

struct VehicleSupportStatus {
  let years: ClosedRange<Int>

  enum TestingStatus {
    case onboarded
    case partiallyOnboarded
    case testerNeeded
    case activeTester(String)
  }
  let testingStatus: TestingStatus

  enum SupportState {
    case all
    case obd
    case ota
    case unk
    case na
  }
  let stateOfCharge: SupportState
  let stateOfHealth: SupportState
  let charging: SupportState
  let cells: SupportState
  let fuelLevel: SupportState
  let speed: SupportState
  let range: SupportState
  let odometer: SupportState
  let tirePressure: SupportState

  static func testerNeeded(years: ClosedRange<Int>) -> Self {
    .init(years: years, testingStatus: .testerNeeded, stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk)
  }
}

struct MakeSupportSection: View {
  let make: Make
  let models: [Make: [Model: [VehicleSupportStatus]]].Value

  var body: some View {
    Section {
      ContentContainer {
        VStack(alignment: .center) {
          Image(URL(string: "/gfx/make/\(make.lowercased()).svg"))
            .colorInvert(condition: .dark)
            .display(.inlineBlock)
            .frame(width: 96)
          Text(make)
            .bold()
            .fontDesign("rounded")
            .fontSize(.fourXLarge)
        }
        .justifyContent(.center)
        .margin(.bottom, 16)

        VStack(alignment: .center, spacing: 16) {
          for (model, statuses) in models.sorted(by: { $0.key < $1.key }) {
            ModelSupportSection(model: model, statuses: statuses)
          }
        }
      }
    }
  }
}

struct YearsCell: View {
  let years: ClosedRange<Int>

  var body: some View {
    Bordered {
      TableCell {
        if years.lowerBound == years.upperBound {
          Text("\(years.lowerBound)")
        } else {
          Text("\(years.lowerBound)-\(years.upperBound)")
        }
      }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 12)
  }
}

struct TestingStatusCell: View {
  let status: VehicleSupportStatus

  var body: some View {
    let numberOfFeatures = 10
    switch status.testingStatus {
    case .partiallyOnboarded:
      Bordered {
        TableCell {
          Text("Partial")
        }
      }
    case .onboarded:
      Bordered {
        TableCell {
          SupportedSeal()
        }
      }
    case .activeTester(let username):
      Bordered {
        TableCell(colSpan: numberOfFeatures) {
          Text(username)
        }
      }
    case .testerNeeded:
      Bordered(showTrailingBorder: false) {
        TableCell(colSpan: numberOfFeatures) {
          Link("Tester needed", destination: becomeBetaURL)
            .textColor(.link, darkness: 700)
            .textColor(.link, darkness: 400, condition: .dark)
            .fontWeight(600)
            .underline(condition: .hover)
            .textAlignment(.leading)
        }
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 12)
    }
  }
}

struct EnvironmentAwareRow<Content: View>: View {
  let isLastRow: Bool
  @ViewBuilder
  let content: () -> Content

  var body: some View {
    TableRow {
      content()
    }
    .environment(\.isLastRow, isLastRow)
  }
}

struct ModelSupportSection: View {
  let model: Model
  let statuses: [VehicleSupportStatus]

  var body: some View {
    Div {
      HStack(alignment: .center, spacing: 16) {
        if !model.hasPrefix(" ") {
          Image(URL(string: "/gfx/model/\(model.lowercased()).svg"))
            .colorInvert(condition: .dark)
            .display(.inlineBlock)
            .frame(width: 48)
        }
        Text(model.trimmingCharacters(in: .whitespaces))
          .bold()
          .fontDesign("rounded")
          .fontSize(.extraExtraExtraLarge)
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
            HeaderCell { ParameterHeader(icon: "plug", name: "Charging") }
            HeaderCell { ParameterHeader(icon: "battery", name: "Cells") }
            HeaderCell { ParameterHeader(icon: "fuel", name: "Fuel") }
            HeaderCell { ParameterHeader(icon: "speed", name: "Speed") }
            HeaderCell { ParameterHeader(icon: "length", name: "Range") }
            HeaderCell { ParameterHeader(icon: "length", name: "Odometer") }
            HeaderCell(isLast: true) { ParameterHeader(icon: "tirepressure", name: "Tires") }
          }
          .background(.gray, darkness: 100)
          .background(.zinc, darkness: 950, condition: .dark)
          .placement(top: 0)
          TableBody {
            for (statusIndex, status) in statuses.sorted(by: { $0.years.lowerBound < $1.years.lowerBound }).enumerated() {
              EnvironmentAwareRow(isLastRow: statusIndex == statuses.count - 1) {
                YearsCell(years: status.years)
                TestingStatusCell(status: status)
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
        .frame(width: .full)
      }
      .fontSize(.extraSmall, condition: .mobileOnly)
      .textAlignment(.center)
      .margin(.horizontal, .auto)
      .border(.init(.zinc, darkness: 400), width: 1)
      .border(.init(.zinc, darkness: 600), width: 1)
      .cornerRadius(.large)
    }
    .padding(32)
    .cornerRadius(.extraExtraLarge)
    .background(.zinc, darkness: 200)
    .background(.zinc, darkness: 800, condition: .dark)
  }
}

struct SupportedCars: View {
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
              .fontSize(.fourXLarge)
              .bold()
              .fontDesign("rounded")
            Text("Find out which Sidecar features work with your car")
          }
          .textAlignment(.center)
        }
        .padding(.vertical, 16)
      }

      Section {
        ContentContainer {
          Link(becomeBetaURL) {
            VStack(alignment: .center, spacing: 4) {
              H1("Don't see your car?")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Become a Sidecar beta tester, get \(betaSubscriptionLength) months free")
                .fontSize(.extraLarge)
                .fontWeight(.medium)
                .fontDesign("rounded")
              Text("Learn more")
                .fontWeight(.bold)
                .fontDesign("rounded")
            }
            .textAlignment(.center)
            .classNames(["bg-gradient-to-tl", "from-cyan-500", "to-blue-600"])
            .transition(.all)
            .textColor(.white)
            .padding(32)
            .background(.zinc, darkness: 100)
            .background(.zinc, darkness: 900, condition: .dark)
            .cornerRadius(.extraExtraLarge)
            .margin(.horizontal, .auto)
          }
        }
        .padding(.vertical, 16)
      }
      .margin(.bottom, 32)

      ContentContainer {
        VStack(alignment: .center, spacing: 16) {
          H1("Legend")
            .fontSize(.fourXLarge)
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
        }
        .textAlignment(.center)
        .padding(.vertical, 16)
      }
      .margin(.bottom, 32)

      VStack(alignment: .center, spacing: 64) {
        for (make, models) in makes.sorted(by: { $0.key < $1.key }) {
          MakeSupportSection(make: make, models: models)
        }
      }
      .margin(.bottom, 32)
    }
  }
}

private struct IsLastRowEnvironmentKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

extension EnvironmentValues {
  fileprivate var isLastRow: Bool {
    get { self[IsLastRowEnvironmentKey.self] }
    set { self[IsLastRowEnvironmentKey.self] = newValue }
  }
}
