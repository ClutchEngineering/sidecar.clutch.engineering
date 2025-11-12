import AirtableAPI
import Foundation
import SupportMatrix

/// Provides a unified API to retrieve vehicle support information by merging Airtable data with local vehicle metadata
public class MergedSupportMatrix: @unchecked Sendable {
  /// Shared singleton instance
  public static let shared = MergedSupportMatrix()

  /// Type alias for OBDb vehicle ID (typically Make-Model format)
  public typealias OBDbID = String

  /// Type alias for the complete support matrix mapping OBDbID to ModelSupport
  public typealias OBDbVehicleSupportMatrix = [OBDbID: ModelSupport]

  /// Type alias for signal identifier (e.g., "TAYCAN_VSS")
  public typealias SignalID = String

  /// The merged support matrix containing all vehicle information
  public private(set) var supportMatrix: OBDbVehicleSupportMatrix = [:]

  /// Processed mapping of vehicle models to their signals and standard names, organized by year ranges
  public private(set) var saeConnectables: [Filter: [SignalID: Connectable]] = [:]

  /// Processed mapping of vehicle models to their signals and standard names, organized by year ranges
  public private(set) var compiledSAEConnectables: FilterableSignalMap?

  private func standardizedOBDbID(_ obdbID: OBDbID) -> OBDbID {
    return obdbID
      .lowercased()
      .replacingOccurrences(of: " ", with: "_")
      .replacingOccurrences(of: "-", with: "_")
  }

  /// Processed mapping of vehicle models to their signals and standard names, organized by year ranges
  private var connectables: [OBDbID: FilterableSignalMap] = [:]
  public func connectables(for obdbID: OBDbID) -> FilterableSignalMap {
    if let existingMap = connectables[standardizedOBDbID(obdbID)] {
      return existingMap
    }
    if let engineType = self.getModel(id: obdbID)?.engineType {
      let filteredConnectables: [Filter: [SignalID: Connectable]] = saeConnectables.mapValues {
        $0.filter {
          ($0.value.isBatteryRelated && engineType.hasBattery) || ($0.value.isFuelRelated && engineType.hasFuel) || (!$0.value.isBatteryRelated && !$0.value.isFuelRelated)
        }
      }
      return FilterableSignalMap(filterableSignals: filteredConnectables)
    }
    // No map and no engine, let's just fall back to the default SAE configuration.
    return FilterableSignalMap(filterableSignals: saeConnectables)
  }

  /// Raw data mapping from signal path to signal mappings, loaded directly from connectables.json
  typealias Path = String
  typealias Filters = String
  typealias ConnectableMap = [Path: [Filters: [SignalID: Connectable]]]
  private var rawConnectables: ConnectableMap = [:]

  private init() {}

  /// Static function to load the MergedSupportMatrix with optional caching
  /// - Parameters:
  ///   - airtableClient: The Airtable client to use for fetching models
  ///   - modelsTableID: The ID of the models table in Airtable
  ///   - workspacePath: Path to the local workspace containing vehicle metadata
  ///   - useCache: Whether to use cached data if available (and cache new data)
  /// - Returns: A tuple containing the loaded MergedSupportMatrix and a boolean indicating success
  @discardableResult
  public static func load(
    using airtableClient: AirtableClient,
    projectRoot: URL,
    modelsTableID: String,
    workspacePath: String,
    useCache: Bool = false
  ) async throws -> MergedSupportMatrix {
    let matrix: MergedSupportMatrix = MergedSupportMatrix.shared

    // Check for cached data if useCache is enabled
    if useCache {
      if let cachedMatrix = await tryLoadFromCache(projectRoot: projectRoot) {
        // We have a cached matrix - use it
        matrix.supportMatrix = cachedMatrix.supportMatrix
        print("Loaded vehicle support matrix from cache")
      }
    }

    if matrix.supportMatrix.isEmpty {
      // No cache available or caching disabled, perform full load
      try await matrix.loadAndMerge(
        using: airtableClient,
        modelsTableID: modelsTableID,
        workspacePath: workspacePath,
        projectRoot: projectRoot
      )
    }

    // Connectables require the vehicle matrix to be loaded first for engine type data.
    print("Loading connectables...")
    try matrix.loadConnectables(projectRoot: projectRoot)
    print("Loaded connectables data successfully")

    // Save to cache if successful and caching is enabled
    print("Saving to cache...")
    try await saveToCacheAsync(matrix: matrix, projectRoot: projectRoot)
    print("Cache saved successfully")

    print("Returning matrix from load()")
    return matrix
  }

