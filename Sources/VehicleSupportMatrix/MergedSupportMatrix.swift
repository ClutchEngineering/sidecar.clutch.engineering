import AirtableAPI
import Foundation
import SupportMatrix

/// Provides a unified API to retrieve vehicle support information by merging Airtable data with local vehicle metadata
@MainActor
public class MergedSupportMatrix {
  /// Shared singleton instance
  public static let shared = MergedSupportMatrix()

  /// Structure to hold combined model data with command support information
  public struct ModelSupport {
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
  }

  /// Type alias for OBDb vehicle ID (typically Make-Model format)
  public typealias OBDbID = String

  /// Type alias for the complete support matrix mapping OBDbID to ModelSupport
  public typealias OBDbVehicleSupportMatrix = [OBDbID: ModelSupport]

  /// The merged support matrix containing all vehicle information
  public private(set) var supportMatrix: OBDbVehicleSupportMatrix = [:]

  /// Optional error that occurred during the last merge operation
  public private(set) var lastError: Error?

  private init() {}

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
