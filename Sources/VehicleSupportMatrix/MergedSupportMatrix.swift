import AirtableAPI
import Foundation
import SupportMatrix

/// Provides a unified API to retrieve vehicle support information by merging Airtable data with local vehicle metadata
public class MergedSupportMatrix: @unchecked Sendable {
  /// Shared singleton instance
  public static let shared = MergedSupportMatrix()

  /// Structure to hold combined model data with command support information
  public struct ModelSupport: Codable {
    public let make: String
    public let model: String
    public var yearCommandSupport: [Int: CommandSupport]
    public var yearConfirmedSignals: [Int: Set<String>]

    public init(
      make: String, model: String, yearCommandSupport: [Int: CommandSupport] = [:],
      yearConfirmedSignals: [Int: Set<String>] = [:]
    ) {
      self.make = make
      self.model = model
      self.yearCommandSupport = yearCommandSupport
      self.yearConfirmedSignals = yearConfirmedSignals
    }

    public var allModelYears: [Int] {
      return Set(yearCommandSupport.keys).union(Set(yearConfirmedSignals.keys)).sorted()
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
        guard let connectedSignals = yearRangeSignalMap.connectedSignals(modelYear: modelYear) else {
          fatalError("No connected signals found for model year 2\(modelYear)")
          continue
        }

        let nonSAEConnectedSignals = connectedSignals.filter { saeConnectables[$0.key] == nil }
        for connectable in nonSAEConnectedSignals.values {
          support[modelYear, default: [:]][connectable] = .shouldBeSupported
        }

        // Track any connectables that *should* be supported
        if let commandSupport = yearCommandSupport[modelYear] {
          let allSupportedSignals = Set(commandSupport.allSupportedSignals)
          let allSupportedConnectables = Set(allSupportedSignals.compactMap { connectedSignals[$0]})
          for connectable in allSupportedConnectables {
            support[modelYear, default: [:]][connectable] = .shouldBeSupported
          }
        }

        // And then check for any connectables that are confirmed with real vehicle data
        if let confirmedSignals = yearConfirmedSignals[modelYear] {
          let confirmedConnectables = Set(confirmedSignals.compactMap { connectedSignals[$0]})
          for confirmedConnectable in confirmedConnectables {
            support[modelYear, default: [:]][confirmedConnectable] = .confirmed
          }
        }
      }
      return support
    }

