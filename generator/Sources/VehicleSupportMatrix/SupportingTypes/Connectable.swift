import Foundation

public enum Connectable: String, CaseIterable, Decodable, Sendable {
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
  case cvtDeterioration
  case engineOilTemperature
  case engineCoolantTemperature
  case transmissionFluidTemperature
  case fuelRate
  case massAirFlow
  case commandedLambda
  case o2Lambda
  case shortTermFuelTrim
  case engineLoad
  case throttlePosition
  case tractionBatteryCurrent
  case tractionBatteryVoltage
  case tractionBatteryCapacity
  case tractionBatteryEfficiency
  case frontLeftTireTemperature
  case frontRightTireTemperature
  case rearLeftTireTemperature
  case rearRightTireTemperature

  // Signal groups
  case batteryModulesStateOfCharge
  case batteryModulesVoltage

  public var isBatteryRelated: Bool {
    switch self {
    case .stateOfCharge,
        .stateOfHealth,
        .isCharging,
        .batteryModulesStateOfCharge,
        .batteryModulesVoltage,
        .electricRange,
        .pluggedIn,
        .tractionBatteryCurrent,
        .tractionBatteryVoltage,
        .tractionBatteryCapacity,
        .tractionBatteryEfficiency:
      return true
    default:
      return false
    }
  }

  public var isFuelRelated: Bool {
    switch self {
    case .fuelTankLevel,
        .fuelRange,
        .fuelRate,
        .massAirFlow,
        .commandedLambda,
        .o2Lambda,
        .shortTermFuelTrim:
      return true
    default:
      return false
    }
  }

  public var isVisualizedInSupportMatrix: Bool {
    switch self {
    case .distanceSinceDTCsCleared,
        .starterBatteryVoltage,
        .cvtDeterioration,
        .engineOilTemperature,
        .engineCoolantTemperature,
        .transmissionFluidTemperature,
        .fuelRate,
        .massAirFlow,
        .commandedLambda,
        .o2Lambda,
        .shortTermFuelTrim,
        .engineLoad,
        .throttlePosition,
        .frontLeftTireTemperature,
        .frontRightTireTemperature,
        .rearLeftTireTemperature,
        .rearRightTireTemperature:
      return false
    default:
      return true
    }
  }
}
