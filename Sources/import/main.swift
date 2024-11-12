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
      guard makeModel.count == 2 else { return nil }

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
  // Helper to find the first model that matches the name, preserving symbols if they exist
  static func findOrCreateModel(name: String, in existingModels: [Model: [VehicleSupportStatus]]?) -> Model {
    // If we have existing models, try to find one with the same name
    if let existingModels = existingModels {
      if let existingModel = existingModels.keys.first(where: { $0.model == name }) {
        return existingModel // Preserve the existing model with its symbol
      }
    }
    // If no matching model found, create a new one without a symbol
    return Model(model: name)
  }

  // Helper to split a status if the year falls within its range
  static func splitStatus(_ status: VehicleSupportStatus, atYear year: Int) -> (before: VehicleSupportStatus?, current: VehicleSupportStatus, after: VehicleSupportStatus?) {
    let range = status.years

    // If year is not in range, return nil for splits
    guard range.contains(year) else {
      return (nil, status, nil)
    }

    // Create the three parts
    var beforeStatus: VehicleSupportStatus?
    var afterStatus: VehicleSupportStatus?

    // If there are years before our target year
    if range.lowerBound < year {
      beforeStatus = VehicleSupportStatus(
        years: range.lowerBound...(year - 1),
        testingStatus: status.testingStatus,
        stateOfCharge: status.stateOfCharge,
        stateOfHealth: status.stateOfHealth,
        charging: status.charging,
        cells: status.cells,
        fuelLevel: status.fuelLevel,
        speed: status.speed,
        range: status.range,
        odometer: status.odometer,
        tirePressure: status.tirePressure
      )
    }

    // If there are years after our target year
    if range.upperBound > year {
      afterStatus = VehicleSupportStatus(
        years: (year + 1)...range.upperBound,
        testingStatus: status.testingStatus,
        stateOfCharge: status.stateOfCharge,
        stateOfHealth: status.stateOfHealth,
        charging: status.charging,
        cells: status.cells,
        fuelLevel: status.fuelLevel,
        speed: status.speed,
        range: status.range,
        odometer: status.odometer,
        tirePressure: status.tirePressure
      )
    }

    // Create the current year status
    let currentStatus = VehicleSupportStatus(
      years: year...year,
      testingStatus: status.testingStatus,
      stateOfCharge: status.stateOfCharge,
      stateOfHealth: status.stateOfHealth,
      charging: status.charging,
      cells: status.cells,
      fuelLevel: status.fuelLevel,
      speed: status.speed,
      range: status.range,
      odometer: status.odometer,
      tirePressure: status.tirePressure
    )

    return (beforeStatus, currentStatus, afterStatus)
  }

  static func merge(
    existing: [Make: [Model: [VehicleSupportStatus]]]?,
    csvVehicles: [CSVVehicle]
  ) -> [Make: [Model: [VehicleSupportStatus]]] {
    var result = existing ?? [:]

    for vehicle in csvVehicles {
      let year = vehicle.year!  // Safe as we filtered nil years

      // Create make entry if it doesn't exist
      if result[vehicle.make] == nil {
        result[vehicle.make] = [:]
      }

      // Find or create the appropriate model, preserving symbols if they exist
      let model = findOrCreateModel(name: vehicle.model, in: result[vehicle.make])

      // Create model entry if it doesn't exist
      if result[vehicle.make]?[model] == nil {
        result[vehicle.make]?[model] = []
      }

      // Find if there's an existing status that contains this year
      if let existingStatusIndex = result[vehicle.make]?[model]?.firstIndex(where: { $0.years.contains(year) }) {
        let existingStatus = result[vehicle.make]![model]![existingStatusIndex]

        // Split the existing status and get the new status for this year
        let (beforeStatus, currentStatus, afterStatus) = splitStatus(existingStatus, atYear: year)

        // Generate the new status with CSV data
        let newStatus = SupportMatrixGenerator.generateSupportStatus(from: vehicle.signals, year: year)

        // Remove the old status
        result[vehicle.make]?[model]?.remove(at: existingStatusIndex)

        // Add the split statuses in chronological order
        if let before = beforeStatus {
          result[vehicle.make]?[model]?.append(before)
        }
        result[vehicle.make]?[model]?.append(newStatus)
        if let after = afterStatus {
          result[vehicle.make]?[model]?.append(after)
        }
      } else {
        // No existing status for this year, just add the new one
        let status = SupportMatrixGenerator.generateSupportStatus(from: vehicle.signals, year: year)
        result[vehicle.make]?[model]?.append(status)
      }
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
