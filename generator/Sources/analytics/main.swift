import Foundation

import AirtableAPI
import DotEnvAPI
import PostHogAPI

guard let projectRoot = URL(filePath: #filePath)?
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent() else {
  print("Unable to create URL for \(#filePath)")
  exit(1)
}

// Load environment variables from .env file if it exists
DotEnv.load(from: projectRoot.appending(path: ".env").path())

guard let apikey = ProcessInfo.processInfo.environment["POSTHOG_API_KEY"] else {
  fatalError("Missing POSTHOG_API_KEY")
}

guard let projectIDString = ProcessInfo.processInfo.environment["POSTHOG_PROJECT_ID"],
      let projectID = Int(projectIDString) else {
  fatalError("Missing POSTHOG_PROJECT_ID")
}

guard let airtableAPIKey = ProcessInfo.processInfo.environment["AIRTABLE_API_KEY"] else {
  fatalError("Missing AIRTABLE_API_KEY")
}

guard let airtableBaseID = ProcessInfo.processInfo.environment["AIRTABLE_BASE_ID"] else {
  fatalError("Missing AIRTABLE_BASE_ID")
}

guard let modelsTableID = ProcessInfo.processInfo.environment["AIRTABLE_MODELS_TABLE_ID"] else {
  fatalError("Missing AIRTABLE_MODELS_TABLE_ID")
}

let exportsURL = URL(filePath: #filePath)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appending(path: "gensite")

// Data sanitization function
func sanitizeCSVData(_ csvData: Data, vestigialColumnName: String, typoCorrections: [String: String]) throws -> Data {
  guard let csvString = String(data: csvData, encoding: .utf8) else {
    throw NSError(domain: "CSVSanitization", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to decode CSV data"])
  }

  let lines = csvString.components(separatedBy: .newlines).filter { !$0.isEmpty }

  guard !lines.isEmpty else {
    return csvData
  }

  // Keep the header line
  let header = lines[0]
  let headerColumns = header.components(separatedBy: ",")
  guard headerColumns.count == 3 else {
    throw NSError(domain: "CSVSanitization", code: 2, userInfo: [NSLocalizedDescriptionKey: "Incorrect number of header columns: \(headerColumns). Expected 4."])
  }

  let dataLines = Array(lines.dropFirst())

  var aggregatedData: [String: Double] = [:]

  // Process each data line
  for line in dataLines {
    let columns = line.components(separatedBy: ",")

    guard columns.count == headerColumns.count else {
      continue
    }

    let vehicle = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
    let totalCountString = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)

    guard let totalCount = Double(totalCountString) else {
      continue
    }

    // Apply typo correction
    var correctedVehicle = typoCorrections[vehicle] ?? vehicle

    if correctedVehicle.hasSuffix("/") {
      correctedVehicle = anonymousName
    }

    correctedVehicle = correctedVehicle.replacingOccurrences(of: "Vauxhall/Opel", with: "Vauxhall-Opel")

    // Create the key for aggregation (series + custom name)
    let aggregationKey = correctedVehicle

    // Add to aggregated data
    aggregatedData[aggregationKey, default: 0.0] += totalCount
  }

  // Sort by total count (descending)
  let sortedEntries = aggregatedData.sorted { $0.value > $1.value }

  // Rebuild CSV
  var sanitizedLines = ["series,custom name,total count"]
  for (key, value) in sortedEntries {
    let formattedValue = value.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(value)) : String(value)
    sanitizedLines.append("\(key),\(vestigialColumnName),\(formattedValue)")
  }

  let sanitizedCSV = sanitizedLines.joined(separator: "\r\n")

  guard let sanitizedData = sanitizedCSV.data(using: .utf8) else {
    throw NSError(domain: "CSVSanitization", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to encode sanitized CSV"])
  }

  return sanitizedData
}

print("Fetching # of stigs...")

// Create Airtable client
let airtableClient = AirtableClient(baseID: airtableBaseID, apiKey: airtableAPIKey)

// # of stigs
do {
  let client = PostHogExportClient(apiKey: apikey, projectID: projectID)
  let rawCSVData = try await client.fetchExportedCSV(query: stigsQuery())
  let csvData = try sanitizeCSVData(rawCSVData, vestigialColumnName: "# of stigs", typoCorrections: typoCorrections)

// Example output:
// ```
// series,custom name,total count
// Toyota/Camry,# of stigs,920
// /,# of stigs,913
// Porsche/Taycan,# of stigs,766
// Toyota/4Runner,# of stigs,433
// Honda/Civic,# of stigs,257
// Ford/F-150,# of stigs,212
// ...
// ```

  try csvData.write(to: exportsURL.appending(path: "export-carplay-drivers-by-model.csv"))
//
//  // Update Models table in Airtable
//  print("Updating driver counts in Airtable Models table...")
//  try await airtableClient.updateDriverCounts(csvData, in: modelsTableID)
}

print("Copying today's stats to yesterday...")

let yesterdayURL = exportsURL.appending(path: "export-carplay-distance-traveled-by-model-yesterday.csv")
let todayURL = exportsURL.appending(path: "export-carplay-distance-traveled-by-model.csv")

do {
  try FileManager.default.removeItem(at: yesterdayURL)
  try FileManager.default.copyItem(at: todayURL, to: yesterdayURL)
}

print("Fetching today's stats...")

do {
  let client = PostHogExportClient(apiKey: apikey, projectID: projectID)
  let rawCSVData = try await client.fetchExportedCSV(query: milesTraveledQuery())
  let csvData = try sanitizeCSVData(rawCSVData, vestigialColumnName: "Miles traveled", typoCorrections: typoCorrections)

// Example output:
// ```
// series,custom name,total count
// Porsche/Taycan,Miles traveled,222204.81054912304
// Toyota/Camry,Miles traveled,211605.4127345223
// /,Miles traveled,138731.3786228466
// Ford/F-150,Miles traveled,103014.43439880807
// Toyota/4Runner,Miles traveled,91293.81221820317
// ...
// ```

  try csvData.write(to: todayURL)

//  // Update Models table in Airtable with miles driven
//  print("Updating miles driven in Airtable Models table...")
//  try await airtableClient.updateMilesDriven(csvData, in: modelsTableID)
}

print("Done.")
