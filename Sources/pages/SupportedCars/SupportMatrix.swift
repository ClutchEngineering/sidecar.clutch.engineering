import Foundation

typealias Make = String
typealias Model = String
let makes: [Make: [Model: [VehicleSupportStatus]]] = [
  "Acura": [
    " TLX": [
      .newTester(years: 2015...2015, username: "sidbmw", id: 100),
      .testerNeeded(years: 2016...2025)
    ],
  ],
  "BMW": [
    " X3 M40i": [
      .testerNeeded(years: 2018...2020),
      .newTester(years: 2021...2021, username: "sidbmw", id: 100),
      .testerNeeded(years: 2022...2025)
    ],
  ],
  "Chevrolet": [
    " Bolt EV": [
      .testerNeeded(years: 2017...2021),
      .init(years: 2022...2022, testingStatus: .activeTester("wrd", id: 104), stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2023...2025)
    ],
    "Bolt EUV": [
      .testerNeeded(years: 2017...2022),
      .init(years: 2023...2023, testingStatus: .activeTester("pianoman96", id: 62), stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
  ],
  "Chrysler": [
    " Pacifica Hybrid": [
      .testerNeeded(years: 2017...2020),
      .newTester(years: 2021...2021, username: "joshuahinckley", id: 103),
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "Fiat": [
    " Grande Punto": [
      .testerNeeded(years: 2005...2007),
      .init(years: 2008...2008, testingStatus: .activeTester("afonsosriv", id: 66), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2009...2009)
    ],
  ],
  "Ford": [
    "Mustang": [
      .testerNeeded(years: 1996...2022),
      .init(years: 2023...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
  ],
  "Hyundai": [
    "IONIQ 5": [
      .testerNeeded(years: 2021...2021),
      .init(years: 2022...2022, testingStatus: .activeTester("spenumatsa", id: 114), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .init(years: 2023...2023, testingStatus: .activeTester("spenumatsa", id: 82), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .init(years: 2024...2024, testingStatus: .activeTester("zachmiles", id: 76), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2025...2025)
    ],
  ],
  "Lexus": [
    " GX 460": [
      .testerNeeded(years: 2003...2014),
      .newTester(years: 2015...2015, username: "Thunderbirdhotel", id: 91),
      .testerNeeded(years: 2016...2025)
    ],
  ],
  "MG": [
    "MG4": [
      .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .all, stateOfHealth: .obd, charging: .ota, cells: .obd, fuelLevel: .na, speed: .obd, range: .all, odometer: .all, tirePressure: .ota),
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "Nissan": [
    "Juke": [
      .testerNeeded(years: 1996...2011),
      .init(years: 2012...2012, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2013...2025)
    ],
    "Leaf": [
      .testerNeeded(years: 2010...2017),
      .init(years: 2018...2018, testingStatus: .activeTester("tsprenk", id: 97), stateOfCharge: .obd, stateOfHealth: .obd, charging: .obd, cells: .unk, fuelLevel: .na, speed: .obd, range: .obd, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2019...2025)
    ],
  ],
  "Polestar": [
    " 2":     [
      .testerNeeded(years: 2019...2020),
      .newTester(years: 2021...2021, username: "jpalensk", id: 63),
      .newTester(years: 2022...2022, username: "alexr", id: 77),
      .testerNeeded(years: 2023...2023),
      .newTester(years: 2024...2024, username: "vmax77", id: 89),
      .testerNeeded(years: 2025...2025),
    ],
    " 3":     [
      .newTester(years: 2024...2024, username: "david.rothera", id: 117),
      .testerNeeded(years: 2025...2025),
    ],
  ],
  "Porsche": [
    " 911":     [ .testerNeeded(years: 1996...2025) ],
    "Cayenne":  [
      .testerNeeded(years: 2002...2023),
      .init(years: 2024...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2025...2025)
    ],
    "Macan":    [ .testerNeeded(years: 2014...2025) ],
    "Taycan": [
      .init(years: 2019...2024, testingStatus: .onboarded, stateOfCharge: .all, stateOfHealth: .obd, charging: .ota, cells: .obd, fuelLevel: .na, speed: .obd, range: .all, odometer: .all, tirePressure: .all),
      .testerNeeded(years: 2025...2025)
    ],
  ],
  "Rivian": [
    " R1S": [
      .testerNeeded(years: 2022...2024),
      .init(years: 2025...2025, testingStatus: .activeTester("Alex", id: 61), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Tesla": [
    " Model S": [
      .testerNeeded(years: 2012...2015),
      .init(years: 2016...2016, testingStatus: .activeTester("shaver", id: 65), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .testerNeeded(years: 2017...2025),
    ],
    "Model 3": [
      .init(years: 2017...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2019...2019, testingStatus: .activeTester("justinscheetz", id: 69), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2020...2020, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2021...2021, testingStatus: .activeTester("Atreideez", id: 78), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2023...2023, testingStatus: .activeTester("leoprose", id: 74), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2024...2024, testingStatus: .activeTester("Olitoady", id: 68), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2025...2025, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
    ],
    " Model X": [
      .testerNeeded(years: 2016...2025),
    ],
    "Model Y": [
      .init(years: 2020...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2023...2023, testingStatus: .activeTester("sylvainramousse", id: 64), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2024...2024, testingStatus: .activeTester("amitchell516", id: 80), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2025...2025, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
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
    ],
    " Camry": [
      .testerNeeded(years: 1996...2013),
      .newTester(years: 2014...2014, username: "eliasmalek24", id: 84),
      .testerNeeded(years: 2015...2025)
    ],
    " RAV4 Hybrid": [
      .testerNeeded(years: 2016...2019),
      .newTester(years: 2020...2020, username: "ktaletsk", id: 122),
      .testerNeeded(years: 2021...2024)
    ],
    " Sequoia": [
      .testerNeeded(years: 2001...2002),
      .newTester(years: 2003...2003, username: "tgerring", id: 75),
      .testerNeeded(years: 2004...2025)
    ],
    " Yaris Cross": [
      .testerNeeded(years: 2020...2020),
      .newTester(years: 2021...2021, username: "molgar", id: 119),
      .testerNeeded(years: 2022...2025)
    ],
  ],
  "Volkswagen": [
    "e-Golf": [
      .testerNeeded(years: 2015...2018),
      .init(years: 2019...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2020...2025)
    ],
  ],
  "Volvo": [
    " XC40 Recharge": [
      .testerNeeded(years: 2018...2020),
      .newTester(years: 2021...2021, username: "zandr", id: 85),
      .testerNeeded(years: 2022...2025)
    ],
    " XC60 PHEV": [
      .testerNeeded(years: 2018...2019),
      .init(years: 2020...2020, testingStatus: .activeTester("shaver", id: 65), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2021...2025)
    ],
  ],
]
