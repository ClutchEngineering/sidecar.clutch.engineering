import Foundation

package struct VehicleSupportEntry: Codable, Comparable, Equatable {
  let make: String
  let model: Model
  let supportStatuses: [VehicleSupportStatus]

  // Implement Equatable
  package static func == (lhs: VehicleSupportEntry, rhs: VehicleSupportEntry) -> Bool {
    lhs.make == rhs.make &&
    lhs.model == rhs.model &&
    lhs.supportStatuses == rhs.supportStatuses
  }

  // Implement Comparable
  package static func < (lhs: VehicleSupportEntry, rhs: VehicleSupportEntry) -> Bool {
    if lhs.make != rhs.make {
      return lhs.make < rhs.make
    }
    return lhs.model < rhs.model
  }
}

extension Array where Element == VehicleSupportEntry {
  package func toGroupedDictionary() -> [Make: [Model: [VehicleSupportStatus]]] {
    Dictionary(grouping: self) { $0.make }
      .mapValues { (entries: [VehicleSupportEntry]) -> [Model: [VehicleSupportStatus]] in
        Dictionary(uniqueKeysWithValues: entries.map { ($0.model, $0.supportStatuses) })
      }
  }
}
