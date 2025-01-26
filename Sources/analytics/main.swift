import Foundation

guard let apikey = ProcessInfo.processInfo.environment["POSTHOG_API_KEY"],
      let projectIDString = ProcessInfo.processInfo.environment["POSTHOG_PROJECT_ID"],
      let projectID = Int(projectIDString),
      let airtableAPIKey = ProcessInfo.processInfo.environment["AIRTABLE_API_KEY"],
      let airtableBaseID = ProcessInfo.processInfo.environment["AIRTABLE_BASE_ID"],
      let modelsTableID = ProcessInfo.processInfo.environment["AIRTABLE_MODELS_TABLE_ID"] else {
  fatalError("Missing required environment variables")
}

let exportsURL = URL(filePath: #filePath)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appending(path: "gensite")

print("Fetching # of stigs...")

// Create Airtable client
let airtableClient = AirtableClient(baseID: airtableBaseID, apiKey: airtableAPIKey)

// # of stigs
do {
  let client = PostHogExportClient(apiKey: apikey, projectID: projectID)
  let csvData = try await client.fetchExportedCSV(query: stigsQuery())
  try csvData.write(to: exportsURL.appending(path: "export-carplay-drivers-by-model.csv"))

  // Update Models table in Airtable
  print("Updating driver counts in Airtable Models table...")
  try await airtableClient.updateDriverCounts(csvData, in: modelsTableID)
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
  let csvData = try await client.fetchExportedCSV(query: milesTraveledQuery())
  try csvData.write(to: todayURL)

  // Update Models table in Airtable with miles driven
  print("Updating miles driven in Airtable Models table...")
  try await airtableClient.updateMilesDriven(csvData, in: modelsTableID)
}

print("Done.")
