import Foundation

import Slipstream
import VehicleSupport

let becomeBetaURL = URL(string: "/beta")

func makeNameForSorting(_ string: Make) -> String {
  string
    .replacingOccurrences(of: " ", with: "")
    .applyingTransform(.stripDiacritics, reverse: false)!
}

func modelNameForSorting(_ model: Model) -> String {
  model.name
    .replacingOccurrences(of: " ", with: "")
    .applyingTransform(.stripDiacritics, reverse: false)!
}

struct ParameterHeader: View {
  let icon: String
  let name: String
  var body: some View {
    VStack(alignment: .center) {
      Image(URL(string: "/gfx/parameters/\(icon).png"))
        .colorInvert(condition: .dark)
        .display(.inlineBlock)
        .frame(width: 18)
        .frame(width: 24, condition: .desktop)
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
      .frame(width: 18)
      .frame(width: 24, condition: .desktop)
  }
}

struct OBDStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/obdii.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 18)
      .frame(width: 24, condition: .desktop)
  }
}

struct OTAStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/ota.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 18)
      .frame(width: 24, condition: .desktop)
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
  let supported: VehicleSupportStatus.SupportState?
  let isLast: Bool

  init(supported: VehicleSupportStatus.SupportState?, isLast: Bool = false) {
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
    case .none:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          Text("PID?")
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
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

struct MakeCard: View {
  let make: Make
  var body: some View {
    VStack(alignment: .center) {
      Image(URL(string: "/gfx/make/\(make.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-s", with: "").applyingTransform(.stripDiacritics, reverse: false)!.lowercased()).svg"))
        .colorInvert(condition: .dark)
        .display(.inlineBlock)
        .frame(width: 48)
        .frame(width: 76, condition: .desktop)
      Text(make)
        .bold()
        .fontDesign("rounded")
        .fontSize(.large)
        .fontSize(.extraExtraExtraLarge, condition: .desktop)
    }
    .justifyContent(.center)
  }
}

struct MakeSupportSection: View {
  let make: Make
  let models: [Make: [Model: [VehicleSupportStatus]]].Value

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

        VStack(alignment: .leading, spacing: 16) {
          for (model, statuses) in models.sortedByLocalizedStandard() {
            ModelSupportSection(make: make, model: model, statuses: statuses)
          }
        }
        .alignItems(.center, condition: .desktop)
      }
    }
    .id(make)
  }
}

struct CustomStringComparator {
  static func compare(_ lhs: Model, _ rhs: Model) -> Bool {
    let normalizedLhs = modelNameForSorting(lhs)
    let normalizedRhs = modelNameForSorting(rhs)
    return normalizedLhs.localizedStandardCompare(normalizedRhs) == .orderedAscending
  }
}

extension Dictionary where Key == Model {
  func sortedByLocalizedStandard() -> [(key: Key, value: Value)] {
    sorted { lhs, rhs in
      CustomStringComparator.compare(lhs.key, rhs.key)
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
          Link("Tester needed", destination: becomeBetaURL)
            .textColor(.link, darkness: 700)
            .textColor(.link, darkness: 400, condition: .dark)
            .fontWeight(600)
            .underline(condition: .hover)
            .textAlignment(.leading)
        }
      }
      .padding(.horizontal, 4)
      .padding(.horizontal, 8, condition: .desktop)
      .padding(.vertical, 12)
    case .onboarded:
      Bordered {
        TableCell {
          SupportedSeal()
        }
      }
    case .activeTester(let username):
      Bordered {
        TableCell {
          VStack(alignment: .center) {
            Text("Tester")
              .fontSize(.small)
              .textColor(.text, darkness: 500)
              .fontWeight(.medium)
            Link(username, destination: URL(string: "https://meta.cars.forum/memberlist.php?mode=viewprofile&un=\(username)"))
              .textColor(.link, darkness: 700)
              .textColor(.link, darkness: 400, condition: .dark)
              .fontWeight(600)
              .underline(condition: .hover)
              .textAlignment(.leading)
          }
        }
      }
      .padding(.horizontal, 4)
      .padding(.horizontal, 8, condition: .desktop)
      .padding(.vertical, 12)
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
      .padding(.horizontal, 4)
      .padding(.horizontal, 8, condition: .desktop)
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
  let make: Make
  let model: Model
  let statuses: [VehicleSupportStatus]

  var body: some View {
    let id = "\(make)-\(model.name)"
    Div {
      HStack(alignment: .center, spacing: 16) {
        if model.name == "1500" {
          let _ = print("foo")
        }
        if let symbolName = model.symbolName {
          Image(URL(string: "/gfx/model/\(symbolName).svg"))
            .colorInvert(condition: .dark)
            .display(.inlineBlock)
            .frame(width: 48)
        }
        Link(URL(string: "#" + id)) {
          Text(model.name)
            .bold()
            .fontDesign("rounded")
            .fontSize(.large, condition: .desktop)
            .fontSize(.extraExtraExtraLarge, condition: .desktop)
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

struct SupportedCars: View {
  let makes: [Make: [Model: [VehicleSupportStatus]]]

  init() {
    makes = try! VehicleSupportStatus.loadAll()
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
        ContentContainer {
          H1("Jump to your make")
            .fontSize(.extraLarge)
            .fontSize(.fourXLarge, condition: .desktop)
            .bold()
            .fontDesign("rounded")
            .textAlignment(.center)
            .margin(.bottom, 32)

          Div {
            for make in makes.keys.sorted(by: { makeNameForSorting($0) < makeNameForSorting($1) }) {
              MakeLink(make: make)
            }
          }
          .display(.grid)
          .classNames(["grid-cols-3", "md:grid-cols-5", "gap-x-4", "gap-y-8"])
        }
      }
      .margin(.vertical, 32)

      HorizontalRule()

      VStack(alignment: .center, spacing: 64) {
        for (make, models) in makes.sorted(by: { $0.key.lowercased() < $1.key.lowercased() }) {
          MakeSupportSection(make: make, models: models)
        }
      }
      .margin(.vertical, 32)
    }
  }
}

struct MakeLink: View {
  let make: Make
  var body: some View {
    Link(URL(string: "#\(make)")) {
      MakeCard(make: make)
    }
    .underline(condition: .hover)
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
