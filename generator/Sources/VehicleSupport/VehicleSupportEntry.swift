import Foundation

package struct VehicleSupportEntry: Codable, Comparable, Equatable {
  package let make: String
  package let model: Model
  package var supportStatuses: [VehicleSupportStatus]

  package init(make: String, model: Model, supportStatuses: [VehicleSupportStatus]) {
    self.make = make
    self.model = model
    self.supportStatuses = supportStatuses
  }

  package static func == (lhs: VehicleSupportEntry, rhs: VehicleSupportEntry) -> Bool {
    lhs.make == rhs.make &&
    lhs.model == rhs.model &&
    lhs.supportStatuses == rhs.supportStatuses
  }

  package static func < (lhs: VehicleSupportEntry, rhs: VehicleSupportEntry) -> Bool {
    if lhs.make != rhs.make {
      return lhs.make < rhs.make
    }
    return lhs.model < rhs.model
  }
}

package func localizedNameForStandardizedMake(_ make: String) -> String {
  switch make {
  case "alfaromeo": return "Alfa Romeo"
  case "bmw": return "BMW"
  case "citroen": return "Citroën"
  case "greatwall": return "GWM"
  case "gwm": return "GWM"
  case "gmc": return "GMC"
  case "landrover": return "Land Rover"
  case "mg": return "MG"
  case "smart": return "smart"
  case "skoda": return "Škoda"
  default: return make.capitalized
  }
}

package func standardizeMake(_ make: String) -> String {
  let normalizedMake = make.lowercased()
  let mapping: [String: String] = [
    "audidi": "audi",
    "audu": "audi",
    "bmw4series": "bmw",
    "alfa romeo": "alfaromeo",
    "great wall": "gwm",
    "land rover": "landrover",
    "peugeot iran khodro": "peugeot",
    "mercedes-benz": "mercedes",
    "mercedes benz": "mercedes",
    "opel": "vauxhall-opel",
    "citroën": "citroen",
    "vw": "Volkswagen",
    "vauxhall": "vauxhall-opel",
    "vauxhall/opel": "vauxhall-opel",
  ]

  let make = mapping[normalizedMake] ?? normalizedMake
  let standardizedMake = make
    .replacingOccurrences(of: " ", with: "")
    .replacingOccurrences(of: "-s", with: "")
    .replacingOccurrences(of: "/", with: "-")
    .applyingTransform(.stripDiacritics, reverse: false)!
    .lowercased()
  return mapping[standardizedMake] ?? standardizedMake
}

extension Array where Element == VehicleSupportEntry {
  package func toGroupedDictionary() -> [Make: [Model: [VehicleSupportStatus]]] {
    Dictionary(grouping: self) { standardizeMake($0.make) }
      .mapValues { (entries: [VehicleSupportEntry]) -> [Model: [VehicleSupportStatus]] in
        Dictionary(uniqueKeysWithValues: entries.compactMap {
          guard !$0.model.name.isEmpty,
                $0.model.name != "Unknown",
                $0.model.name != "/" else {
            return nil
          }
          return ($0.model, $0.supportStatuses)
        })
      }
      .filter { !$0.key.isEmpty && $0.key != "Unknown" && $0.key != "/" }
  }
}
