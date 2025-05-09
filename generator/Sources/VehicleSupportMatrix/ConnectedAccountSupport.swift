import Foundation

public let makeConnectedAccountSupport: [String: Set<Connectable>] = [
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
