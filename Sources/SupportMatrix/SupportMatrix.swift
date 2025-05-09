import Foundation

/// SupportMatrix provides access to vehicle metadata parsed from the workspace directory
public final class SupportMatrix: @unchecked Sendable {
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
}
