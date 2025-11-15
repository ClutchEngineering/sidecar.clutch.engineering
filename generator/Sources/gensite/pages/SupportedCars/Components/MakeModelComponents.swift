import Foundation
import Slipstream
import VehicleSupport
import VehicleSupportMatrix

func makeNameForSorting(_ string: Make) -> String {
  string
    .lowercased()
    .replacingOccurrences(of: " ", with: "-")
    .applyingTransform(.stripDiacritics, reverse: false)!
}

func modelNameForSorting(_ model: Model) -> String {
  model.name
    .lowercased()
    .replacingOccurrences(of: " ", with: "-")
    .applyingTransform(.stripDiacritics, reverse: false)!
}

func modelNameForURL(_ modelName: String) -> String {
  modelName
    .lowercased()
    .replacingOccurrences(of: " ", with: "-")
    .applyingTransform(.stripDiacritics, reverse: false)!
}

func makeNameForIcon(_ make: Make) -> String {
  make
    .replacingOccurrences(of: " ", with: "")
    .replacingOccurrences(of: "-", with: "")
    .replacingOccurrences(of: "/", with: "-")
    .applyingTransform(.stripDiacritics, reverse: false)!
    .lowercased()
}

struct MakeCard: View {
  let make: Make

  var formattedMake: String {
    makeNameForIcon(make)
  }

  var body: some View {
    VStack(alignment: .center) {
      Image(URL(string: "/gfx/make/\(formattedMake).svg"))
        .colorInvert(condition: .dark)
        .display(.inlineBlock)
        .frame(width: 48)
        .frame(width: 76, condition: .desktop)
      Text(make)
        .bold()
        .fontDesign("rounded")
        .fontSize(.large)
        .fontSize(.extraExtraLarge, condition: .desktop)
    }
    .justifyContent(.center)
  }
}

struct MakeGridCard: View {
  let make: Make

  var formattedMake: String {
    makeNameForIcon(make)
  }

  var body: some View {
    VStack(alignment: .center) {
      Image(URL(string: "/gfx/make/\(formattedMake).svg"))
        .colorInvert(condition: .dark)
        .display(.inlineBlock)
        .frame(width: 48)
        .frame(width: 76, condition: .desktop)
      Text(make)
        .bold()
        .fontDesign("rounded")
        .fontSize(.large)
        .fontSize(.extraExtraLarge, condition: .desktop)
    }
    .justifyContent(.center)
  }
}

struct MakeLink: View {
  let make: Make
  var body: some View {
    Link(MakeLink.url(for: make)) {
      MakeGridCard(make: make)
    }
    .underline(condition: .hover)
  }

  static func url(for make: Make) -> URL? {
    URL(string: "/supported-cars/\(makeNameForSorting(make))")
  }
}

struct ModelLink {
  static func url(for make: Make, model: String) -> URL? {
    URL(string: "/supported-cars/\(makeNameForSorting(make))/\(modelNameForURL(model))")
  }
}

struct ModelCard: View {
  let make: Make
  let modelSupport: MergedSupportMatrix.ModelSupport

  enum PresenceLevel {
    case strongest
    case medium
    case standard
  }

  var presenceLevel: PresenceLevel {
    let hasDrivers = modelSupport.numberOfDrivers > 0
    let hasSymbol = !modelSupport.modelSVGs.isEmpty

    if hasDrivers,
       hasSymbol {
      return .strongest
    } else if hasDrivers || hasSymbol {
      return .medium
    } else {
      return .standard
    }
  }

