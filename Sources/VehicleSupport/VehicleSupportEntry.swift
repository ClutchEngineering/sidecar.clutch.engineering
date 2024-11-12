import Foundation

package struct VehicleSupportEntry: Codable, Comparable, Equatable {
  let make: String
  let model: ModelInfo
  let supportStatuses: [VehicleSupportStatus]

  package struct ModelInfo: Codable, Comparable, Equatable, Hashable {
    let name: String
    let symbolName: String?

    // Implement Equatable
    package static func == (lhs: ModelInfo, rhs: ModelInfo) -> Bool {
      lhs.name == rhs.name && lhs.symbolName == rhs.symbolName
    }

    // Implement Comparable
    package static func < (lhs: ModelInfo, rhs: ModelInfo) -> Bool {
      lhs.name < rhs.name
    }
  }

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

// MARK: - Migration Helpers

extension Array where Element == VehicleSupportEntry {
  package func toGroupedDictionary() -> [Make: [VehicleSupportEntry.ModelInfo: [VehicleSupportStatus]]] {
    Dictionary(grouping: self) { $0.make }
      .mapValues { entries in
        Dictionary(uniqueKeysWithValues: entries.map { ($0.model, $0.supportStatuses) })
      }
  }
}

func migrateVehicleSupport(from oldFormat: [String: [Model: [VehicleSupportStatus]]]) -> [VehicleSupportEntry] {
  var entries: [VehicleSupportEntry] = []

  for (make, modelDict) in oldFormat {
    for (model, statuses) in modelDict {
      let modelInfo = VehicleSupportEntry.ModelInfo(
        name: model.model,
        symbolName: model.symbolName
      )

      let entry = VehicleSupportEntry(
        make: make,
        model: modelInfo,
        supportStatuses: statuses
      )

      entries.append(entry)
    }
  }

  // Sort entries by make and model
  return entries.sorted()
}

package func migrateSupportMatrix() throws {
  // Load existing format
  let oldFormatData = try VehicleSupportStatus.loadAll()

  // Convert to new format
  let newFormatData = migrateVehicleSupport(from: oldFormatData)

  // Encode with pretty printing
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
  let jsonData = try encoder.encode(newFormatData)

  let json = String(data: jsonData, encoding: .utf8)
  print(json!)
}

extension VehicleSupportStatus {
  static func loadFromArray() throws -> [String: [VehicleSupportEntry.ModelInfo: [VehicleSupportStatus]]] {
    let url = Bundle.module.url(forResource: "supportmatrix", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let entries = try JSONDecoder().decode([VehicleSupportEntry].self, from: data)
    return entries.toGroupedDictionary()
  }
}
