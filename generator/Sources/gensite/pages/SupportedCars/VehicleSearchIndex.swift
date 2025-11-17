import Foundation
import VehicleSupportMatrix

struct VehicleSearchIndex {
  struct VehicleEntry: Codable {
    let m: Int     // make index
    let n: String  // model name
    let s: String  // model slug (empty for make-only entries)
    let i: String? // icon (relative path) - omitted for placeholder
    let t: String? // icon type (m=make, v=vehicle) - omitted for placeholder
    let d: Int?    // number of drivers (omitted if 0)
    let k: Int?    // number of miles (omitted if 0)
    let u: String? // unit for miles: "k" for thousands, "1" for exact (omitted if no miles)
  }

  struct Make: Codable {
    let n: String // make name
    let s: String // makeSlug
    let i: String // icon filename
    let d: Int?   // total number of drivers across all models (omitted if 0)
    let k: Int?   // total miles (omitted if 0)
    let u: String? // unit for miles: "k" for thousands, "1" for exact (omitted if no miles)
  }

  struct SearchIndex: Codable {
    let m: [Make]           // makes
    let v: [VehicleEntry]   // vehicles
  }

  static func generate(supportMatrix: MergedSupportMatrix, outputURL: URL) throws {
    var vehicles: [VehicleEntry] = []
    var makesArray: [Make] = []
    var makeIndexMap: [String: Int] = [:]

    let makeNames = supportMatrix.getAllMakes()

    // Build the makes array and index map
    // First pass: calculate totals for each make
    var makeTotals: [String: (drivers: Int, miles: Int)] = [:]
    for makeName in makeNames {
      var totalDrivers = 0
      var totalMiles = 0

      for obdbID in supportMatrix.getOBDbIDs(for: makeName) {
        guard let modelSupport = supportMatrix.getModel(id: obdbID) else {
          continue
        }
        totalDrivers += modelSupport.numberOfDrivers
        totalMiles += modelSupport.numberOfMilesDriven
      }

      makeTotals[makeName] = (totalDrivers, totalMiles)
    }

    // Second pass: create make entries
    for (index, makeName) in makeNames.enumerated() {
      let makeSlug = makeNameForSorting(makeName)
      let iconName = makeNameForIcon(makeName)
      let totals = makeTotals[makeName] ?? (0, 0)

      let (milesValue, milesUnit): (Int?, String?) = {
        if totals.miles == 0 {
          return (nil, nil)
        } else if totals.miles < 1000 {
          return (totals.miles, "1")
        } else {
          return (totals.miles / 1000, "k")
        }
      }()

      makesArray.append(Make(
        n: makeName,
        s: makeSlug,
        i: iconName + ".svg",
        d: totals.drivers > 0 ? totals.drivers : nil,
        k: milesValue,
        u: milesUnit
      ))
      makeIndexMap[makeName] = index
    }

    for makeName in makeNames {
      guard let makeIndex = makeIndexMap[makeName] else {
        continue
      }

      let makeSlug = makeNameForSorting(makeName)

      let totals = makeTotals[makeName] ?? (0, 0)

      // Calculate make-level miles
      let (makeMilesValue, makeMilesUnit): (Int?, String?) = {
        if totals.miles == 0 {
          return (nil, nil)
        } else if totals.miles < 1000 {
          return (totals.miles, "1")
        } else {
          return (totals.miles / 1000, "k")
        }
      }()

      // Add entry for the make itself (empty model name and slug)
      vehicles.append(VehicleEntry(
        m: makeIndex,
        n: "",
        s: "",
        i: nil,
        t: "m",
        d: totals.drivers > 0 ? totals.drivers : nil,
        k: makeMilesValue,
        u: makeMilesUnit
      ))

      // Add entries for each model
      for obdbID in supportMatrix.getOBDbIDs(for: makeName) {
        guard let modelSupport = supportMatrix.getModel(id: obdbID) else {
          continue
        }

        let modelSlug = modelNameForURL(modelSupport.model)

        // Only include icon properties if not using placeholder
        let (icon, iconType): (String?, String?) = !modelSupport.modelSVGs.isEmpty
          ? (modelSupport.modelSVGs[0], "v")
          : (nil, nil)

        // Calculate model-level miles
        let (modelMilesValue, modelMilesUnit): (Int?, String?) = {
          let miles = modelSupport.numberOfMilesDriven
          if miles == 0 {
            return (nil, nil)
          } else if miles < 1000 {
            return (miles, "1")
          } else {
            return (miles / 1000, "k")
          }
        }()

        vehicles.append(VehicleEntry(
          m: makeIndex,
          n: modelSupport.model,
          s: modelSlug,
          i: icon,
          t: iconType,
          d: modelSupport.numberOfDrivers > 0 ? modelSupport.numberOfDrivers : nil,
          k: modelMilesValue,
          u: modelMilesUnit
        ))
      }
    }

    let searchIndex = SearchIndex(m: makesArray, v: vehicles)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    let jsonData = try encoder.encode(searchIndex)

    let searchIndexURL = outputURL.appending(path: "vehicle-search-index.json")
    try jsonData.write(to: searchIndexURL)

    print("Generated vehicle-search-index.json with \(vehicles.count) entries")
  }
}
