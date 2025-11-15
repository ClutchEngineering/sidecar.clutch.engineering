import Foundation

/// Raw parameter definition as loaded from parameters.json
public struct RawParameterDefinition: Codable, Sendable {
  /// Category/subsystem path (e.g., "Engine", "Battery", "Drivetrain")
  public let path: String

  /// Human-readable name (e.g., "Generator", "State of Charge")
  public let name: String

  /// Optional description of the parameter
  public let description: String?

  /// Unit of measurement (e.g., "percent", "celsius", "kilopascal")
  public let unit: String?

  /// Optional mapping to a standard Connectable (suggestedMetric in OBDb)
  public let suggestedMetric: String?

  enum CodingKeys: String, CodingKey {
    case path
    case name
    case description
    case unit
    case suggestedMetric
  }

  public init(
    path: String,
    name: String,
    description: String? = nil,
    unit: String? = nil,
    suggestedMetric: String? = nil
  ) {
    self.path = path
    self.name = name
    self.description = description
    self.unit = unit
    self.suggestedMetric = suggestedMetric
  }

  /// Convert to a Parameter struct with signal ID and optional Connectable mapping
  public func toParameter(id: String) -> Parameter {
    let connectable = suggestedMetric.flatMap { Connectable(rawValue: $0) }
    return Parameter(
      id: id,
      path: path,
      name: name,
      description: description,
      unit: unit,
      connectable: connectable
    )
  }
}