  private static func getCachePath(projectRoot: URL) -> String {
    let fileManager = FileManager.default
    let path: String
    if let cachePath = ProcessInfo.processInfo.environment["CACHE_DIR"] {
      path = projectRoot.appending(path: cachePath).path()
    } else {
      path = projectRoot.appending(path: ".cache").path()
    }

    // Create cache directory if it doesn't exist
    if !fileManager.fileExists(atPath: path) {
      try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    return path
  }

  private static func getVehicleImagesPath(projectRoot: URL) -> String {
    let fileManager = FileManager.default
    let path: String
    if let cachePath = ProcessInfo.processInfo.environment["VEHICLE_IMAGES_DIR"] {
      path = projectRoot.appending(path: cachePath).path()
    } else {
      path = projectRoot.appending(path: "/site/gfx/vehicle/").path()
    }

    // Create cache directory if it doesn't exist
    if !fileManager.fileExists(atPath: path) {
      try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    return path
  }

  // Helper function to construct the cache file path
  private static func getCacheFilePath(projectRoot: URL) -> URL {
    let cacheDirectory: String = getCachePath(projectRoot: projectRoot)
    return URL(fileURLWithPath: cacheDirectory).appendingPathComponent("mergedSupportMatrix.json")
  }

  // Try to load the matrix from cache
  private static func tryLoadFromCache(projectRoot: URL) async -> MergedSupportMatrix? {
    let cacheFilePath = getCacheFilePath(projectRoot: projectRoot)

    do {
      let data = try Data(contentsOf: cacheFilePath)
      let decoder = JSONDecoder()
      let cachedMatrix = try decoder.decode(OBDbVehicleSupportMatrix.self, from: data)

      let matrix = MergedSupportMatrix()
      matrix.supportMatrix = cachedMatrix
      return matrix
    } catch {
      print("Cache read failed: \(error.localizedDescription)")
      return nil
    }
  }

  // Save matrix to cache asynchronously
  private static func saveToCacheAsync(matrix: MergedSupportMatrix, projectRoot: URL) async throws {
    let cacheFilePath = getCacheFilePath(projectRoot: projectRoot)

    print("Encoding support matrix for cache...")
    let encoder = JSONEncoder()
    let data = try encoder.encode(matrix.supportMatrix)
    print("Encoded \(data.count) bytes, writing to cache file...")
    try data.write(to: cacheFilePath)
    print("Saved vehicle support matrix to cache at \(cacheFilePath.path)")
  }

  /// Load connectables data from the .cache/connectables.json file
  /// - Throws: Error if the file doesn't exist or can't be parsed
  private func loadConnectables(projectRoot: URL) throws {
    let connectablesFilePath = Self.getConnectablesFilePath(projectRoot: projectRoot)

    guard FileManager.default.fileExists(atPath: connectablesFilePath.path) else {
      throw NSError(
        domain: "MergedSupportMatrix",
        code: 404,
        userInfo: [NSLocalizedDescriptionKey: "Connectables file not found at \(connectablesFilePath.path)"]
      )
    }

    print("Reading connectables file from \(connectablesFilePath.path)...")
    let data = try Data(contentsOf: connectablesFilePath)
    print("Decoding connectables JSON (\(data.count) bytes)...")
    let decoder = JSONDecoder()
    self.rawConnectables = try decoder.decode(ConnectableMap.self, from: data)
    print("Decoded \(rawConnectables.count) connectable entries")

    // Process the raw connectables into the structured format
    print("Processing connectables...")
    processConnectables()
    print("Finished processing connectables")
  }

  /// Process raw connectables data into structured format with OBDbIDs and year ranges
  private func processConnectables() {
    // Reset the connectables dictionary
    connectables = [:]
    self.saeConnectables = [:]

    let saeConnectables = rawConnectables["SAEJ1979/signalsets/v3/default.json"] ?? [:]

    // Prime the years with the SAE connectables
    for (filters, signals) in saeConnectables {
      let filter = Filter(rawValue: filters)
      for (signalID, connectable) in signals {
        self.saeConnectables[filter, default: [:]][signalID] = connectable
      }
    }
    compiledSAEConnectables = .init(filterableSignals: self.saeConnectables)

    // Process the new structure where each path maps to a dictionary of filter keys to signal mappings
    // E.g.:
    // ```
    // "Hyundai-Elantra/signalsets/v3/default.json": {
    //   "2021<=": {
    //     "ELANTRA_TP_FL": "frontLeftTirePressure",
    //     "ELANTRA_TP_FR": "frontRightTirePressure",
    //     "ELANTRA_TP_RR": "rearRightTirePressure",
    //     "ELANTRA_TP_RL": "rearLeftTirePressure"
    //   },
    //   "<=2020": {
    //     "ELANTRA_TP_FL_PRE21": "frontLeftTirePressure",
    //     "ELANTRA_TP_FR_PRE21": "frontRightTirePressure",
    //     "ELANTRA_TP_RR_PRE21": "rearRightTirePressure",
    //     "ELANTRA_TP_RL_PRE21": "rearLeftTirePressure"
    //   },
    //   "NO_FILTER_APPLICABLE" or "ALL": {
    //     "ELANTRA_VSS": "speed",
    //     "ELANTRA_ODO_KM": "odometer",
    //     "ELANTRA_ODO_MI": "odometer"
    //   }
    // },
    // ```
    for (path, filterMappings) in rawConnectables {
      // Skip the SAE connectables as they've already been processed
      if path == "SAEJ1979/signalsets/v3/default.json" {
        continue
      }

      // Extract OBDbID and potential year range from the path
      // Format examples:
      // - "Audi-TT/signalsets/v3/default.json" -> OBDbID: "Audi-TT", YearRange: nil
      // - "Ford-F-150/signalsets/v3/2015-2018.json" -> OBDbID: "Ford-F-150", YearRange: 2015...2018
      let components = path.components(separatedBy: "/")
      guard components.count >= 4 else {
        continue
      }

      let obdbID = components[0]

      guard obdbID.contains("-") else {
        continue
      }

      let engineType: ModelSupport.EngineType
      if let knownEngineType = self.getModel(id: obdbID)?.engineType {
        engineType = knownEngineType
      } else {
        // If the engine type is not known, we can either skip or assign a default value
        // Here we choose to skip for safety
        print("Warning: Unknown engine type for OBDbID: \(obdbID)")
        continue
      }

      // Process each filter mapping (e.g., "2021<=", "<=2020", etc.)
      for (filterKey, signalMappings) in filterMappings {
        let filter: Filter = Filter(rawValue: filterKey)

        // Add each signal in this filter's mapping to the connectables
        for (signalID, connectable) in signalMappings {
          // Ensure the connectable is appropriate for this vehicle's engine type
          guard (connectable.isBatteryRelated && engineType.hasBattery) ||
                (connectable.isFuelRelated && engineType.hasFuel) ||
                (!connectable.isBatteryRelated && !connectable.isFuelRelated) else {
            continue
          }

          // Add the signal to the year range signal map
          connectables[standardizedOBDbID(obdbID), default: FilterableSignalMap()][filter, default: [:]][signalID] = connectable
        }
      }

      // Add SAE connectables that are appropriate for this vehicle's engine type
      for (filters, signals) in saeConnectables {
        let filter = Filter(rawValue: filters)
        for (signalID, connectable) in signals {
          // Skip SAE connectables that don't match this vehicle's engine type
          guard (connectable.isBatteryRelated && engineType.hasBattery) ||
                  (connectable.isFuelRelated && engineType.hasFuel) ||
                  (!connectable.isBatteryRelated && !connectable.isFuelRelated) else {
            continue
          }

          // Add SAE connectables with the filename's year range
          connectables[standardizedOBDbID(obdbID), default: FilterableSignalMap()][filter, default: [:]][signalID] = connectable
        }
      }
    }
  }

  /// Get the path to the connectables file
  /// - Returns: URL to the connectables.json file
  private static func getConnectablesFilePath(projectRoot: URL) -> URL {
    let cacheDirectory: String = getCachePath(projectRoot: projectRoot)
    return URL(fileURLWithPath: cacheDirectory).appendingPathComponent("connectables.json")
  }

  /// Load and merge vehicle data from Airtable and local vehicle metadata
  /// - Parameters:
  ///   - airtableClient: The Airtable client to use for fetching models
  ///   - modelsTableID: The ID of the models table in Airtable
  ///   - workspacePath: Path to the local workspace containing vehicle metadata
  /// - Returns: A boolean indicating whether the operation was successful
  public func loadAndMerge(
    using airtableClient: AirtableClient,
    modelsTableID: String,
    workspacePath: String,
    projectRoot: URL
  ) async throws {
    supportMatrix = [:]

    // 1. Fetch models from Airtable
    let sortedRecords: [AirtableRecord] = try await airtableClient.fetchModels(from: modelsTableID)

    // 2. Create initial support matrix with Airtable data
    for record: AirtableRecord in sortedRecords {
      guard let make = record.fields.make,
            let model = record.fields.model,
            let obdbID = record.fields.obdbID,
            let engineType = record.fields.engineType else {
        print("Unknown record: \(record)")
        continue
      }
      let modelSVGs = record.fields.symbolSVG?.map { $0.filename } ?? []
      let numberOfDrivers: Int = record.fields.numberOfDrivers ?? 0
      let numberOfMilesDriven: Int = record.fields.numberOfMilesDriven ?? 0
      let onboarded = record.fields.onboarded ?? false

      guard let engineType = ModelSupport.EngineType(rawValue: engineType) else {
        print("Error: Unknown engine type: \(engineType)")
        continue
      }

      supportMatrix[standardizedOBDbID(obdbID)] = ModelSupport(
        obdbID: obdbID,
        make: make,
        model: model,
        engineType: engineType,
        modelSVGs: modelSVGs,
        numberOfDrivers: numberOfDrivers,
        numberOfMilesDriven: numberOfMilesDriven,
        onboarded: onboarded
      )

      if let symbolSVGs = record.fields.symbolSVG {
        await withTaskGroup(of: Void.self) { taskGroup in
          for asset in symbolSVGs {
            // Download and cache image assets
            taskGroup.addTask {
              await self.downloadAndCacheAsset(url: URL(string: asset.url)!, filename: asset.filename, projectRoot: projectRoot)
            }
          }
        }
      }
    }

    // 3. Load local vehicle metadata
    print("Loading vehicle metadata from workspace...")
    try SupportMatrix.shared.loadVehicleMetadata(from: workspacePath)
    print("Vehicle metadata loaded successfully")

    // 4. Merge with local metadata if available
    print("Merging with local metadata...")
    if let vehicleMetadata = SupportMatrix.shared.vehicleMetadata {
      for (make, models) in vehicleMetadata.vehicles {
        for (model, years) in models {
          let obdbID = make + "-" + model
          supportMatrix[standardizedOBDbID(obdbID)]?.yearCommandSupport = years
        }
      }

      // Add confirmed signals from metadata
      for (make, models) in vehicleMetadata.confirmedSignals {
        for (model, years) in models {
          let obdbID = make + "-" + model
          supportMatrix[standardizedOBDbID(obdbID)]?.yearConfirmedSignals = years
        }
      }

      // Add generations data from metadata
      for (make, models) in vehicleMetadata.generations {
        for (model, generations) in models {
          let obdbID = make + "-" + model
          supportMatrix[standardizedOBDbID(obdbID)]?.generations = generations
        }
      }
    }
    print("Support matrix loading completed successfully")
  }

  /// Download and cache an asset from a URL if it doesn't already exist in the cache
  /// - Parameters:
  ///   - url: The URL of the asset to download
  ///   - filename: The filename to use when saving the asset
  private func downloadAndCacheAsset(url: URL, filename: String, projectRoot: URL) async {
    let fileManager = FileManager.default
    let cacheDirectory = Self.getVehicleImagesPath(projectRoot: projectRoot)
    let filePath = URL(fileURLWithPath: cacheDirectory).appendingPathComponent(filename)

    // Check if file already exists in cache
    if fileManager.fileExists(atPath: filePath.path) {
      // File already cached, no need to download
      return
    }

    // Download the file
    do {
      let (data, response) = try await URLSession.shared.data(from: url)

      // Verify we got a successful response
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error downloading asset from \(url): Invalid response")
        return
      }

      // Write file to cache
      try data.write(to: filePath)
      print("Successfully cached asset: \(filename)")
    } catch {
      print("Error downloading or caching asset \(filename): \(error.localizedDescription)")
    }
  }

  /// Get all makes from the merged support matrix
  /// - Returns: Array of make names
  public func getAllMakes() -> [String] {
    return Array(Set(supportMatrix.values.map { $0.make })).sorted()
  }

  /// Get models for a specific make
  /// - Parameter make: The vehicle make
  /// - Returns: Array of model names for the given make
  public func getModels(for make: String) -> [String] {
    return supportMatrix.values
      .filter { $0.make == make }
      .map { $0.model }
      .sorted()
  }

  /// Get models for a specific make
  /// - Parameter make: The vehicle make
  /// - Returns: Array of model names for the given make
  public func getModel(id: OBDbID) -> ModelSupport? {
    return supportMatrix[standardizedOBDbID(id)]
  }

  /// Get OBDbIDs for a specific make
  /// - Parameter make: The vehicle make
  /// - Returns: Array of OBDbID values for the given make
  public func getOBDbIDs(for make: String) -> [OBDbID] {
    return supportMatrix
      .filter { $0.value.make == make }
      .map { $0.key }
      .sorted()
  }

  /// Get statistics about the merged support matrix
  /// - Returns: A tuple containing counts of makes, models, and model years
  public func getStatistics() -> (makes: Int, models: Int, modelYears: Int) {
    let makes = Set(supportMatrix.values.map { $0.make }).count
    let models = supportMatrix.count

    var totalYears = 0
    for (_, modelSupport) in supportMatrix {
      totalYears += modelSupport.yearCommandSupport.count
    }

    return (makes: makes, models: models, modelYears: totalYears)
  }
}
