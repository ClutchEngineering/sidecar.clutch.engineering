import AirtableAPI
import Foundation
import SupportMatrix

/// Provides a unified API to retrieve vehicle support information by merging Airtable data with local vehicle metadata
public class MergedSupportMatrix: @unchecked Sendable {
  /// Shared singleton instance
  public static let shared = MergedSupportMatrix()

  /// Structure to hold combined model data with command support information
  public struct ModelSupport: Codable {
    public let obdbID: OBDbID
    public let make: String
    public let model: String
    public enum EngineType: String, Codable {
      case combustion = "Combustion"
      case hybrid = "Hybrid"
      case electric = "Electric"

      public var hasBattery: Bool {
        switch self {
        case .combustion:
          return false
        case .hybrid, .electric:
          return true
        }
      }
      public var hasFuel: Bool {
        switch self {
        case .combustion:
          return true
        case .hybrid, .electric:
          return false
        }
      }
    }
    public let engineType: EngineType
    public let modelSVGs: [String]
    public let numberOfDrivers: Int
    public let numberOfMilesDriven: Int
    public let onboarded: Bool

    enum CodingKeys: String, CodingKey {
      case obdbID
      case make
      case model
      case engineType
      case modelSVGs
      case onboarded
      case yearCommandSupport
      case yearConfirmedSignals
      case generations
      case numberOfDrivers
      case numberOfMilesDriven
    }

    public var yearCommandSupport: [Int: CommandSupport]
    public var yearConfirmedSignals: [Int: Set<String>]
    public var generations: [Generation]

    public init(
      obdbID: OBDbID,
      make: String,
      model: String,
      engineType: EngineType,
      modelSVGs: [String],
      numberOfDrivers: Int,
      numberOfMilesDriven: Int,
      onboarded: Bool
    ) {
      self.obdbID = obdbID
      self.make = make
      self.model = model
      self.engineType = engineType
      self.modelSVGs = modelSVGs
      self.yearCommandSupport = [:]
      self.yearConfirmedSignals = [:]
      self.generations = []
      self.numberOfDrivers = numberOfDrivers
      self.numberOfMilesDriven = numberOfMilesDriven
      self.onboarded = onboarded
    }

    public var allModelYears: [Int] {
      var years = Set(yearCommandSupport.keys).union(Set(yearConfirmedSignals.keys))

      // Add years from generations
      for generation in generations {
        if let yearRange = generation.yearRange {
          for year in yearRange {
            years.insert(year)
          }
        }
      }

      // Only return years since OBD was introduced.
      return years.filter { $0 >= 1988 }.sorted()
    }

    public var modelYearRange: ClosedRange<Int>? {
      let allModelYears = self.allModelYears
      guard let minYear = allModelYears.min(),
       let maxYear = allModelYears.max() else {
        return nil
      }
      return minYear...maxYear
    }

    public enum ConnectableSupportLevel: Int, Comparable {
      case unknown = 0
      case shouldBeSupported = 1
      case confirmed = 2

