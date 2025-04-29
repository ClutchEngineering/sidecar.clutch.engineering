import Foundation

/// SupportMatrix provides access to vehicle metadata parsed from the workspace directory
@MainActor
public final class SupportMatrix {
  /// The shared instance for accessing vehicle metadata
  public static let shared = SupportMatrix()

  /// The parsed vehicle metadata
  public private(set) var vehicleMetadata: VehicleMetadata?

  private init() {}

  /// Load vehicle metadata from the specified workspace path
  /// - Parameter workspacePath: The path to the workspace directory containing vehicle folders
  /// - Throws: An error if loading fails
  public func loadVehicleMetadata(from workspacePath: String) throws {
    let parser = VehicleMetadataParser(workspacePath: workspacePath)
    self.vehicleMetadata = try parser.parseAllVehicles()
  }

  /// Get all makes
  /// - Returns: An array of all vehicle makes
  public func getAllMakes() -> [Make] {
    return vehicleMetadata?.vehicles.keys.sorted() ?? []
  }

  /// Get models for a specific make
  /// - Parameter make: The vehicle make
  /// - Returns: An array of models for the specified make
  public func getModels(for make: Make) -> [Model] {
    return vehicleMetadata?.vehicles[make]?.keys.sorted() ?? []
  }

  /// Get years for a specific make and model
  /// - Parameters:
  ///   - make: The vehicle make
  ///   - model: The vehicle model
  /// - Returns: An array of years for the specified make and model
  public func getYears(for make: Make, model: Model) -> [Year] {
    return vehicleMetadata?.vehicles[make]?[model]?.keys.sorted() ?? []
  }

  /// Get command support data for a specific make, model, and year
  /// - Parameters:
  ///   - make: The vehicle make
  ///   - model: The vehicle model
  ///   - year: The vehicle year
  /// - Returns: The command support data, if available
  public func getCommandSupport(for make: Make, model: Model, year: Year) -> CommandSupport? {
    return vehicleMetadata?.vehicles[make]?[model]?[year]
  }

  /// Get all vehicles that support a specific command
  /// - Parameter command: The command to search for (e.g., "0104")
  /// - Returns: A dictionary of vehicles that support the command
  public func getVehiclesSupporting(command: String) -> [Make: [Model: [Year]]] {
    var result = [Make: [Model: [Year]]]()

    guard let metadata = vehicleMetadata else {
      return result
    }

    for (make, models) in metadata.vehicles {
      for (model, years) in models {
        for (year, support) in years {
          for (_, commands) in support.supportedCommandsByEcu {
            for cmdWithParams in commands {
              if cmdWithParams.starts(with: command + ":") {
                if result[make] == nil {
                  result[make] = [:]
                }
                if result[make]?[model] == nil {
                  result[make]?[model] = []
                }
                result[make]?[model]?.append(year)
                break
              }
            }
          }
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
  public func getConfirmedSignals(for make: Make, model: Model, year: Year) -> Set<String> {
    return vehicleMetadata?.confirmedSignals[make]?[model]?[year] ?? []
  }

  /// Get all confirmed signals for a specific make and model across all years
  /// - Parameters:
  ///   - make: The vehicle make
  ///   - model: The vehicle model
  /// - Returns: A dictionary mapping years to sets of confirmed signals
  public func getAllConfirmedSignals(for make: Make, model: Model) -> [Year: Set<String>] {
    return vehicleMetadata?.confirmedSignals[make]?[model] ?? [:]
  }

  /// Get vehicles that support a specific signal
  /// - Parameter signalName: The signal name to search for (e.g., "TAYCAN_VSS")
  /// - Returns: A dictionary of makes, models, and years that support the signal
  public func getVehiclesSupporting(signalName: String) -> [Make: [Model: [Year]]] {
    var result = [Make: [Model: [Year]]]()

    guard let metadata = vehicleMetadata else {
      return result
    }

    for (make, models) in metadata.confirmedSignals {
      for (model, years) in models {
        for (year, signals) in years {
          if signals.contains(signalName) {
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
    }

    // Sort years within each model
    for (make, models) in result {
      for (model, _) in models {
        result[make]?[model]?.sort()
      }
    }

    return result
  }
}
