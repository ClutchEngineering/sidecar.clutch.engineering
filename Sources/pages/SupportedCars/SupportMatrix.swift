import Foundation

typealias Make = String
typealias Model = String
let makes: [Make: [Model: [VehicleSupportStatus]]] = [
  "Chevrolet": [
    " Bolt EUV": [
      .testerNeeded(years: 2017...2022),
      .init(years: 2023...2023, testingStatus: .activeTester("pianoman96", id: 62), stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ]
  ],
  "Ford": [
    "Mustang": [
      .testerNeeded(years: 1996...2022),
      .init(years: 2023...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ]
  ],
  "Hyundai": [
    "IONIQ 5": [
      .testerNeeded(years: 2021...2022),
      .init(years: 2023...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ]
  ],
  "MG": [
    "MG4": [
      .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .all, stateOfHealth: .obd, charging: .ota, cells: .obd, fuelLevel: .na, speed: .obd, range: .all, odometer: .all, tirePressure: .ota),
      .testerNeeded(years: 2023...2025)
    ]
  ],
  "Nissan": [
    "Juke": [
      .testerNeeded(years: 1996...2011),
      .init(years: 2012...2012, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2013...2025)
    ],
    "Leaf": [
      .testerNeeded(years: 2010...2017),
      .init(years: 2018...2018, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .obd, charging: .obd, cells: .unk, fuelLevel: .na, speed: .obd, range: .obd, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2019...2025)
    ]
  ],
  "Polestar": [
    " 2":     [
      .testerNeeded(years: 2019...2021),
      .init(years: 2021...2021, testingStatus: .activeTester("jpalensk", id: 63), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2022...2025),
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
  "Rivian": [
    " R1S": [
      .testerNeeded(years: 2022...2024),
      .init(years: 2025...2025, testingStatus: .activeTester("Alex", id: 61), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
    ]
  ],
  "Tesla": [
    " Model S": [
      .testerNeeded(years: 2012...2025),
    ],
    "Model 3": [
      .init(years: 2017...2025, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
    ],
    " Model X": [
      .testerNeeded(years: 2016...2025),
    ],
    "Model Y": [
      .init(years: 2020...2025, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
    ],
    " Semi": [
      .testerNeeded(years: 2022...2025),
    ],
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
