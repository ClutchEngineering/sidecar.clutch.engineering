import Foundation

typealias Make = String
typealias Model = String
let makes: [Make: [Model: [VehicleSupportStatus]]] = [
  "Acura": [
    "TLX": [
      .init(years: 2015...2015, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .obd),
      .testerNeeded(years: 2016...2025)
    ],
  ],
  "BMW": [
    "i3": [
      .testerNeeded(years: 2014...2017),
      .newTester(years: 2018...2018, username: "bereneb"),
      .init(years: 2019...2019, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .obd, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2020...2021),
    ],
    " i4": [
      .testerNeeded(years: 2022...2025),
    ],
    " iX3": [
      .testerNeeded(years: 2020...2025),
    ],
    "X3": [
      .testerNeeded(years: 2018...2020),
      .init(years: 2021...2021, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2022...2025)
    ],
  ],
  "Chevrolet": [
    " Bolt EV": [
      .testerNeeded(years: 2017...2021),
      .init(years: 2022...2022, testingStatus: .activeTester("wrd"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2023...2025)
    ],
    "Bolt EUV": [
      .testerNeeded(years: 2017...2022),
      .init(years: 2023...2023, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
  ],
  "Chrysler": [
    " Pacifica Hybrid": [
      .testerNeeded(years: 2017...2020),
      .newTester(years: 2021...2021, username: "joshuahinckley"),
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "Fiat": [
    " Grande Punto": [
      .testerNeeded(years: 2005...2007),
      .init(years: 2008...2008, testingStatus: .activeTester("afonsosriv"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2009...2009)
    ],
  ],
  "Ford": [
    "Escape": [
      .testerNeeded(years: 2001...2022),
      .init(years: 2023...2023, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2024...2025)
    ],
    "Mustang": [
      .testerNeeded(years: 1996...2022),
      .init(years: 2023...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
  ],
  "Honda": [
    "CR-V": [
      .testerNeeded(years: 1997...2018),
      .init(years: 2019...2019, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2020...2025)
    ],
  ],
  "Hyundai": [
    "IONIQ 5": [
      .testerNeeded(years: 2021...2021),
      .init(years: 2022...2022, testingStatus: .activeTester("spider"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .init(years: 2023...2023, testingStatus: .activeTester("spenumatsa"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .init(years: 2024...2024, testingStatus: .activeTester("zachmiles"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2025...2025)
    ],
    "IONIQ 6": [
      .testerNeeded(years: 2023...2023),
      .init(years: 2024...2024, testingStatus: .activeTester("Danmartyn"), stateOfCharge: .obd, stateOfHealth: .obd, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .obd),
      .testerNeeded(years: 2025...2025)
    ],
    " IONIQ PHEV": [
      .testerNeeded(years: 2017...2017),
      .init(years: 2018...2018, testingStatus: .activeTester("zaaaacch"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .obd),
      .testerNeeded(years: 2019...2022)
    ],
    " Kona Electric": [
      .testerNeeded(years: 2018...2022),
      .init(years: 2023...2023, testingStatus: .activeTester("Briantran33"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
    "Santa Fe Hybrid": [
      .init(years: 2021...2021, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .init(years: 2022...2022, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "Kia": [
    " EV 6": [
      .testerNeeded(years: 2022...2025),
    ],
    "EV 9": [
      .init(years: 2024...2024, testingStatus: .activeTester("kanithus"), stateOfCharge: .obd, stateOfHealth: .obd, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2025...2025),
    ],
    " Niro EV": [
      .testerNeeded(years: 2019...2023),
    ],
    " Optima": [
      .testerNeeded(years: 2001...2025),
    ],
    " Rio": [
      .testerNeeded(years: 2001...2023),
    ],
    " Sportage": [
      .testerNeeded(years: 1995...2025),
    ],
  ],
  "Lexus": [
    " GX 460": [
      .testerNeeded(years: 2003...2014),
      .newTester(years: 2015...2015, username: "Thunderbirdhotel"),
      .testerNeeded(years: 2016...2025)
    ],
  ],
  "MG": [
    "MG4": [
      .init(years: 2022...2022, testingStatus: .onboarded, stateOfCharge: .all, stateOfHealth: .obd, charging: .ota, cells: .obd, fuelLevel: .na, speed: .obd, range: .all, odometer: .all, tirePressure: .ota),
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "Nissan": [
    "Juke": [
      .testerNeeded(years: 1996...2011),
      .init(years: 2012...2012, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2013...2025)
    ],
    "Leaf": [
      .testerNeeded(years: 2010...2017),
      .init(years: 2018...2018, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .obd, charging: .obd, cells: .unk, fuelLevel: .na, speed: .obd, range: .obd, odometer: .obd, tirePressure: .obd),
      .init(years: 2019...2019, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .obd, charging: .obd, cells: .unk, fuelLevel: .na, speed: .obd, range: .obd, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2020...2025)
    ],
  ],
  "Polestar": [
    "Polestar 2":     [
      .testerNeeded(years: 2019...2020),
      .newTester(years: 2021...2021, username: "jpalensk"),
      .newTester(years: 2022...2022, username: "alexr"),
      .testerNeeded(years: 2023...2023),
      .init(years: 2024...2024, testingStatus: .activeTester("jbritton"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .unk),
      .testerNeeded(years: 2025...2025),
    ],
    " Polestar 3":     [
      .newTester(years: 2024...2024, username: "david.rothera"),
      .testerNeeded(years: 2025...2025),
    ],
  ],
  "Porsche": [
    " 911":     [ .testerNeeded(years: 1996...2025) ],
    "Cayenne":  [
      .testerNeeded(years: 2002...2014),
      .newTester(years: 2015...2015, username: "b2pointoh"),
      .testerNeeded(years: 2016...2023),
      .init(years: 2024...2024, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
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
      .init(years: 2025...2025, testingStatus: .activeTester("Alex"), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Seat": [
    "Leon": [
      .testerNeeded(years: 1999...2016),
      .init(years: 2017...2017, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2018...2025),
    ],
  ],
  "Tesla": [
    " Model S": [
      .testerNeeded(years: 2012...2015),
      .init(years: 2016...2016, testingStatus: .activeTester("shaver"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .testerNeeded(years: 2017...2025),
    ],
    "Model 3": [
      .init(years: 2017...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2019...2019, testingStatus: .activeTester("justinscheetz"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2020...2020, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2021...2021, testingStatus: .activeTester("Atreideez"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2023...2023, testingStatus: .activeTester("leoprose"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2024...2024, testingStatus: .activeTester("Olitoady"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2025...2025, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
    ],
    " Model X": [
      .testerNeeded(years: 2016...2025),
    ],
    "Model Y": [
      .init(years: 2020...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2023...2023, testingStatus: .activeTester("sylvainramousse"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
      .init(years: 2024...2024, testingStatus: .activeTester("amitchell516"), stateOfCharge: .ota, stateOfHealth: .unk, charging: .ota, cells: .unk, fuelLevel: .na, speed: .unk, range: .ota, odometer: .ota, tirePressure: .ota),
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
    "bZ4X": [
      .testerNeeded(years: 2023...2023),
      .init(years: 2024...2024, testingStatus: .activeTester("Jefbos90"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2025...2025)
    ],
    " Camry": [
      .testerNeeded(years: 1996...2002),
      .newTester(years: 2003...2003, username: "lambhofreak"),
      .testerNeeded(years: 2004...2013),
      .newTester(years: 2014...2014, username: "eliasmalek24"),
      .testerNeeded(years: 2015...2025)
    ],
    " RAV4 Hybrid": [
      .testerNeeded(years: 2016...2019),
      .newTester(years: 2020...2020, username: "ktaletsk"),
      .testerNeeded(years: 2021...2024)
    ],
    " Sequoia": [
      .testerNeeded(years: 2001...2002),
      .newTester(years: 2003...2003, username: "tgerring"),
      .testerNeeded(years: 2004...2025)
    ],
    "Tacoma": [
      .testerNeeded(years: 1996...2022),
      .init(years: 2023...2023, testingStatus: .activeTester("jasonmc99"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
    " Tundra": [
      .testerNeeded(years: 2000...2019),
      .newTester(years: 2020...2020, username: "danomeyer"),
      .testerNeeded(years: 2021...2025)
    ],
    " Yaris Cross": [
      .testerNeeded(years: 2020...2020),
      .newTester(years: 2021...2021, username: "molgar"),
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
      .newTester(years: 2021...2021, username: "zandr"),
      .testerNeeded(years: 2022...2025)
    ],
    " XC60 PHEV": [
      .testerNeeded(years: 2018...2019),
      .init(years: 2020...2020, testingStatus: .activeTester("shaver"), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2021...2025)
    ],
  ],
]