      public static func < (lhs: MergedSupportMatrix.ModelSupport.ConnectableSupportLevel, rhs: MergedSupportMatrix.ModelSupport.ConnectableSupportLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
      }
    }
    public func connectableSupportByModelYear(yearRangeSignalMap: YearRangeSignalMap, saeConnectables: [SignalID: Connectable]) -> [Int: [Connectable: ConnectableSupportLevel]] {
      var support: [Int: [Connectable: ConnectableSupportLevel]] = [:]

      for modelYear in allModelYears {
        support[modelYear] = [:]

        guard let connectedSignals = yearRangeSignalMap.connectedSignals(modelYear: modelYear) else {
          fatalError("No connected signals found for model year \(modelYear)")
          continue
        }

        let nonSAEConnectedSignals = connectedSignals.filter { saeConnectables[$0.key] == nil }
        for connectable in nonSAEConnectedSignals.values {
          guard connectable.isVisualizedInSupportMatrix else {
            continue
          }
          support[modelYear, default: [:]][connectable] = .shouldBeSupported
        }

        // Track any connectables that *should* be supported
        if let commandSupport = yearCommandSupport[modelYear] {
          let allSupportedSignals = Set(commandSupport.allSupportedSignals)
          let allSupportedConnectables = Set(allSupportedSignals.compactMap { connectedSignals[$0]})
          for connectable in allSupportedConnectables {
          guard connectable.isVisualizedInSupportMatrix else {
            continue
          }
            support[modelYear, default: [:]][connectable] = .shouldBeSupported
          }
        }

        // And then check for any connectables that are confirmed with real vehicle data
        if let confirmedSignals = yearConfirmedSignals[modelYear] {
          let confirmedConnectables = Set(confirmedSignals.compactMap { connectedSignals[$0]})
          for confirmedConnectable in confirmedConnectables {
            guard confirmedConnectable.isVisualizedInSupportMatrix else {
              continue
            }
            support[modelYear, default: [:]][confirmedConnectable] = .confirmed
          }
        }
      }

      // Propagate confirmed signals within generations
      // First, collect all confirmed and shouldBeSupported connectables by generation
      var confirmedByGeneration: [Generation: Set<Connectable>] = [:]
      var shouldBeSupportedByGeneration: [Generation: Set<Connectable>] = [:]

      for generation in generations {
        guard let yearRange = generation.yearRange else { continue }

        var generationConfirmed = Set<Connectable>()
        var generationShouldBeSupported = Set<Connectable>()

        for year in yearRange {
          if let yearSupport = support[year] {
            for (connectable, level) in yearSupport {
              if level == .confirmed {
                generationConfirmed.insert(connectable)
              } else if level == .shouldBeSupported {
                generationShouldBeSupported.insert(connectable)
              }
            }
          }
        }

        if !generationConfirmed.isEmpty {
          confirmedByGeneration[generation] = generationConfirmed
        }

        if !generationShouldBeSupported.isEmpty {
          shouldBeSupportedByGeneration[generation] = generationShouldBeSupported
        }
      }

      // Then apply those connectables to all years in each generation
      // First apply shouldBeSupported, then confirmed (to ensure confirmed takes priority)
      for (generation, shouldBeSupportedConnectables) in shouldBeSupportedByGeneration {
        guard let yearRange = generation.yearRange else { continue }

        for year in yearRange {
          for connectable in shouldBeSupportedConnectables {
            // Only set if not already set to .confirmed
            if support[year]?[connectable] != .confirmed {
              support[year, default: [:]][connectable] = .shouldBeSupported
            }
          }
        }
      }

      for (generation, confirmedConnectables) in confirmedByGeneration {
        guard let yearRange = generation.yearRange else { continue }

        for year in yearRange {
          for connectable in confirmedConnectables {
            support[year, default: [:]][connectable] = .confirmed
          }
        }
      }

      for year in support.keys {
        support[year] = support[year]?.filter {
          ($0.key.isBatteryRelated && self.engineType.hasBattery)
          || ($0.key.isFuelRelated && self.engineType.hasFuel)
          || (!$0.key.isBatteryRelated && !$0.key.isFuelRelated)
        }
      }

      return support
    }

    public func connectableSupportGroupByModelYearRange(yearRangeSignalMap: YearRangeSignalMap, saeConnectables: [SignalID: Connectable]) -> [ClosedRange<Int>: [Connectable: ConnectableSupportLevel]] {
      // Get support by individual model years first
      let supportByYear = connectableSupportByModelYear(yearRangeSignalMap: yearRangeSignalMap, saeConnectables: saeConnectables)

      // Return empty dictionary if there's no support data
      guard !supportByYear.isEmpty else {
        return [:]
      }

      // Get all years sorted
      let years = supportByYear.keys.sorted()

      var result: [ClosedRange<Int>: [Connectable: ConnectableSupportLevel]] = [:]
      var currentRange: (start: Int, end: Int)? = nil
      var currentSupport: [Connectable: ConnectableSupportLevel]? = nil

      for year in years {
        let yearSupport = supportByYear[year]!

        if currentRange == nil {
          // First year in sequence
          currentRange = (year, year)
          currentSupport = yearSupport
        } else if yearSupport == currentSupport {
          // Same support as previous year, extend the range
          currentRange!.end = year
        } else {
          // Different support, add the current range to result and start a new one
          result[currentRange!.start...currentRange!.end] = currentSupport!
          currentRange = (year, year)
          currentSupport = yearSupport
        }
      }

      // Add the last range
      if let range = currentRange, let support = currentSupport {
        result[range.start...range.end] = support
      }

      return result
    }
  }

