import Foundation

public typealias Year = Int
public typealias Make = String
public typealias Model = String

/// Represents command support information parsed from YAML files
public struct CommandSupport: Codable {
  public var modelYear: Int
  public var canIdFormat: String
  public var extendedAddressingEnabled: Bool
  public var supportedCommandsByEcu: [String: [CommandWithParameters]]

  enum CodingKeys: String, CodingKey {
    case modelYear = "model_year"
    case canIdFormat = "can_id_format"
    case extendedAddressingEnabled = "extended_addressing_enabled"
    case supportedCommandsByEcu = "supported_commands_by_ecu"
  }
}

/// Represents a command with its associated parameters
public typealias CommandWithParameters = String

/// A vehicle represents a particular make and model
public struct Vehicle {
  public let make: Make
  public let model: Model
  public var years: [Year: CommandSupport]

  public init(make: Make, model: Model, years: [Year: CommandSupport] = [:]) {
    self.make = make
    self.model = model
    self.years = years
  }
}

/// Container for all vehicle metadata
public struct VehicleMetadata {
  public var vehicles: [Make: [Model: [Year: CommandSupport]]]
  public var confirmedSignals: [Make: [Model: [Year: Set<String>]]]

  public init() {
    self.vehicles = [:]
    self.confirmedSignals = [:]
  }

  public mutating func addVehicle(
    make: Make, model: Model, year: Year, commandSupport: CommandSupport
  ) {
    if vehicles[make] == nil {
      vehicles[make] = [:]
    }

    if vehicles[make]?[model] == nil {
      vehicles[make]?[model] = [:]
    }

    vehicles[make]?[model]?[year] = commandSupport
  }

  public mutating func addConfirmedSignal(
    make: Make, model: Model, year: Year, signal: String
  ) {
    if confirmedSignals[make] == nil {
      confirmedSignals[make] = [:]
    }

    if confirmedSignals[make]?[model] == nil {
      confirmedSignals[make]?[model] = [:]
    }

    if confirmedSignals[make]?[model]?[year] == nil {
      confirmedSignals[make]?[model]?[year] = Set<String>()
    }

    confirmedSignals[make]?[model]?[year]?.insert(signal)
  }
}
