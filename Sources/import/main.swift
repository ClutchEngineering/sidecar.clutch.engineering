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
      // Split the row, handling quoted fields
      let components = row.split(
        separator: ",",
        maxSplits: 2, // We only need 3 fields
        omittingEmptySubsequences: false
      )

      guard components.count >= 3 else { return nil }

      let makeModel = components[0].split(separator: "/")
      guard makeModel.count == 2 else { return nil }

      let make = String(makeModel[0])
      let model = String(makeModel[1])
      let year = Double(components[1]).map { Int($0) }

      // Handle the quoted signals field
      let signalsStr = String(components[2])
        .trimmingCharacters(in: CharacterSet(charactersIn: "\"\\")) // Remove quotes and escapes

      let signals = Set(signalsStr.split(separator: ",").map(String.init))

      return CSVVehicle(make: make, model: model, year: year, signals: signals)
    }
    .filter { $0.year != nil } // Only keep entries with valid years
  }
}

// MARK: - Support Matrix Generator

class SupportMatrixGenerator {
  static func generateSupportStatus(
    from signals: Set<String>,
    year: Int,
    existingStatuses: [VehicleSupportStatus]
  ) -> VehicleSupportStatus {
    // First determine the current signals' states
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

    // Check if any existing status has .na for these fields
    let shouldInheritStateOfCharge = existingStatuses.contains { $0.stateOfCharge == .na }
    let shouldInheritStateOfHealth = existingStatuses.contains { $0.stateOfHealth == .na }
    let shouldInheritCharging = existingStatuses.contains { $0.charging == .na }
    let shouldInheritFuelLevel = existingStatuses.contains { $0.fuelLevel == .na }
    let shouldInheritSpeed = existingStatuses.contains { $0.speed == .na }
    let shouldInheritRange = existingStatuses.contains { $0.range == .na }
    let shouldInheritOdometer = existingStatuses.contains { $0.odometer == .na }
    let shouldInheritTirePressure = existingStatuses.contains { $0.tirePressure == .na }

    return VehicleSupportStatus(
      years: year...year,
      testingStatus: .partiallyOnboarded,
      stateOfCharge: shouldInheritStateOfCharge ? .na : stateOfCharge,
      stateOfHealth: shouldInheritStateOfHealth ? .na : stateOfHealth,
      charging: shouldInheritCharging ? .na : charging,
      cells: .na,
      fuelLevel: shouldInheritFuelLevel ? .na : fuelLevel,
      speed: shouldInheritSpeed ? .na : speed,
      range: shouldInheritRange ? .na : range,
      odometer: shouldInheritOdometer ? .na : odometer,
      tirePressure: shouldInheritTirePressure ? .na : tirePressure
    )
  }
}

// MARK: - Matrix Merger

class MatrixMerger {
  // Helper to find the first model that matches the name, preserving symbols if they exist
  static func findOrCreateModel(name: String, in entries: [VehicleSupportEntry]) -> Model {
    // Try to find an existing model with the same name
    if let existingEntry = entries.first(where: { $0.model.name == name }) {
      return existingEntry.model // Preserve the existing model with its symbol
    }
    // If no matching model found, create a new one without a symbol
    return Model(model: name)
  }

  // Helper to split a status if the year falls within its range
  static func splitStatus(
    _ status: VehicleSupportStatus,
    atYear year: Int,
    signals: Set<String>,
    existingStatuses: [VehicleSupportStatus]
  ) -> (before: VehicleSupportStatus?, current: VehicleSupportStatus, after: VehicleSupportStatus?) {
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

    // Generate new status with CSV data, considering existing NA states
    let currentStatus = SupportMatrixGenerator.generateSupportStatus(
      from: signals,
      year: year,
      existingStatuses: existingStatuses
    )

    return (beforeStatus, currentStatus, afterStatus)
  }

  static func merge(existing entries: [VehicleSupportEntry], csvVehicles: [CSVVehicle]) -> [VehicleSupportEntry] {
    var result = Dictionary(grouping: entries) { $0.make }

    for vehicle in csvVehicles {
      let year = vehicle.year! // Safe as we filtered nil years

      // Find or create the appropriate model, preserving symbols if they exist
      let model = findOrCreateModel(name: vehicle.model, in: result[vehicle.make] ?? [])

      // Find the entry for this make/model if it exists
      if let entryIndex = result[vehicle.make]?.firstIndex(where: { $0.model.name == vehicle.model }) {
        var entry = result[vehicle.make]![entryIndex]

        // Find if there's an existing status that contains this year
        if let statusIndex = entry.supportStatuses.firstIndex(where: { $0.years.contains(year) }) {
          let existingStatus = entry.supportStatuses[statusIndex]

          // Split the existing status
          let (beforeStatus, newStatus, afterStatus) = splitStatus(
            existingStatus,
            atYear: year,
            signals: vehicle.signals,
            existingStatuses: entry.supportStatuses
          )

          // Remove the old status
          entry.supportStatuses.remove(at: statusIndex)

          // Add the split statuses in chronological order
          if let before = beforeStatus {
            entry.supportStatuses.append(before)
          }
          entry.supportStatuses.append(newStatus)
          if let after = afterStatus {
            entry.supportStatuses.append(after)
          }

          // Update the entry
          result[vehicle.make]![entryIndex] = entry
        } else {
          // No existing status for this year, generate new one considering existing NA states
          let status = SupportMatrixGenerator.generateSupportStatus(
            from: vehicle.signals,
            year: year,
            existingStatuses: entry.supportStatuses
          )
          result[vehicle.make]![entryIndex].supportStatuses.append(status)
        }
      } else {
        // Create new entry - no existing statuses to consider for NA inheritance
        let status = SupportMatrixGenerator.generateSupportStatus(from: vehicle.signals, year: year, existingStatuses: [])
        let entry = VehicleSupportEntry(make: vehicle.make, model: model, supportStatuses: [status])
        result[vehicle.make, default: []].append(entry)
      }
    }

    // Convert back to sorted array
    return result.values.flatMap { $0 }.sorted()
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
  let existingEntries = try! VehicleSupportStatus.loadAll().map { make, models in
    models.map { model, statuses in
      VehicleSupportEntry(make: make, model: model, supportStatuses: statuses)
    }
  }.flatMap { $0 }

  // Merge data
  let mergedEntries = MatrixMerger.merge(existing: existingEntries, csvVehicles: csvVehicles)

  // Output merged data
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

  if let outputData = try? encoder.encode(mergedEntries),
     let outputString = String(data: outputData, encoding: .utf8) {
    print(outputString)
  } else {
    print("Error: Failed to encode merged data")
    exit(1)
  }
}

main()
