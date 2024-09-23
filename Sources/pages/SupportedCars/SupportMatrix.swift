import Foundation

typealias Make = String
typealias Model = String
let makes: [Make: [Model: [VehicleSupportStatus]]] = [
  "Nissan": [
    "Juke": [
      .testerNeeded(years: 1996...2011),
      .init(years: 2012...2012, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2013...2025)
    ]
  ],
  "Porsche": [
    " 911":     [ .testerNeeded(years: 1996...2025) ],
    "Cayenne":  [ .testerNeeded(years: 2002...2025) ],
    "Macan":    [ .testerNeeded(years: 2014...2025) ],
    "Taycan": [
      .init(years: 2019...2024, testingStatus: .onboarded, stateOfCharge: .all, stateOfHealth: .obd, charging: .ota, cells: .obd, fuelLevel: .na, speed: .obd, range: .all, odometer: .all, tirePressure: .all),
      .testerNeeded(years: 2025...2025)
    ]
  ]
]
