import Foundation
import VehicleSupportMatrix

struct VehicleSearchIndex {
  struct VehicleEntry: Codable {
    let make: String
    let makeSlug: String
    let model: String
    let modelSlug: String
    let url: String
    let iconPath: String
  }

  struct SearchIndex: Codable {
    let vehicles: [VehicleEntry]
  }

  static func generate(supportMatrix: MergedSupportMatrix, outputURL: URL) throws {
    var vehicles: [VehicleEntry] = []

    let makes = supportMatrix.getAllMakes()

    for make in makes {
      let makeSlug = makeNameForSorting(make)
      let iconPath = "/gfx/make/\(makeNameForIcon(make)).svg"

      // Add entry for the make itself
      vehicles.append(VehicleEntry(
        make: make,
        makeSlug: makeSlug,
        model: "",
        modelSlug: "",
        url: "/supported-cars/\(makeSlug)/",
        iconPath: iconPath
      ))

      // Add entries for each model
      for obdbID in supportMatrix.getOBDbIDs(for: make) {
        guard let modelSupport = supportMatrix.getModel(id: obdbID) else {
          continue
        }

        let modelSlug = modelNameForURL(modelSupport.model)
        let modelIconPath = !modelSupport.modelSVGs.isEmpty
          ? "/gfx/vehicle/\(modelSupport.modelSVGs[0])"
          : "/gfx/placeholder-car.png"

        vehicles.append(VehicleEntry(
          make: make,
          makeSlug: makeSlug,
          model: modelSupport.model,
          modelSlug: modelSlug,
          url: "/supported-cars/\(makeSlug)/\(modelSlug)/",
          iconPath: modelIconPath
        ))
      }
    }

    let searchIndex = SearchIndex(vehicles: vehicles)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let jsonData = try encoder.encode(searchIndex)

    let searchIndexURL = outputURL.appending(path: "vehicle-search-index.json")
    try jsonData.write(to: searchIndexURL)

    print("Generated vehicle-search-index.json with \(vehicles.count) entries")
  }
}
