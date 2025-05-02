import Foundation
import Slipstream
import VehicleSupport

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

func makeNameForIcon(_ make: Make) -> String {
  make
    .replacingOccurrences(of: " ", with: "")
    .replacingOccurrences(of: "-s", with: "")
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

struct MakeLink: View {
  let make: Make
  var body: some View {
    Link(URL(string: "#\(make)")) {
      MakeCard(make: make)
    }
    .underline(condition: .hover)
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