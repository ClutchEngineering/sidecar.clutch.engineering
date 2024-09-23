import Foundation

typealias Make = String
typealias Model = String
let makes: [Make: [Model: [VehicleSupportStatus]]] = [
  "Ford": [
    "Mustang": [
      .testerNeeded(years: 1996...2022),
      .init(years: 2023...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ]
  ],
  "Nissan": [
    "Juke": [
      .testerNeeded(years: 1996...2011),
      .init(years: 2012...2012, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
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
  ],
  "Toyota": [
    "4Runner": [
      .testerNeeded(years: 1996...2019),
      .init(years: 2020...2020, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .ota, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .testerNeeded(years: 2021...2025)
    ]
  ],
  "Volkswagen": [
    "e-Golf": [
      .testerNeeded(years: 2015...2018),
      .init(years: 2019...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2020...2025)
    ]
  ],
]
