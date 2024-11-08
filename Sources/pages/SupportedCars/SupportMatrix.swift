import Foundation

typealias Make = String
typealias Model = String
let makes: [Make: [Model: [VehicleSupportStatus]]] = [
  "Abarth": [
    " 595": [
      .init(years: 2007...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Acura": [
    " Integra": [
      .init(years: 1996...2001, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .init(years: 2023...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " MDX": [
      .testerNeeded(years: 2001...2025)
    ],
    " RDX": [
      .testerNeeded(years: 2007...2025)
    ],
    "TLX": [
      .init(years: 2015...2015, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .obd),
      .testerNeeded(years: 2016...2025)
    ],
    " TSX": [
      .testerNeeded(years: 2004...2014)
    ],
  ],
  "Alfa Romeo": [
    " Giulietta": [
      .init(years: 2010...2020, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Audi": [
    " A4": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " A5 Sportback": [
      .init(years: 2007...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " A7": [
      .init(years: 2010...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Q7": [
      .init(years: 2005...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " RS 3": [
      .init(years: 2011...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " S4": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " SQ5": [
      .init(years: 2013...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " TT": [
      .init(years: 1998...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " e-tron": [
      .init(years: 2019...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "BMW": [
    " 118D f20": [
      .init(years: 2011...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " 1 Series": [
      .testerNeeded(years: 2004...2025)
    ],
    " 2 Series": [
      .init(years: 2014...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " 3 Series": [
      .testerNeeded(years: 1998...2012),
      .init(years: 2013...2013, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2014...2025),
    ],
    " 318d": [
      .testerNeeded(years: 1998...2025)
    ],
    " 320d": [
      .testerNeeded(years: 1998...2025)
    ],
    " 323i": [
      .testerNeeded(years: 1996...2025)
    ],
    " 325i": [
      .testerNeeded(years: 1996...2025)
    ],
    " 328i": [
      .testerNeeded(years: 1996...2025)
    ],
    " 330e": [
      .init(years: 2016...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " 340i": [
      .init(years: 2015...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " 4 Series": [
      .init(years: 2014...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " 4 Series Gran Coupe": [
      .init(years: 2014...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " 5 Series": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " 520 D": [
      .testerNeeded(years: 2000...2025)
    ],
    " 525xi": [
      .testerNeeded(years: 2004...2010)
    ],
    " 530i": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " 640i f13": [
      .testerNeeded(years: 2011...2018)
    ],
    " 840i": [
      .testerNeeded(years: 2019...2025)
    ],
    " E91": [
      .init(years: 2005...2012, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " G20": [
      .testerNeeded(years: 2018...2025),
    ],
    " I3s": [
      .testerNeeded(years: 2018...2021),
    ],
    " M235i": [
      .testerNeeded(years: 2014...2016),
    ],
    " M240i": [
      .testerNeeded(years: 2016...2025),
    ],
    " M4": [
      .testerNeeded(years: 2014...2025),
    ],
    " X1": [
      .testerNeeded(years: 2009...2020),
      .init(years: 2021...2021, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2022...2025),
    ],
    "X3": [
      .testerNeeded(years: 2018...2020),
      .init(years: 2021...2021, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2022...2025)
    ],
    " X5": [
      .init(years: 1999...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Z3": [
      .testerNeeded(years: 1996...2002)
    ],
    " Z4 30si": [
      .testerNeeded(years: 2006...2008)
    ],
    "i3": [
      .testerNeeded(years: 2014...2017),
      .newTester(years: 2018...2018, username: "bereneb"),
      .init(years: 2019...2019, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .obd, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2020...2021),
    ],
    " i4": [
      .testerNeeded(years: 2022...2025),
    ],
    " iX": [
      .testerNeeded(years: 2021...2025)
    ],
    " iX3": [
      .testerNeeded(years: 2020...2025),
    ],
  ],
  "Buick": [
    " Encore GX": [
      .testerNeeded(years: 2020...2025)
    ],
  ],
  "BYD": [
    " Atto 3": [
      .init(years: 2022...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Dolphin Mini": [
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "Cadillac": [
    " CTS": [
      .testerNeeded(years: 2003...2019)
    ],
    " ELR": [
      .testerNeeded(years: 2014...2016)
    ],
    " XT5": [
      .testerNeeded(years: 2017...2025)
    ],
  ],
  "Chevrolet": [
    " Blazer EV": [
      .init(years: 2024...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Bolt EV": [
      .testerNeeded(years: 2017...2018),
      .init(years: 2019...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2020...2021),
      .init(years: 2022...2022, testingStatus: .activeTester("wrd"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2023...2025)
    ],
    "Bolt EUV": [
      .testerNeeded(years: 2017...2022),
      .init(years: 2023...2023, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
    " Camaro": [
      .testerNeeded(years: 1996...2025)
    ],
    " Colorado": [
      .testerNeeded(years: 2004...2025)
    ],
    " Cruze": [
      .init(years: 2008...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Equinox": [
      .testerNeeded(years: 2005...2025)
    ],
    " Express": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Impala": [
      .testerNeeded(years: 2000...2020)
    ],
    " Lacrosse": [
      .testerNeeded(years: 2005...2019)
    ],
    " Malibu": [
      .init(years: 1997...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " S 10": [
      .testerNeeded(years: 1996...2004)
    ],
    " Silverado 1500": [
      .init(years: 1999...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Silverado 2500": [
      .testerNeeded(years: 1999...2025)
    ],
    " Silverado EV": [
      .init(years: 2024...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Spark": [
      .init(years: 2013...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Trailblazer": [
      .init(years: 2021...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Traverse": [
      .testerNeeded(years: 2009...2025)
    ],
    " Trax": [
      .testerNeeded(years: 2013...2025)
    ],
    " Volt": [
      .init(years: 2011...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Chrysler": [
    " 200": [
      .init(years: 2011...2017, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " 300": [
      .testerNeeded(years: 2005...2023)
    ],
    " Pacifica Hybrid": [
      .testerNeeded(years: 2017...2020),
      .newTester(years: 2021...2021, username: "joshuahinckley"),
      .testerNeeded(years: 2023...2025)
    ],
    " Sebring": [
      .init(years: 1996...2010, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Citroen": [
    " CZero": [
      .testerNeeded(years: 2010...2020)
    ],
    " E C4": [
      .testerNeeded(years: 2020...2025)
    ],
    " eC4 X": [
      .testerNeeded(years: 2022...2025)
    ],
  ],
  "Cupra": [
    " Born": [
      .testerNeeded(years: 2021...2025)
    ],
    " Formentor": [
      .init(years: 2020...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Leon": [
      .testerNeeded(years: 2020...2025)
    ],
  ],
  "Dacia": [
    " Sandero": [
      .testerNeeded(years: 2007...2025)
    ],
    " Spring": [
      .testerNeeded(years: 2021...2025)
    ],
  ],
  "Dodge": [
    " Challenger": [
      .testerNeeded(years: 2008...2023)
    ],
    " Charger": [
      .testerNeeded(years: 2006...2023)
    ],
    " Journey": [
      .init(years: 2009...2020, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "DongFeng": [
    " Seres 3": [
      .testerNeeded(years: 2019...2025)
    ],
  ],
  "DS": [
    " 7": [
      .testerNeeded(years: 2018...2025)
    ],
  ],
  "Fiat": [
    " Grande Punto": [
      .testerNeeded(years: 2005...2007),
      .init(years: 2008...2008, testingStatus: .activeTester("afonsosriv"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2009...2009)
    ],
  ],
  "Fisker": [
    " Ocean": [
      .testerNeeded(years: 2022...2025)
    ],
  ],
  "Ford": [
    " Bronco": [
      .testerNeeded(years: 2021...2025),
    ],
    " Bronco Raptor": [
      .testerNeeded(years: 2022...2025),
    ],
    "Escape": [
      .testerNeeded(years: 2001...2020),
      .init(years: 2021...2021, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2022...2022),
      .init(years: 2023...2023, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2024...2025)
    ],
    " Expedition": [
      .testerNeeded(years: 1997...2025),
      .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2023...2025),
    ],
    " Explorer": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " F-150": [
      .testerNeeded(years: 1996...2021),
        .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2023...2025),
    ],
    " F-150 Lightning": [
      .testerNeeded(years: 2022...2022),
      .init(years: 2023...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025),
    ],
    " F-250": [
      .testerNeeded(years: 1996...2025)
    ],
    " F-350": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Fiesta": [
      .init(years: 1996...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Five Hundred": [
      .testerNeeded(years: 2005...2007)
    ],
    " Focus": [
      .init(years: 1998...2018, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Fusion": [
      .testerNeeded(years: 2006...2016),
      .init(years: 2017...2017, testingStatus: .activeTester("kanithus"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2006...2016),
    ],
    " Fusion Energi": [
      .init(years: 2013...2020, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Fusion Hybrid": [
      .testerNeeded(years: 2010...2020)
    ],
    " Kuga": [
      .init(years: 2008...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Maverick": [
      .init(years: 2022...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    "Mustang": [
      .testerNeeded(years: 1996...2022),
      .init(years: 2023...2023, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
    " Mustang Mach-E": [
      .init(years: 2021...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Ranger": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Sierra": [
      .testerNeeded(years: 1996...2025)
    ],
    " Transit": [
      .init(years: 2015...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Genesis": [
    " G80": [
      .testerNeeded(years: 2017...2025)
    ],
  ],
  "GMC": [
    " Acadia": [
      .init(years: 2007...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Sierra 1500": [
      .init(years: 1999...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
  ],
  "Haval": [
    " H6 HEV": [
      .testerNeeded(years: 2021...2025)
    ],
  ],
  "Honda": [
    "Accord": [
      .testerNeeded(years: 1996...2012),
      .init(years: 2013...2013, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
        .testerNeeded(years: 2014...2017),
      .init(years: 2018...2018, testingStatus: .activeTester("cortiz47"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2019...2024),
    ],
    " Accord Hybrid": [
      .testerNeeded(years: 2005...2025),
    ],
    " City": [
      .testerNeeded(years: 1996...2025)
    ],
    " Civic": [
      .testerNeeded(years: 1996...2023),
      .init(years: 2024...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2025...2025),
    ],
    " Clarity": [
      .testerNeeded(years: 2017...2022)
    ],
    "CR-V": [
      .testerNeeded(years: 1997...2018),
      .init(years: 2019...2019, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2020...2025)
    ],
    " CR-V Hybrid": [
      .testerNeeded(years: 2017...2025)
    ],
    " Fit": [
      .testerNeeded(years: 2001...2020)
    ],
    " HR V": [
      .testerNeeded(years: 2016...2025)
    ],
    " Jazz": [
      .testerNeeded(years: 2001...2025)
    ],
    " M NV": [
      .testerNeeded(years: 2021...2025)
    ],
    " Odyssey": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Pilot": [
      .init(years: 2003...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Prologue": [
      .testerNeeded(years: 2024...2025)
    ],
    " WRV": [
      .testerNeeded(years: 2017...2025)
    ],
  ],
  "Hyundai": [
    " Elantra": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Genesis": [
      .testerNeeded(years: 2009...2016)
    ],
    " i10": [
      .testerNeeded(years: 2007...2025)
    ],
    " i20": [
      .testerNeeded(years: 2008...2025)
    ],
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
      .testerNeeded(years: 2018...2021),
      .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .obd, charging: .obd, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .init(years: 2023...2023, testingStatus: .activeTester("Briantran33"), stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
    " Kona": [
      .init(years: 2018...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Palisade": [
      .init(years: 2020...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Santa Cruz": [
      .init(years: 2022...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    "Santa Fe Hybrid": [
      .init(years: 2021...2021, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .init(years: 2022...2022, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .obd, cells: .obd, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2023...2025)
    ],
    " Sonata": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Tucson": [
      .init(years: 2004...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Veloster": [
      .init(years: 2011...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " i30 Sedan": [
      .init(years: 2007...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
  ],
  "Jeep": [
    " Grand Cherokee": [
      .testerNeeded(years: 1996...2017),
      .init(years: 2018...2018, testingStatus: .partiallyOnboarded, stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2019...2023),
    ],
    " Wrangler": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Wrangler 4xe": [
      .init(years: 2021...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
  ],
  "Kia": [
    " EV 6": [
      .testerNeeded(years: 2022...2023),
      .init(years: 2024...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2025...2025),
    ],
    "EV 9": [
      .init(years: 2024...2024, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .obd, charging: .obd, cells: .obd, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .obd),
      .testerNeeded(years: 2025...2025),
    ],
    " K5": [
      .init(years: 2021...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
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
    " Rondo": [
      .init(years: 2007...2017, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Seltos": [
      .init(years: 2021...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Soul": [
      .init(years: 2010...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Sportage": [
      .init(years: 1995...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Stinger": [
      .init(years: 2018...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Telluride": [
      .init(years: 2020...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
  ],
  "KTM": [
    "RC 390": [
      .testerNeeded(years: 2013...2022),
      .init(years: 2023...2023, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2024...2025),
    ],
  ],
  "Land Rover": [
    " LR4": [
      .init(years: 2010...2016, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Range Rover": [
      .init(years: 2005...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Lexus": [
    " CT 200h": [
      .init(years: 2011...2017, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " ES 300h": [
      .testerNeeded(years: 2013...2025)
    ],
    " GX 460": [
      .testerNeeded(years: 2003...2014),
      .newTester(years: 2015...2015, username: "Thunderbirdhotel"),
      .testerNeeded(years: 2016...2025)
    ],
    " GX 470": [
      .testerNeeded(years: 2003...2009)
    ],
    " IS 300": [
      .init(years: 2001...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " IS 350": [
      .init(years: 2006...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " LC 500": [
      .testerNeeded(years: 2017...2025)
    ],
    " LS": [
      .testerNeeded(years: 1996...2025)
    ],
    " NX 350h": [
      .testerNeeded(years: 2022...2025)
    ],
    " RX 450h": [
      .init(years: 2010...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " UX": [
      .testerNeeded(years: 2019...2025)
    ],
  ],
  "Lincoln": [
    " Corsair": [
      .init(years: 2020...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
  ],
  "Maruti": [
    " Celerio": [
      .testerNeeded(years: 2014...2025)
    ],
  ],
  "Maxus": [
    " eDeliver 3": [
      .testerNeeded(years: 2020...2025)
    ],
  ],
  "Mazda": [
    " 2": [
      .init(years: 2007...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " 3": [
      .init(years: 2004...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " 6": [
      .init(years: 2003...2021, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " BT50": [
      .testerNeeded(years: 2006...2025)
    ],
    " CX-3": [
      .testerNeeded(years: 2016...2025)
    ],
    " CX-5": [
      .init(years: 2013...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " CX-9": [
      .init(years: 2007...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " CX-30": [
      .init(years: 2020...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " CX-50": [
      .init(years: 2023...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " CX-60": [
      .testerNeeded(years: 2022...2025)
    ],
    " CX-90": [
      .testerNeeded(years: 2024...2025)
    ],
    " MX 30": [
      .testerNeeded(years: 2020...2025)
    ],
    " MX 5": [
      .testerNeeded(years: 1996...2025)
    ],
    " RX 7": [
      .testerNeeded(years: 1996...2002)
    ],
  ],
  "Mercedes": [
    " C200d": [
      .testerNeeded(years: 1996...2025)
    ],
    " CLA-Class": [
      .testerNeeded(years: 2013...2025)
    ],
    " C-Class": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " E-Class": [
      .testerNeeded(years: 1996...2025)
    ],
    " E180": [
      .testerNeeded(years: 1996...2025)
    ],
    " EQS-Class": [
      .testerNeeded(years: 2021...2025)
    ],
    " G-Class": [
      .testerNeeded(years: 1996...2025)
    ],
    " GLA250": [
      .testerNeeded(years: 2014...2025)
    ],
    " GLB 250": [
      .testerNeeded(years: 2020...2025)
    ],
    " S-Class": [
      .testerNeeded(years: 1996...2025)
    ],
  ],
  "MG": [
    " Comet": [
      .init(years: 2023...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    "MG4": [
      .init(years: 2022...2022, testingStatus: .onboarded, stateOfCharge: .all, stateOfHealth: .obd, charging: .ota, cells: .obd, fuelLevel: .na, speed: .obd, range: .all, odometer: .all, tirePressure: .ota),
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "MINI": [
    " Clubman F54": [
      .testerNeeded(years: 2015...2025)
    ],
    " Cooper S": [
      .testerNeeded(years: 2002...2025)
    ],
    " Cooper SE": [
      .testerNeeded(years: 2020...2025)
    ],
    " Hardtop": [
      .testerNeeded(years: 2002...2025)
    ],
    " JCW": [
      .testerNeeded(years: 2008...2025)
    ],
  ],
  "Mitsubishi": [
    " Challenger": [
      .testerNeeded(years: 1996...2016)
    ],
    " Eclipse Cross": [
      .init(years: 2018...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Eclipse Cross PHEV": [
      .testerNeeded(years: 2021...2025)
    ],
    " Lancer": [
      .testerNeeded(years: 1996...2017)
    ],
    " Outlander": [
      .init(years: 2003...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Outlander PHEV": [
      .init(years: 2018...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " RVR": [
      .init(years: 2011...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
  ],
  "Nissan": [
    " Altima": [
      .testerNeeded(years: 1996...2025)
    ],
    " ARIYA": [
      .init(years: 2023...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Kicks": [
      .init(years: 2018...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
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
    " Murano": [
      .init(years: 2003...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Pathfinder": [
      .testerNeeded(years: 1996...2023),
      .init(years: 2024...2024, testingStatus: .activeTester("KingSpud"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2025...2025),
    ],
    " Qashqai": [
      .init(years: 2006...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    "Rogue": [
      .init(years: 2014...2014, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2015...2016),
      .init(years: 2017...2017, testingStatus: .activeTester("arronsparrow"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2018...2025)
    ],
    " Sentra": [
      .testerNeeded(years: 1996...2025)
    ],
    " X Trail": [
      .testerNeeded(years: 2001...2025)
    ],
  ],
  "Omoda": [
    " Omoda 5 EV": [
      .testerNeeded(years: 2023...2025)
    ],
  ],
  "Opel": [
    " Corsa": [
      .testerNeeded(years: 1996...2025)
    ],
  ],
  "Peugeot": [
    " 2008": [
      .testerNeeded(years: 2013...2025)
    ],
    " 208": [
      .testerNeeded(years: 2012...2025)
    ],
    " 308": [
      .testerNeeded(years: 2007...2025)
    ],
    " 308 Hybrid": [
      .init(years: 2021...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " 505": [
      .testerNeeded(years: 1996...2025)
    ],
    " 508": [
      .testerNeeded(years: 2011...2025)
    ],
    " Expert": [
      .testerNeeded(years: 1996...2025)
    ],
    " e 208": [
      .testerNeeded(years: 2019...2025)
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
    " Polestar 4": [
      .testerNeeded(years: 2024...2025)
    ],
  ],
  "Porsche": [
    " 718": [
      .testerNeeded(years: 2016...2025)
    ],
    " 911":     [
      .testerNeeded(years: 1996...2025)
    ],
    "Cayenne":  [
      .testerNeeded(years: 2002...2014),
      .newTester(years: 2015...2015, username: "b2pointoh"),
      .testerNeeded(years: 2016...2023),
      .init(years: 2024...2024, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2025...2025)
    ],
    "Macan":    [
      .testerNeeded(years: 2014...2023),
      .init(years: 2024...2024, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2025...2025),
    ],
    " Panamera": [
      .testerNeeded(years: 2010...2025),
    ],
    "Taycan": [
      .init(years: 2019...2024, testingStatus: .onboarded, stateOfCharge: .all, stateOfHealth: .obd, charging: .ota, cells: .obd, fuelLevel: .na, speed: .obd, range: .all, odometer: .all, tirePressure: .all),
      .testerNeeded(years: 2025...2025)
    ],
  ],
  "Ram": [
    " 1500": [
      .testerNeeded(years: 2010...2025),
      .init(years: 2019...2019, testingStatus: .activeTester("mattbires"), stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2010...2025),
    ],
  ],
  "Renault": [
    " Clio": [
      .testerNeeded(years: 1996...2025)
    ],
    " Clio 5": [
      .testerNeeded(years: 2019...2025)
    ],
    " Clio V": [
      .testerNeeded(years: 2019...2025)
    ],
    " Duster": [
      .testerNeeded(years: 2010...2025)
    ],
    " Kadjar": [
      .init(years: 2015...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Kwid": [
      .testerNeeded(years: 2015...2025)
    ],
    " Megane": [
      .testerNeeded(years: 1996...2025)
    ],
    " Megane E-Tech": [
      .testerNeeded(years: 2022...2025)
    ],
    " Scenic E-Tech": [
      .init(years: 2024...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Symbol": [
      .testerNeeded(years: 1999...2025)
    ],
    " Zoe": [
      .init(years: 2012...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Rivian": [
    " R1S": [
      .testerNeeded(years: 2022...2024),
      .init(years: 2025...2025, testingStatus: .activeTester("Alex"), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " R1T": [
      .testerNeeded(years: 2022...2025)
    ],
  ],
  "Saab": [
    " 9-3": [
      .testerNeeded(years: 1998...2014)
    ],
  ],
  "Scion": [
    " FR S": [
      .testerNeeded(years: 2013...2016)
    ],
  ],
  "Seat": [
    " Ibiza": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    "Leon": [
      .testerNeeded(years: 1999...2016),
      .init(years: 2017...2017, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2018...2025),
    ],
    " Mii Electric": [
      .testerNeeded(years: 2020...2023)
    ],
  ],
  "Škoda": [
    " Fabia": [
      .testerNeeded(years: 1999...2025)
    ],
    " Kamiq": [
      .testerNeeded(years: 2019...2025)
    ],
    " Octavia": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Smart": [
    " Smart 1": [
      .testerNeeded(years: 2022...2025)
    ],
  ],
  "Subaru": [
    " Ascent": [
      .testerNeeded(years: 2019...2025)
    ],
    " BRZ": [
      .testerNeeded(years: 2013...2025)
    ],
    " Crosstrek": [
      .init(years: 2013...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Forester": [
      .init(years: 1997...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Impreza": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Legacy": [
      .testerNeeded(years: 1996...2025)
    ],
    " Outback": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Solterra": [
      .init(years: 2023...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " WRX": [
      .init(years: 2002...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Suzuki": [
    " Swift": [
      .testerNeeded(years: 1996...2025)
    ],
  ],
  "Tata": [
    " Harrier": [
      .testerNeeded(years: 2019...2025)
    ],
  ],
  "Tesla": [
    " Cybertruck": [
      .testerNeeded(years: 2024...2025)
    ],
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
    " Auris": [
      .testerNeeded(years: 2006...2018)
    ],
    " Avalon": [
      .init(years: 1996...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " C HR": [
      .testerNeeded(years: 2016...2025)
    ],
    " Camry": [
      .testerNeeded(years: 1996...2002),
      .newTester(years: 2003...2003, username: "lambhofreak"),
      .testerNeeded(years: 2004...2013),
      .newTester(years: 2014...2014, username: "eliasmalek24"),
      .testerNeeded(years: 2015...2025)
    ],
    " Camry Hybrid": [
      .testerNeeded(years: 2007...2025)
    ],
    " Corolla": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Corolla Cross": [
      .testerNeeded(years: 2020...2025)
    ],
    " Corolla Hybrid": [
      .init(years: 2020...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Corolla iM": [
      .testerNeeded(years: 2016...2018)
    ],
    " Crown Signia": [
      .testerNeeded(years: 2024...2025)
    ],
    " Fortuner": [
      .testerNeeded(years: 2005...2025)
    ],
    " GR Corolla": [
      .testerNeeded(years: 2023...2025)
    ],
    " GR86": [
      .init(years: 2022...2022, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2023...2025),
    ],
    " Grand Highlander": [
      .testerNeeded(years: 2024...2025)
    ],
    " Highlander": [
      .init(years: 2001...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Innova": [
      .testerNeeded(years: 2004...2025)
    ],
    " Ist": [
      .testerNeeded(years: 2002...2016)
    ],
    " Land Cruiser": [
      .init(years: 1996...2021, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " MR2": [
      .testerNeeded(years: 1996...2007)
    ],
    " Prius": [
      .testerNeeded(years: 1997...2025)
    ],
    " Prius Prime": [
      .init(years: 2017...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Prius v": [
      .init(years: 2012...2017, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " RAV4": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " RAV4 Hybrid": [
      .testerNeeded(years: 2016...2019),
      .newTester(years: 2020...2020, username: "ktaletsk"),
      .testerNeeded(years: 2021...2024)
    ],
    " RAV4 Prime": [
      .testerNeeded(years: 2021...2025)
    ],
    " Sequoia": [
      .testerNeeded(years: 2001...2002),
      .newTester(years: 2003...2003, username: "tgerring"),
      .testerNeeded(years: 2004...2025)
    ],
    " Sienna": [
      .init(years: 1998...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    "Tacoma": [
      .testerNeeded(years: 1996...2022),
      .init(years: 2023...2023, testingStatus: .onboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2024...2025)
    ],
    " Tundra": [
      .testerNeeded(years: 2000...2019),
      .newTester(years: 2020...2020, username: "danomeyer"),
      .testerNeeded(years: 2021...2025)
    ],
    " Venza": [
      .init(years: 2009...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Yaris": [
      .init(years: 1999...2020, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Yaris Cross": [
      .testerNeeded(years: 2020...2020),
      .newTester(years: 2021...2021, username: "molgar"),
      .testerNeeded(years: 2022...2025)
    ],
    " Yaris iA": [
      .testerNeeded(years: 2016...2018)
    ],
    "bZ4X": [
      .testerNeeded(years: 2023...2023),
      .init(years: 2024...2024, testingStatus: .onboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2025...2025)
    ],
  ],
  "Vauxhall": [
    " Ampera": [
      .init(years: 2011...2015, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Astra": [
      .testerNeeded(years: 1996...2025)
    ],
    " Corsa": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Mokka": [
      .testerNeeded(years: 2012...2025)
    ],
    " Mokka e": [
      .testerNeeded(years: 2020...2025)
    ],
  ],
  "Volkswagen": [
    " Atlas": [
      .testerNeeded(years: 2018...2025)
    ],
    " CC": [
      .testerNeeded(years: 2009...2017)
    ],
    " Crafter": [
      .testerNeeded(years: 2006...2025)
    ],
    "e-Golf": [
      .testerNeeded(years: 2015...2018),
      .init(years: 2019...2019, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .obd, odometer: .obd, tirePressure: .unk),
      .testerNeeded(years: 2020...2025)
    ],
    " Golf": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Golf R": [
      .init(years: 2012...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " GTE": [
      .testerNeeded(years: 2015...2025)
    ],
    " Golf City": [
      .testerNeeded(years: 2007...2010)
    ],
    " Golf GTI": [
      .testerNeeded(years: 1996...2025)
    ],
    " Golf Variant": [
      .testerNeeded(years: 1996...2025)
    ],
    " ID.3": [
      .init(years: 2020...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " ID.4": [
      .init(years: 2021...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " ID.5": [
      .testerNeeded(years: 2022...2025)
    ],
    " ID7 Tourer": [
      .init(years: 2024...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Jetta": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Jetta GLI": [
      .testerNeeded(years: 2002...2025),
    ],
    " Passat": [
      .testerNeeded(years: 2002...2015),
      .init(years: 2016...2016, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2017...2025),
    ],
    " Polo": [
      .init(years: 1996...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Rabbit": [
      .testerNeeded(years: 2006...2009)
    ],
    " Scirocco": [
      .init(years: 2008...2017, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " Taigo": [
      .testerNeeded(years: 2021...2025)
    ],
    " Taos": [
      .testerNeeded(years: 2022...2025)
    ],
    " Tiguan": [
      .init(years: 2007...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " Touran": [
      .init(years: 2003...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " T Cross": [
      .testerNeeded(years: 2019...2025)
    ],
    " T Roc": [
      .testerNeeded(years: 2017...2025)
    ],
    " Up": [
      .init(years: 2011...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Volvo": [
    " C30": [
      .testerNeeded(years: 2006...2013)
    ],
    " EX30": [
      .testerNeeded(years: 2024...2025)
    ],
    " S60": [
      .testerNeeded(years: 2000...2025)
    ],
    " S90": [
      .init(years: 2016...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " V50": [
      .testerNeeded(years: 2004...2012)
    ],
    " V60": [
      .init(years: 2011...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .obd, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .obd, tirePressure: .unk),
    ],
    " V70": [
      .init(years: 1996...2016, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .unk, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
    " V90 Cross Country": [
      .testerNeeded(years: 2017...2025)
    ],
    " XC40 Recharge": [
      .testerNeeded(years: 2018...2020),
      .newTester(years: 2021...2021, username: "zandr"),
      .testerNeeded(years: 2022...2025)
    ],
    " XC60": [
      .testerNeeded(years: 2009...2025)
    ],
    " XC60 PHEV": [
      .testerNeeded(years: 2018...2019),
      .init(years: 2020...2020, testingStatus: .activeTester("shaver"), stateOfCharge: .unk, stateOfHealth: .unk, charging: .unk, cells: .unk, fuelLevel: .na, speed: .unk, range: .unk, odometer: .unk, tirePressure: .unk),
      .testerNeeded(years: 2021...2025)
    ],
    " XC90": [
      .init(years: 2003...2024, testingStatus: .partiallyOnboarded, stateOfCharge: .na, stateOfHealth: .na, charging: .na, cells: .na, fuelLevel: .obd, speed: .obd, range: .unk, odometer: .unk, tirePressure: .unk),
    ],
  ],
  "Voyah": [
    " Free": [
      .testerNeeded(years: 2021...2025)
    ],
  ],
]
