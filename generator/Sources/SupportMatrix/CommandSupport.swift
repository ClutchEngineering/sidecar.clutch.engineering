import Foundation

/// Represents command support information parsed from YAML files
public struct CommandSupport: Codable, Sendable {
  public var modelYear: Int
  public var canIdFormat: String
  public var extendedAddressingEnabled: Bool
  public var supportedCommandsByEcu: [String: [String]]?
  public var unsupportedCommandsByEcu: [String: [String]]?

  init(
    modelYear: Int,
    canIdFormat: String = "",
    extendedAddressingEnabled: Bool = false,
    supportedCommandsByEcu: [String: [String]]? = nil,
    unsupportedCommandsByEcu: [String: [String]]? = nil
  ) {
    self.modelYear = modelYear
    self.canIdFormat = canIdFormat
    self.extendedAddressingEnabled = extendedAddressingEnabled
    self.supportedCommandsByEcu = supportedCommandsByEcu
    self.unsupportedCommandsByEcu = unsupportedCommandsByEcu
  }

  /// Not encoded in YAML, but used to store confirmed signals.
  public var confirmedSignals: Set<String>?
  public var confirmedCommandIDs: Set<String>?

  /// All command IDs that, to the best of our knowledge, are not supported by the vehicle.
  public var allUnsupportedCommandIDs: Set<String> {
    var allUnsupportedCommandIDs = unsupportedCommandsByEcu?.values.reduce(into: Set<String>()) { $0.formUnion($1) } ?? []
    allUnsupportedCommandIDs.subtract(confirmedCommandIDs ?? [])
    return allUnsupportedCommandIDs
  }

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
