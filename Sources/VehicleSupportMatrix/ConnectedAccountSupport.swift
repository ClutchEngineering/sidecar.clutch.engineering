import Foundation

public let makeConnectedAccountSupport: [String: Set<MergedSupportMatrix.Connectable>] = [
  "Porsche": [
    .isCharging,
    .pluggedIn,
    .odometer,
    .electricRange,
    .fuelRange,
    .fuelTankLevel,
    .stateOfCharge,
    .frontLeftTirePressure,
    .frontRightTirePressure,
    .rearLeftTirePressure,
    .rearRightTirePressure,
  ]
]
