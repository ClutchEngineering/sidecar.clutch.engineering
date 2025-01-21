import Foundation

guard let apikey = ProcessInfo.processInfo.environment["POSTHOG_API_KEY"],
      let projectIDString = ProcessInfo.processInfo.environment["POSTHOG_PROJECT_ID"],
      let projectID = Int(projectIDString) else {
  fatalError("Missing required environment variables POSTHOG_API_KEY and/or POSTHOG_PROJECT_ID")
}

let exportsURL = URL(filePath: #filePath)
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appending(path: "gensite")

// # of stigs
do {
  let client = PostHogExportClient(apiKey: apikey, projectID: projectID)
  let csvData = try await client.fetchExportedCSV(query: stigsQuery())
  try csvData.write(to: exportsURL.appending(path: "export-carplay-drivers-by-model.csv"))
}

// Copy today's stats to yesterday.

let yesterdayURL = exportsURL.appending(path: "export-carplay-distance-traveled-by-model-yesterday.csv")
let todayURL = exportsURL.appending(path: "export-carplay-distance-traveled-by-model.csv")

do {
  try FileManager.default.removeItem(at: yesterdayURL)
  try FileManager.default.copyItem(at: todayURL, to: yesterdayURL)
}

do {
  let client = PostHogExportClient(apiKey: apikey, projectID: projectID)
  let csvData = try await client.fetchExportedCSV(query: milesTraveledQuery())
  try csvData.write(to: todayURL)
}
