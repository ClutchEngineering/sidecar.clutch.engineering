import Foundation
import Slipstream
import VehicleSupport
import VehicleSupportMatrix

// MARK: - Shared Types

struct LeaderboardEntry {
  let series: String
  let customName: String
  let count: Float
  let driverCount: Int
  var rankChange: Int?  // Change in rank since yesterday
  var mileageChange: Float?  // Change in miles since yesterday
}

// MARK: - Shared Constants

let modelNormalizations: [String: String] = [
  "BMW/335i": "BMW/3 Series",
  "BMW/335d Xdrive": "BMW/3 Series",
  "BMW/3er": "BMW/3 Series",
  "BMW/M440i": "BMW/4 Series",
  "BMW/440i": "BMW/4 Series",
  "BMW/4 Series Gran Coupe": "BMW 4 Series",

  "Hyundai/Ioniq": "Hyundai/IONIQ",
]

let anonymousDriverName = "The stig"

// MARK: - Shared Utilities

struct LeaderboardUtils {
  static func formatNumber(_ value: Float) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: value)) ?? "0"
  }

  static func findVehicleInfo(series: String, in supportMatrix: MergedSupportMatrix) -> (symbolName: String?, vehicleName: String) {
    let components = series
      .replacingOccurrences(of: "BMW ", with: "BMW/")
      .components(separatedBy: "/")
    guard components.count >= 2 else {
      return (nil, series)
    }

    var seriesMake: String
    let seriesModel: String

    if series.lowercased().hasPrefix("vauxhall/opel") {
      seriesMake = "vauxhall-opel"
      seriesModel = String(components.dropFirst(2).joined(separator: "/")).lowercased()
    } else {
      seriesMake = components[0].lowercased()
      seriesModel = components.dropFirst().joined(separator: "/").lowercased()
    }
    if seriesModel.isEmpty {
      return (nil, anonymousDriverName)
    }
    seriesMake = standardizeMake(seriesMake)

    for make in supportMatrix.getAllMakes() {
      let normalizedMake = standardizeMake(make)
      if normalizedMake == seriesMake {
        for obdbID in supportMatrix.getOBDbIDs(for: make) {
          guard let vehicle = supportMatrix.getModel(id: obdbID) else {
            continue
          }
          let normalizedModel = vehicle.model.lowercased()
          if normalizedModel == seriesModel {
            let vehicleName = "\(localizedNameForStandardizedMake(normalizedMake)) \(vehicle.model)"
            return (vehicle.modelSVGs.first, vehicleName)
          }
        }
      }
    }
    let make = components[0]
    let vehicleName = "\(localizedNameForStandardizedMake(standardizeMake(make))) \(String(components.dropFirst().joined(separator: "/")))"
    return (nil, vehicleName)
  }

  static func getCSVModificationDate(resourceName: String) -> String {
    let fileManager = FileManager.default
    let bundle = Bundle.module

    guard let csvPath = bundle.path(forResource: resourceName, ofType: "csv") else {
      print("CSV file not found")
      return "2024-01-07T00:00:00Z" // Fallback date
    }

    do {
      let attributes = try fileManager.attributesOfItem(atPath: csvPath)
      if let modificationDate = attributes[.modificationDate] as? Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: modificationDate)
      }
    } catch {
      print("Error getting file attributes: \(error)")
    }

    return "2025-01-06T00:00:00Z" // Fallback date
  }

  static func processLeaderboardData(
    currentCSV: String,
    yesterdayCSV: String?,
    driversCSV: String,
    supportMatrix: MergedSupportMatrix
  ) -> [LeaderboardEntry] {
    var vehicleEntries: [String: (LeaderboardEntry, String)] = [:]
    var yesterdayEntries: [String: Float] = [:]
    var yesterdayRanks: [String: Int] = [:]
    var driverCounts: [String: Int] = [:]

    // Process drivers data first
    let driverRows = driversCSV.components(separatedBy: .newlines)
    for row in driverRows.dropFirst() {
      let columns = row.components(separatedBy: ",")
      if columns.count == 3,
         let driverCount = Int(columns[2]) {
        let normalizedSeries = modelNormalizations[columns[0]] ?? columns[0]
        let vehicleInfo = findVehicleInfo(series: normalizedSeries, in: supportMatrix)
        let normalizedName = vehicleInfo.vehicleName.lowercased()
        driverCounts[normalizedName] = (driverCounts[normalizedName] ?? 0) + driverCount
      }
    }

    // Process yesterday's data if available
    if let yesterdayCSV = yesterdayCSV {
      let yesterdayRows = yesterdayCSV.components(separatedBy: .newlines)

      // First pass: Combine all entries
      for row in yesterdayRows.dropFirst() {
        let columns = row.components(separatedBy: ",")
        if columns.count == 3,
           let count = Float(columns[2]) {
          let normalizedSeries = modelNormalizations[columns[0]] ?? columns[0]
          let vehicleInfo = findVehicleInfo(series: normalizedSeries, in: supportMatrix)
          let normalizedName = vehicleInfo.vehicleName.lowercased()
          yesterdayEntries[normalizedName] = (yesterdayEntries[normalizedName] ?? 0) + count
        }
      }

      // Second pass: Assign ranks based on sorted combined totals
      let sortedYesterdayEntries = yesterdayEntries.sorted { $0.value > $1.value }
      for (index, entry) in sortedYesterdayEntries.filter({ $0.key != anonymousDriverName.lowercased() && $0.key != "unknown" }).enumerated() {
        yesterdayRanks[entry.key] = index + 1
      }
    }

    // Process today's data
    let rows = currentCSV.components(separatedBy: .newlines)
    for row in rows.dropFirst() {
      let columns = row.components(separatedBy: ",")
      if columns.count == 3,
         let count = Float(columns[2]) {
        let normalizedSeries = modelNormalizations[columns[0]] ?? columns[0]
        let vehicleInfo = findVehicleInfo(series: normalizedSeries, in: supportMatrix)
        let normalizedName = vehicleInfo.vehicleName.lowercased()
        let entry = LeaderboardEntry(
          series: normalizedSeries,
          customName: columns[1],
          count: count,
          driverCount: driverCounts[normalizedName] ?? 0,
          rankChange: nil,
          mileageChange: nil
        )

        if let existingEntry = vehicleEntries[normalizedName] {
          // Add the count to the existing entry
          let updatedEntry = LeaderboardEntry(
            series: existingEntry.0.series,
            customName: existingEntry.0.customName,
            count: existingEntry.0.count + entry.count,
            driverCount: existingEntry.0.driverCount,
            rankChange: nil,
            mileageChange: nil
          )
          vehicleEntries[normalizedName] = (updatedEntry, existingEntry.1)
        } else {
          // Create new entry
          vehicleEntries[normalizedName] = (entry, vehicleInfo.vehicleName)
        }
      }
    }

    // Convert to array and sort by count
    var sortedEntries = vehicleEntries.values.map { entry -> (LeaderboardEntry, String) in
      let normalizedName = entry.1.lowercased()
      let yesterdayCount = yesterdayEntries[normalizedName] ?? 0
      let yesterdayRank = yesterdayRanks[normalizedName]

      var updatedEntry = entry.0
      if !yesterdayEntries.isEmpty {
        updatedEntry.mileageChange = entry.0.count - yesterdayCount
        updatedEntry.rankChange = yesterdayRank
      }

      return (updatedEntry, entry.1)
    }.sorted { $0.0.count > $1.0.count }

    // Update rank changes based on current position
    if !yesterdayRanks.isEmpty {
      for (currentRank, entry) in sortedEntries.filter({ $0.1 != anonymousDriverName }).enumerated() {
        let normalizedName = entry.1.lowercased()
        if let yesterdayRank = yesterdayRanks[normalizedName] {
          sortedEntries[currentRank].0.rankChange = yesterdayRank - (currentRank + 1)
        }
      }
    }

    // Return just the LeaderboardEntry array
    return sortedEntries.map { $0.0 }
  }
}