  var body: some View {
    switch presenceLevel {
    case .strongest:
      Link(ModelLink.url(for: make, model: modelSupport.model)) {
        cardContent
          .padding(16)
          .background(.zinc, darkness: 50)
          .background(.zinc, darkness: 200, condition: .hover)
          .background(.zinc, darkness: 800, condition: .dark)
          .background(.zinc, darkness: 700, condition: .init(state: [.hover, .dark]))
          .cornerRadius(.extraLarge)
          .border(.init(.zinc, darkness: 600), width: 1, condition: .dark)
          .shadow("puck")
          .transition(.all)
      }
      .textDecoration(.none)

    case .medium:
      Link(ModelLink.url(for: make, model: modelSupport.model)) {
        cardContent
          .padding(16)
          .background(.zinc, darkness: 100)
          .background(.zinc, darkness: 200, condition: .hover)
          .background(.zinc, darkness: 900, condition: .dark)
          .background(.zinc, darkness: 800, condition: .init(state: [.hover, .dark]))
          .cornerRadius(.extraLarge)
          .border(.init(.zinc, darkness: 300), width: 1)
          .border(.init(.zinc, darkness: 700), width: 1, condition: .dark)
          .transition(.all)
      }
      .textDecoration(.none)

    case .standard:
      Link(ModelLink.url(for: make, model: modelSupport.model)) {
        cardContent
          .padding(16)
          .background(.zinc, darkness: 100)
          .background(.zinc, darkness: 200, condition: .hover)
          .background(.zinc, darkness: 950, condition: .dark)
          .background(.zinc, darkness: 900, condition: .init(state: [.hover, .dark]))
          .cornerRadius(.extraLarge)
          .transition(.all)
      }
      .textDecoration(.none)
    }
  }

  @ViewBuilder
  var cardContent: some View {
    VStack(alignment: .center, spacing: 8) {
      if !modelSupport.modelSVGs.isEmpty {
        Image(URL(string: "/gfx/vehicle/\(modelSupport.modelSVGs[0])"))
          .colorInvert(condition: .dark)
          .display(.inlineBlock)
          .frame(width: 64)
          .frame(width: 96, condition: .desktop)
      } else {
        Image(URL(string: "/gfx/placeholder-car.png"))
          .colorInvert(condition: .dark)
          .display(.inlineBlock)
          .frame(width: 48)
          .frame(width: 64, condition: .desktop)
          .margin(14)
          .margin(24, condition: .desktop)
      }
      Text(modelSupport.model)
        .bold()
        .fontDesign("rounded")
        .fontSize(.base)
        .fontSize(.large, condition: .desktop)
        .textAlignment(.center)
      VStack(alignment: .center, spacing: 4) {
        if modelSupport.numberOfMilesDriven > 0 {
          Text("\(NumberFormatter.localizedString(from: NSNumber(value: modelSupport.numberOfMilesDriven), number: .decimal)) miles")
            .fontSize(.extraSmall)
            .fontSize(.small, condition: .desktop)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        } else {
          Text("Not driven yet")
            .fontSize(.extraSmall)
            .fontSize(.small, condition: .desktop)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
        if modelSupport.numberOfDrivers > 0 {
          Text("\(NumberFormatter.localizedString(from: NSNumber(value: modelSupport.numberOfDrivers), number: .decimal)) drivers")
            .fontSize(.extraSmall)
            .fontSize(.small, condition: .desktop)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        } else {
          Text("No drivers yet")
            .fontSize(.extraSmall)
            .fontSize(.small, condition: .desktop)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
      }
    }
  }
}

struct CustomStringComparator {
  static func compare(_ lhs: Model, _ rhs: Model) -> Bool {
    let normalizedLhs = modelNameForSorting(lhs)
    let normalizedRhs = modelNameForSorting(rhs)
    return normalizedLhs.localizedStandardCompare(normalizedRhs) == .orderedAscending
  }
}

extension Dictionary where Key == Model, Value == [VehicleSupportStatus] {
  func sortedByLocalizedStandard() -> [(key: Key, value: Value)] {
    sorted { lhs, rhs in
      if lhs.key.name == rhs.key.name,
         let yearA = lhs.value.first?.years.lowerBound,
         let yearB = rhs.value.first?.years.lowerBound {
        return yearA < yearB
      }
      return CustomStringComparator.compare(lhs.key, rhs.key)
    }
  }
}