    // Add custom coding keys for potential future compatibility
    enum CodingKeys: String, CodingKey {
      case make, model, yearCommandSupport, yearConfirmedSignals
    }
  }

  /// Type alias for OBDb vehicle ID (typically Make-Model format)
  public typealias OBDbID = String

  /// Type alias for the complete support matrix mapping OBDbID to ModelSupport
  public typealias OBDbVehicleSupportMatrix = [OBDbID: ModelSupport]

  /// Type alias for signal identifier (e.g., "TAYCAN_VSS")
  public typealias SignalID = String

  public enum Connectable: String, CaseIterable {
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

  /// Processed mapping of vehicle models to their signals and standard names, organized by year ranges
  public private(set) var connectables: [OBDbID: YearRangeSignalMap] = [:]

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
    let matrix = MergedSupportMatrix.shared

    // First, try to load the connectables data - this is required
    do {
      try matrix.loadConnectables()
      print("Loaded connectables data successfully")
    } catch {
      print("Failed to load connectables data: \(error.localizedDescription)")
      matrix.lastError = error
      return (matrix, false)
    }

    // Check for cached data if useCache is enabled
    if useCache {
      if let cachedMatrix = await tryLoadFromCache() {
        // We have a cached matrix - use it
        matrix.supportMatrix = cachedMatrix.supportMatrix
        print("Loaded vehicle support matrix from cache")
        return (matrix, true)
      }
    }

    // No cache available or caching disabled, perform full load
    let success = await matrix.loadAndMerge(
      using: airtableClient,
      modelsTableID: modelsTableID,
      workspacePath: workspacePath
    )

    // Save to cache if successful and caching is enabled
    if success && useCache {
      await saveToCacheAsync(matrix: matrix)
    }

    return (matrix, success)
  }

  // Helper function to construct the cache file path
  private static func getCacheFilePath() -> URL {
    let fileManager = FileManager.default
    let cacheDirectory = fileManager.currentDirectoryPath + "/.cache"

    // Create cache directory if it doesn't exist
    if !fileManager.fileExists(atPath: cacheDirectory) {
      try? fileManager.createDirectory(atPath: cacheDirectory, withIntermediateDirectories: true)
    }

    return URL(fileURLWithPath: cacheDirectory).appendingPathComponent("mergedSupportMatrix.cache")
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
        connectables[obdbID, default: YearRangeSignalMap()][yearRange, default: [:]][signalID] = connectable
      }

      // Add all signal mappings for this combination
      for (signalID, connectable) in signalMappings {
        guard let connectable = Connectable(rawValue: connectable) else {
          fatalError("Unknown connectable: \(connectable)")
        }
        connectables[obdbID, default: YearRangeSignalMap()][yearRange, default: [:]][signalID] = connectable
      }
    }
  }

  /// Get the path to the connectables file
  /// - Returns: URL to the connectables.json file
  private static func getConnectablesFilePath() -> URL {
    let fileManager = FileManager.default
    let cacheDirectory = fileManager.currentDirectoryPath + "/.cache"
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
      let sortedRecords = try await airtableClient.fetchModels(from: modelsTableID)

      // 2. Create initial support matrix with Airtable data
      for record in sortedRecords {
        guard let make = record.fields.make,
          let model = record.fields.model,
          let obdbID = record.fields.obdbID
        else {
          continue
        }

        supportMatrix[obdbID] = ModelSupport(make: make, model: model)
      }

      // 3. Load local vehicle metadata
      try SupportMatrix.shared.loadVehicleMetadata(from: workspacePath)

      // 4. Merge with local metadata if available
      if let vehicleMetadata = SupportMatrix.shared.vehicleMetadata {
        for (make, models) in vehicleMetadata.vehicles {
          for (model, years) in models {
            let obdbID = make + "-" + model
            supportMatrix[obdbID]?.yearCommandSupport = years
          }
        }

        // Add confirmed signals from metadata
        for (make, models) in vehicleMetadata.confirmedSignals {
          for (model, years) in models {
            let obdbID = make + "-" + model
            supportMatrix[obdbID]?.yearConfirmedSignals = years
          }
        }
      }

      return true
    } catch {
      lastError = error
      return false
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
    return supportMatrix[id]
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

  /// Get years available for a specific make and model
  /// - Parameters:
  ///   - make: The vehicle make
  ///   - model: The vehicle model
  /// - Returns: Array of years for which command support data is available
  public func getYears(for make: String, model: String) -> [Int] {
    let obdbID = make + "-" + model
    return supportMatrix[obdbID]?.yearCommandSupport.keys.sorted() ?? []
  }

  /// Get command support for a specific make, model, and year
  /// - Parameters:
  ///   - make: The vehicle make
  ///   - model: The vehicle model
  ///   - year: The model year
  /// - Returns: The command support information if available
  public func getCommandSupport(for make: String, model: String, year: Int) -> CommandSupport? {
    let obdbID = make + "-" + model
    return supportMatrix[obdbID]?.yearCommandSupport[year]
  }

  /// Get vehicles supporting a specific OBD-II command
  /// - Parameter command: The OBD-II command code (e.g. "0104")
  /// - Returns: Dictionary mapping makes to models and their supported years
  public func getVehiclesSupporting(command: String) -> [String: [String: [Int]]] {
    var result = [String: [String: [Int]]]()

    for (obdbID, modelSupport) in supportMatrix {
      for (year, commandSupport) in modelSupport.yearCommandSupport {
        let isSupported = commandSupport.supportedCommandsByEcu.values.contains { commands in
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

  /// Get confirmed signals for a specific make, model, and year
  /// - Parameters:
  ///   - make: The vehicle make
  ///   - model: The vehicle model
  ///   - year: The vehicle year
  /// - Returns: A set of confirmed signal names, or an empty set if none are found
  public func getConfirmedSignals(for make: String, model: String, year: Int) -> Set<String> {
    let obdbID = make + "-" + model
    return supportMatrix[obdbID]?.yearConfirmedSignals[year] ?? []
  }

  /// Get all confirmed signals for a specific make and model across all years
  /// - Parameters:
  ///   - make: The vehicle make
  ///   - model: The vehicle model
  /// - Returns: A dictionary mapping years to sets of confirmed signals
  public func getAllConfirmedSignals(for make: String, model: String) -> [Int: Set<String>] {
    let obdbID = make + "-" + model
    return supportMatrix[obdbID]?.yearConfirmedSignals ?? [:]
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