  /// Type alias for OBDb vehicle ID (typically Make-Model format)
  public typealias OBDbID = String

  /// Type alias for the complete support matrix mapping OBDbID to ModelSupport
  public typealias OBDbVehicleSupportMatrix = [OBDbID: ModelSupport]

  /// Type alias for signal identifier (e.g., "TAYCAN_VSS")
  public typealias SignalID = String

  public enum Connectable: String, CaseIterable, Sendable {
    case electricRange
    case frontLeftTirePressure
    case frontRightTirePressure
    case fuelRange
    case fuelTankLevel
    case isCharging
    case odometer
    case pluggedIn
    case rearLeftTirePressure
    case rearRightTirePressure
    case speed
    case stateOfCharge
    case stateOfHealth
    case starterBatteryVoltage
    case distanceSinceDTCsCleared

    // Signal groups
    case batteryModulesStateOfCharge
    case batteryModulesVoltage

    public var isBatteryRelated: Bool {
      switch self {
      case .stateOfCharge,
      .stateOfHealth,
      .isCharging,
      .batteryModulesStateOfCharge,
      .batteryModulesVoltage,
      .electricRange,
      .pluggedIn:
        return true
      default:
        return false
      }
    }

    public var isFuelRelated: Bool {
      switch self {
      case .fuelTankLevel,
      .fuelRange:
        return true
      default:
        return false
      }
    }

    public var isVisualizedInSupportMatrix: Bool {
      switch self {
      case .distanceSinceDTCsCleared,
        .starterBatteryVoltage:
        return false
      default:
        return true
      }
    }
  }

  public typealias YearRange = ClosedRange<Int>

  /// Structure to manage signal mappings with year range support
  public struct YearRangeSignalMap {
    private var yearRangeSignals: [YearRange?: [SignalID: Connectable]] = [:]

    public init() {}

    public init(yearRangeSignals: [YearRange?: [SignalID: Connectable]]) {
      self.yearRangeSignals = yearRangeSignals
    }

    public subscript(yearRange: YearRange?) -> [SignalID: Connectable]? {
      get { yearRangeSignals[yearRange] }
      set { yearRangeSignals[yearRange] = newValue }
    }

    public subscript(yearRange: YearRange?, default defaultValue: [SignalID: Connectable]) -> [SignalID: Connectable] {
      get { yearRangeSignals[yearRange, default: defaultValue] }
      set { yearRangeSignals[yearRange] = newValue }
    }

    /// Returns the signal map for a given model year, falling back to default if no specific range matches
    /// - Parameter modelYear: The model year to find signals for
    /// - Returns: The signal map if found, nil otherwise
    public func connectedSignals(modelYear: Int) -> [SignalID: Connectable]? {
      // First check for specific year ranges that contain this model year
      for (yearRange, signals) in yearRangeSignals where yearRange != nil {
        if let range = yearRange, range.contains(modelYear) {
          return signals
        }
      }

      // Fall back to default signals (nil key) if no specific range matched
      return yearRangeSignals[nil]
    }

    /// Get all year ranges defined in this map
    public var allYearRanges: [YearRange?] {
      return Array(yearRangeSignals.keys)
    }
  }

  /// The merged support matrix containing all vehicle information
  public private(set) var supportMatrix: OBDbVehicleSupportMatrix = [:]

  /// Processed mapping of vehicle models to their signals and standard names, organized by year ranges
  public private(set) var saeConnectables: [SignalID: Connectable] = [:]

  private func standardizedOBDbID(_ obdbID: OBDbID) -> OBDbID {
    return obdbID
      .lowercased()
      .replacingOccurrences(of: " ", with: "_")
      .replacingOccurrences(of: "-", with: "_")
  }

