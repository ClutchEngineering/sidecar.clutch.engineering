import Foundation

typealias Make = String

struct Model: Codable, Hashable, ExpressibleByStringLiteral {
  let model: String
  let symbolName: String?

  init(stringLiteral value: StringLiteralType) {
    self.model = value.trimmingCharacters(in: .whitespacesAndNewlines)
    if !value.hasPrefix(" ") {
      symbolName = value.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    } else {
      symbolName = nil
    }
  }
}

struct VehicleSupportStatus: Codable {
  let years: ClosedRange<Int>

  enum TestingStatus: Codable {
    case onboarded
    case partiallyOnboarded
    case testerNeeded
    case activeTester(String)

    enum CodingKeys: CodingKey {
      case activeTester
    }

    func encode(to encoder: any Encoder) throws {
      switch self {
      case .onboarded:
        var container = encoder.singleValueContainer()
        try container.encode("onboarded")
      case .partiallyOnboarded:
        var container = encoder.singleValueContainer()
        try container.encode("partiallyOnboarded")
      case .testerNeeded:
        var container = encoder.singleValueContainer()
        try container.encode("testerNeeded")
      case .activeTester(let a0):
        var container = encoder.container(keyedBy: VehicleSupportStatus.TestingStatus.CodingKeys.self)
        try container.encode(a0, forKey: .activeTester)
      }
    }

    init(from decoder: any Decoder) throws {
      // First try to decode as a single string value
      if let container = try? decoder.singleValueContainer(),
         let value = try? container.decode(String.self) {
        switch value {
        case "onboarded":
          self = .onboarded
        case "partiallyOnboarded":
          self = .partiallyOnboarded
        case "testerNeeded":
          self = .testerNeeded
        default:
          throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unknown testing status: \(value)"
          )
        }
        return
      }

      // If not a single value, try to decode as keyed container for activeTester
      let container = try decoder.container(keyedBy: VehicleSupportStatus.TestingStatus.CodingKeys.self)
      if let username = try? container.decode(String.self, forKey: .activeTester) {
        self = .activeTester(username)
        return
      }

      throw DecodingError.dataCorruptedError(
        in: try decoder.singleValueContainer(),
        debugDescription: "Unable to decode testing status"
      )
    }
  }
  let testingStatus: TestingStatus

  enum SupportState: String, Codable {
    case all
    case obd
    case ota
    case na
  }
  let stateOfCharge: SupportState?
  let stateOfHealth: SupportState?
  let charging: SupportState?
  let cells: SupportState?
  let fuelLevel: SupportState?
  let speed: SupportState?
  let range: SupportState?
  let odometer: SupportState?
  let tirePressure: SupportState?

  init(years: ClosedRange<Int>, testingStatus: TestingStatus, stateOfCharge: SupportState?, stateOfHealth: SupportState?, charging: SupportState?, cells: SupportState?, fuelLevel: SupportState?, speed: SupportState?, range: SupportState?, odometer: SupportState?, tirePressure: SupportState?) {
    self.years = years
    self.testingStatus = testingStatus
    self.stateOfCharge = stateOfCharge
    self.stateOfHealth = stateOfHealth
    self.charging = charging
    self.cells = cells
    self.fuelLevel = fuelLevel
    self.speed = speed
    self.range = range
    self.odometer = odometer
    self.tirePressure = tirePressure
  }

  init(years: Int, testingStatus: TestingStatus, stateOfCharge: SupportState? = .na, stateOfHealth: SupportState? = .na, charging: SupportState? = .na, cells: SupportState? = .na, fuelLevel: SupportState? = .na, speed: SupportState? = nil, range: SupportState? = nil, odometer: SupportState? = nil, tirePressure: SupportState? = nil) {
    self.init(years: years...years, testingStatus: testingStatus, stateOfCharge: stateOfCharge, stateOfHealth: stateOfHealth, charging: charging, cells: cells, fuelLevel: fuelLevel, speed: speed, range: range, odometer: odometer, tirePressure: tirePressure)
  }

  static func testerNeeded(years: ClosedRange<Int>) -> Self {
    .init(years: years, testingStatus: .testerNeeded, stateOfCharge: nil, stateOfHealth: nil, charging: nil, cells: nil, fuelLevel: nil, speed: nil, range: nil, odometer: nil, tirePressure: nil)
  }

  static func testerNeeded(years: Int) -> Self {
    .testerNeeded(years: years...years)
  }

  static func newTester(years: ClosedRange<Int>, username: String) -> Self {
    .init(years: years, testingStatus: .activeTester(username), stateOfCharge: nil, stateOfHealth: nil, charging: nil, cells: nil, fuelLevel: nil, speed: nil, range: nil, odometer: nil, tirePressure: nil)
  }

  static func newTester(years: Int, username: String) -> Self {
    .newTester(years: years...years, username: username)
  }
}
