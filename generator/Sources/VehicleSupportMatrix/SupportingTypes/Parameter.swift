import Foundation

/// Represents a vehicle parameter/signal from OBDb
public struct Parameter: Codable, Hashable, Sendable {
  /// Unique identifier for the signal (e.g., "TLX_GENERATOR")
  public let id: String

  /// Category/subsystem path (e.g., "Engine", "Battery", "Drivetrain")
  public let path: String

  /// Human-readable name (e.g., "Generator", "State of Charge")
  public let name: String

  /// Optional description of the parameter
  public let description: String?

  /// Unit of measurement (e.g., "percent", "celsius", "kilopascal")
  public let unit: String?

  /// Optional mapping to a standard Connectable
  public let connectable: Connectable?

  public init(
    id: String,
    path: String,
    name: String,
    description: String? = nil,
    unit: String? = nil,
    connectable: Connectable? = nil
  ) {
    self.id = id
    self.path = path
    self.name = name
    self.description = description
    self.unit = unit
    self.connectable = connectable
  }
}

/// Support level for a parameter
public enum ParameterSupportLevel: Int, Comparable, Codable, Sendable {
  case unsupported = 0
  case unknown = 1
  case shouldBeSupported = 2
  case confirmed = 3

  public static func < (lhs: ParameterSupportLevel, rhs: ParameterSupportLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}