  /// Processed mapping of vehicle models to their signals and standard names, organized by year ranges
  private var connectables: [OBDbID: YearRangeSignalMap] = [:]
  public func connectables(for obdbID: OBDbID) -> YearRangeSignalMap {
    if let existingMap = connectables[standardizedOBDbID(obdbID)] {
      return existingMap
    }
    if let engineType = self.getModel(id: obdbID)?.engineType {
      let filteredConnectables = saeConnectables.filter {
        ($0.value.isBatteryRelated && engineType.hasBattery) || ($0.value.isFuelRelated && engineType.hasFuel) || (!$0.value.isBatteryRelated && !$0.value.isFuelRelated)
      }
      return YearRangeSignalMap(yearRangeSignals: [nil: filteredConnectables])
    }
    // No map and no engine, let's just fall back to the default SAE configuration.
    return YearRangeSignalMap(yearRangeSignals: [nil: saeConnectables])
  }

  /// Raw data mapping from signal path to signal mappings, loaded directly from connectables.json
  private var rawConnectables: [String: [String: String]] = [:]

  /// Optional error that occurred during the last merge operation
  public private(set) var lastError: Error?

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
    modelsTableID: String,
    workspacePath: String,
    useCache: Bool = false
  ) async -> (matrix: MergedSupportMatrix, success: Bool) {
    let matrix: MergedSupportMatrix = MergedSupportMatrix.shared
    var success: Bool = false

    // Check for cached data if useCache is enabled
    if useCache {
      if let cachedMatrix = await tryLoadFromCache() {
        // We have a cached matrix - use it
        matrix.supportMatrix = cachedMatrix.supportMatrix
        success = true
        print("Loaded vehicle support matrix from cache")
      }
    }

    if matrix.supportMatrix.isEmpty {
      // No cache available or caching disabled, perform full load
      success = await matrix.loadAndMerge(
        using: airtableClient,
        modelsTableID: modelsTableID,
        workspacePath: workspacePath
      )
    }

    // Connectables require the vehicle matrix to be loaded first for engine type data.
    do {
      try matrix.loadConnectables()
      print("Loaded connectables data successfully")
    } catch {
      print("Failed to load connectables data: \(error.localizedDescription)")
      matrix.lastError = error
      success = false
    }

    // Save to cache if successful and caching is enabled
    if success {
      await saveToCacheAsync(matrix: matrix)
    }

    return (matrix, success)
  }

  private static func getCachePath() -> String {
    let fileManager = FileManager.default
    let path: String
    if let cachePath = ProcessInfo.processInfo.environment["CACHE_DIR"] {
      path = fileManager.currentDirectoryPath + "/" + cachePath
    } else {
      path = fileManager.currentDirectoryPath + "/.cache"
    }

    // Create cache directory if it doesn't exist
    if !fileManager.fileExists(atPath: path) {
      try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    return path
  }

  private static func getVehicleImagesPath() -> String {
    let fileManager = FileManager.default
    let path: String
    if let cachePath = ProcessInfo.processInfo.environment["VEHICLE_IMAGES_DIR"] {
      path = fileManager.currentDirectoryPath + "/" + cachePath
    } else {
      path = fileManager.currentDirectoryPath + "/site/gfx/vehicle/"
    }

    // Create cache directory if it doesn't exist
    if !fileManager.fileExists(atPath: path) {
      try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    return path
  }

  // Helper function to construct the cache file path
  private static func getCacheFilePath() -> URL {
    let cacheDirectory: String = getCachePath()
    return URL(fileURLWithPath: cacheDirectory).appendingPathComponent("mergedSupportMatrix.json")
  }

  // Try to load the matrix from cache
  private static func tryLoadFromCache() async -> MergedSupportMatrix? {
    let cacheFilePath = getCacheFilePath()

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
  private static func saveToCacheAsync(matrix: MergedSupportMatrix) async {
    let cacheFilePath = getCacheFilePath()

    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(matrix.supportMatrix)
      try data.write(to: cacheFilePath)
      print("Saved vehicle support matrix to cache")
    } catch {
      print("Cache write failed: \(error.localizedDescription)")
    }
  }

  /// Load connectables data from the .cache/connectables.json file
  /// - Throws: Error if the file doesn't exist or can't be parsed
  private func loadConnectables() throws {
    let connectablesFilePath = Self.getConnectablesFilePath()

    guard FileManager.default.fileExists(atPath: connectablesFilePath.path) else {
      throw NSError(
        domain: "MergedSupportMatrix",
        code: 404,
        userInfo: [NSLocalizedDescriptionKey: "Connectables file not found at \(connectablesFilePath.path)"]
      )
    }

    let data = try Data(contentsOf: connectablesFilePath)
    let decoder = JSONDecoder()
    self.rawConnectables = try decoder.decode([String: [String: String]].self, from: data)

    // Process the raw connectables into the structured format
    processConnectables()
  }

  /// Process raw connectables data into structured format with OBDbIDs and year ranges
  private func processConnectables() {
    // Reset the connectables dictionary
    connectables = [:]
    self.saeConnectables = [:]

    let saeConnectables = rawConnectables["SAEJ1979/signalsets/v3/default.json"] ?? [:]

    // Prime the years with the SAE connectables
    for (signalID, connectable) in saeConnectables {
      guard let connectable = Connectable(rawValue: connectable) else {
        fatalError("Unknown connectable: \(connectable)")
      }
      self.saeConnectables[signalID] = connectable
    }

    for (path, signalMappings) in rawConnectables {
      // Extract OBDbID and potential year range from the path
      // Format examples:
      // - "Audi-TT/signalsets/v3/default.json" -> OBDbID: "Audi-TT", YearRange: nil
      // - "Ford-F-150/signalsets/v3/2015-2018.json" -> OBDbID: "Ford-F-150", YearRange: 2015...2018

      let components = path.components(separatedBy: "/")
      guard components.count >= 4 else { continue }

      let obdbID = components[0]
      let filename = components.last ?? ""

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

      // Extract year range if present, otherwise use nil for default
      var yearRange: YearRange? = nil

      if filename != "default.json" {
        let yearComponent = filename.replacingOccurrences(of: ".json", with: "")
        let yearParts = yearComponent.components(separatedBy: "-")

        if yearParts.count == 2,
           let startYear = Int(yearParts[0]),
           let endYear = Int(yearParts[1]) {
          yearRange = startYear...endYear
        } else if yearParts.count == 1 && yearParts[0] == "0000" {
          // Special case for "0000-xxxx.json" format
          if let endYearStr = yearParts.last,
             let endYear = Int(endYearStr) {
            // Use a very early year as the start for "0000" ranges
            yearRange = 1900...endYear
          }
        }
      }

      // Prime the years with the SAE connectables
      for (signalID, connectable) in saeConnectables {
        guard let connectable = Connectable(rawValue: connectable) else {
          fatalError("Unknown connectable: \(connectable)")
        }
        guard (connectable.isBatteryRelated && engineType.hasBattery) || (connectable.isFuelRelated && engineType.hasFuel) || (!connectable.isBatteryRelated && !connectable.isFuelRelated) else {
          continue
        }
        connectables[standardizedOBDbID(obdbID), default: YearRangeSignalMap()][yearRange, default: [:]][signalID] = connectable
      }

      // Add all signal mappings for this combination
      for (signalID, connectable) in signalMappings {
        guard let connectable = Connectable(rawValue: connectable) else {
          fatalError("Unknown connectable: \(connectable)")
        }
        guard (connectable.isBatteryRelated && engineType.hasBattery) || (connectable.isFuelRelated && engineType.hasFuel) || (!connectable.isBatteryRelated && !connectable.isFuelRelated) else {
          continue
        }
        connectables[standardizedOBDbID(obdbID), default: YearRangeSignalMap()][yearRange, default: [:]][signalID] = connectable
      }
    }
  }

  /// Get the path to the connectables file
  /// - Returns: URL to the connectables.json file
  private static func getConnectablesFilePath() -> URL {
    let cacheDirectory: String = getCachePath()
    return URL(fileURLWithPath: cacheDirectory).appendingPathComponent("connectables.json")
  }

  /// Load and merge vehicle data from Airtable and local vehicle metadata
  /// - Parameters:
  ///   - airtableClient: The Airtable client to use for fetching models
  ///   - modelsTableID: The ID of the models table in Airtable
  ///   - workspacePath: Path to the local workspace containing vehicle metadata
  /// - Returns: A boolean indicating whether the operation was successful
  @discardableResult
  public func loadAndMerge(
    using airtableClient: AirtableClient, modelsTableID: String, workspacePath: String
  ) async -> Bool {
    do {
      // Reset any previous errors
      lastError = nil
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
          fatalError("Unknown engine type: \(engineType)")
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
          for asset in symbolSVGs {
            // Download and cache image assets
            Task {
              await downloadAndCacheAsset(url: URL(string: asset.url)!, filename: asset.filename)
            }
          }
        }
      }

      // 3. Load local vehicle metadata
      try SupportMatrix.shared.loadVehicleMetadata(from: workspacePath)

      // 4. Merge with local metadata if available
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

      return true
    } catch {
      lastError = error
      return false
    }
  }

  /// Download and cache an asset from a URL if it doesn't already exist in the cache
  /// - Parameters:
  ///   - url: The URL of the asset to download
  ///   - filename: The filename to use when saving the asset
  private func downloadAndCacheAsset(url: URL, filename: String) async {
    let fileManager = FileManager.default
    let cacheDirectory = Self.getVehicleImagesPath()
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

  /// Get vehicles supporting a specific OBD-II command
  /// - Parameter command: The OBD-II command code (e.g. "0104")
  /// - Returns: Dictionary mapping makes to models and their supported years
  public func getVehiclesSupporting(command: String) -> [String: [String: [Int]]] {
    var result = [String: [String: [Int]]]()

    for (obdbID, modelSupport) in supportMatrix {
      for (year, commandSupport) in modelSupport.yearCommandSupport {
        let isSupported = (commandSupport.supportedCommandsByEcu ?? [:]).values.contains { commands in
          commands.contains { $0.starts(with: command + ":") }
        }

        if isSupported {
          let make = modelSupport.make
          let model = modelSupport.model

          if result[make] == nil {
            result[make] = [:]
          }

          if result[make]?[model] == nil {
            result[make]?[model] = []
          }

          result[make]?[model]?.append(year)
        }
      }
    }

    // Sort years within each model
    for (make, models) in result {
      for (model, _) in models {
        result[make]?[model]?.sort()
      }
    }

    return result
  }

  /// Get vehicles that support a specific signal
  /// - Parameter signalName: The signal name to search for (e.g., "TAYCAN_VSS")
  /// - Returns: A dictionary of makes, models, and years that support the signal
  public func getVehiclesSupporting(signalName: String) -> [String: [String: [Int]]] {
    var result = [String: [String: [Int]]]()

    for (obdbID, modelSupport) in supportMatrix {
      for (year, signals) in modelSupport.yearConfirmedSignals {
        if signals.contains(signalName) {
          let make = modelSupport.make
          let model = modelSupport.model

          if result[make] == nil {
            result[make] = [:]
          }

          if result[make]?[model] == nil {
            result[make]?[model] = []
          }

          result[make]?[model]?.append(year)
        }
      }
    }

    // Sort years within each model
    for (make, models) in result {
      for (model, _) in models {
        result[make]?[model]?.sort()
      }
    }

    return result
  }

  /// Get statistics about the confirmed signals
  /// - Returns: A tuple containing count of confirmed signals, and count of vehicles with confirmed signals
  public func getConfirmedSignalsStatistics() -> (signals: Int, vehicles: Int) {
    var uniqueSignals = Set<String>()
    var vehiclesWithSignals = 0

    for (_, modelSupport) in supportMatrix {
      var hasSignals = false

      for (_, signals) in modelSupport.yearConfirmedSignals {
        uniqueSignals.formUnion(signals)
        if !signals.isEmpty {
          hasSignals = true
        }
      }

      if hasSignals {
        vehiclesWithSignals += 1
      }
    }

    return (signals: uniqueSignals.count, vehicles: vehiclesWithSignals)
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
