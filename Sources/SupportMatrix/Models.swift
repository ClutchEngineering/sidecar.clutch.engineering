import Foundation

// Extension to get current year from Date
extension Date {
    var year: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return Int(formatter.string(from: self))!
    }
}

public typealias Year = Int
public typealias Make = String
public typealias Model = String

/// Represents a vehicle generation with name and year range
public struct Generation: Codable, Equatable, Hashable {
  public let name: String
  public let startYear: Int
  public let endYear: Int?
  public let description: String?

  public var yearRange: ClosedRange<Int>? {
    guard let endYear = endYear else {
      // For generations that are still ongoing, use current year
      return startYear...Int(Date().year)
    }
    return startYear...endYear
  }

  enum CodingKeys: String, CodingKey {
    case name
    case startYear = "start_year"
    case endYear = "end_year"
    case description
  }
}

/// Represents command support information parsed from YAML files
public struct CommandSupport: Codable {
  public var modelYear: Int
  public var canIdFormat: String
  public var extendedAddressingEnabled: Bool
  public var supportedCommandsByEcu: [String: [String]]?
  public var unsupportedCommandsByEcu: [String: [String]]?

  public var allSupportedSignals: [String] {
    var allSignals = Set<String>()
    for ecuCommands in (supportedCommandsByEcu ?? [:]).values {
      for commandAndSignals in ecuCommands {
        // Split the command and signals
        let components = commandAndSignals.components(separatedBy: ":")
        guard components.count > 1 else {
          continue
        }
        // The signals are after the first colon
        let signals = components[1]
        // Split the signals by comma
        let signalComponents = signals.components(separatedBy: ",")
        for signal in signalComponents {
          allSignals.insert(String(signal))
        }
      }
    }
    return Array(allSignals)
  }

  enum CodingKeys: String, CodingKey {
    case modelYear = "model_year"
    case canIdFormat = "can_id_format"
    case extendedAddressingEnabled = "extended_addressing_enabled"
    case supportedCommandsByEcu = "supported_commands_by_ecu"
    case unsupportedCommandsByEcu = "unsupported_commands_by_ecu"
  }
}

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
  public var generations: [Make: [Model: [Generation]]]

  public init() {
    self.vehicles = [:]
    self.confirmedSignals = [:]
    self.generations = [:]
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

  public mutating func addGenerations(
    make: Make, model: Model, generations: [Generation]
  ) {
    if self.generations[make] == nil {
      self.generations[make] = [:]
    }

    if self.generations[make]?[model] == nil {
      self.generations[make]?[model] = []
    }

    self.generations[make]?[model] = generations
  }
}
