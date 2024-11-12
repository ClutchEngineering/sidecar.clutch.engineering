import Foundation

import VehicleSupport

// MARK: - Models

struct CSVVehicle {
  let make: String
  let model: String
  let year: Int?
  let signals: Set<String>
}

// MARK: - CSV Parser

class CSVParser {
  static func parse(csv: String) -> [CSVVehicle] {
    let rows = csv.components(separatedBy: .newlines)
      .filter { !$0.isEmpty }
      .dropFirst() // Skip header

    return rows.compactMap { row -> CSVVehicle? in
      let columns = row.components(separatedBy: ",")
      guard columns.count >= 3 else { return nil }

      let makeModel = columns[0].split(separator: "/")
      guard makeModel.count >= 1 else { return nil }

      let make = String(makeModel[0])
      let model = makeModel.count > 1 ? String(makeModel[1]) : ""
      let year = Double(columns[1]).map { Int($0) }
      let signals = Set(columns[2].split(separator: ",").map(String.init))

      return CSVVehicle(make: make, model: model, year: year, signals: signals)
    }
    .filter { $0.year != nil } // Only keep entries with valid years
  }
}

// MARK: - Support Matrix Generator

class SupportMatrixGenerator {
  static func generateSupportStatus(from signals: Set<String>, year: Int) -> VehicleSupportStatus {
    let stateOfCharge: VehicleSupportStatus.SupportState? = signals.contains("stateOfCharge") ? .obd : nil
    let stateOfHealth: VehicleSupportStatus.SupportState? = signals.contains("stateOfHealth") ? .obd : nil
    let charging: VehicleSupportStatus.SupportState? = signals.contains("isCharging") ? .obd : nil
    let fuelLevel: VehicleSupportStatus.SupportState? = signals.contains("fuelTankLevel") ? .obd : nil
    let speed: VehicleSupportStatus.SupportState? = signals.contains("speed") ? .obd : nil
    let range: VehicleSupportStatus.SupportState? = signals.contains("electricRange") ? .obd : nil
    let odometer: VehicleSupportStatus.SupportState? = signals.contains("odometer") ? .obd : nil
    let tirePressure: VehicleSupportStatus.SupportState? = signals.contains("frontLeftTirePressure")
    || signals.contains("frontRightTirePressure")
    || signals.contains("rearLeftTirePressure")
    || signals.contains("rearRightTirePressure") ? .obd : nil

    return VehicleSupportStatus(
      years: year...year,
      testingStatus: .onboarded,
      stateOfCharge: stateOfCharge,
      stateOfHealth: stateOfHealth,
      charging: charging,
      cells: .na,
      fuelLevel: fuelLevel,
      speed: speed,
      range: range,
      odometer: odometer,
      tirePressure: tirePressure
    )
  }
}

// MARK: - Matrix Merger

class MatrixMerger {
  static func merge(
    existing: [Make: [Model: [VehicleSupportStatus]]]?,
    csvVehicles: [CSVVehicle]
  ) -> [Make: [Model: [VehicleSupportStatus]]] {
    var result = existing ?? [:]

    for vehicle in csvVehicles {
      let model = Model(stringLiteral: vehicle.model)

      // Create make entry if it doesn't exist
      if result[vehicle.make] == nil {
        result[vehicle.make] = [:]
      }

      // Create model entry if it doesn't exist
      if result[vehicle.make]?[model] == nil {
        result[vehicle.make]?[model] = []
      }

      // Generate support status directly from the vehicle's signals
      let status = SupportMatrixGenerator.generateSupportStatus(from: vehicle.signals, year: vehicle.year!)

      // Add the status
      result[vehicle.make]?[model]?.append(status)
    }

    return result
  }
}

// MARK: - Main

func main() {
  // Check for command line argument
  guard CommandLine.arguments.count > 1 else {
    print("Error: Please provide path to CSV file")
    print("Usage: \(CommandLine.arguments[0]) <path-to-csv>")
    exit(1)
  }

  let csvPath = CommandLine.arguments[1]

  // Read the CSV data
  guard let csvData = try? String(contentsOf: URL(fileURLWithPath: csvPath), encoding: .utf8) else {
    print("Error: Could not read CSV file at \(csvPath)")
    exit(1)
  }

  let csvVehicles = CSVParser.parse(csv: csvData)
  let existingMatrix: [Make: [Model: [VehicleSupportStatus]]] = try! VehicleSupportStatus.loadAll()

  // Merge data
  let mergedMatrix = MatrixMerger.merge(existing: existingMatrix, csvVehicles: csvVehicles)

  // Output merged data
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

  if let outputData = try? encoder.encode(mergedMatrix),
     let outputString = String(data: outputData, encoding: .utf8) {
    print(outputString)
  } else {
    print("Error: Failed to encode merged data")
    exit(1)
  }
}

main()
