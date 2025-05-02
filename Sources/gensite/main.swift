import Foundation

import AirtableAPI
import DotEnvAPI
import VehicleSupportMatrix

import Slipstream

// Assumes this file is located in a Sources/gensite sub-directory of a Swift package.
guard let projectURL = URL(filePath: #filePath)?
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent() else {
  print("Unable to create URL for \(#filePath)")
  exit(1)
}

let outputURL = projectURL.appending(path: "site")

extension Condition {
  static var mobileOnly: Condition { Condition.within(Breakpoint.small..<Breakpoint.medium) }
  static var desktop: Condition { Condition.startingAt(.medium) }
}

// Load environment variables from .env file if it exists
DotEnv.load()

guard let airtableAPIKey = ProcessInfo.processInfo.environment["AIRTABLE_API_KEY"] else {
  fatalError("Missing AIRTABLE_API_KEY")
}

guard let airtableBaseID = ProcessInfo.processInfo.environment["AIRTABLE_BASE_ID"] else {
  fatalError("Missing AIRTABLE_BASE_ID")
}

guard let modelsTableID = ProcessInfo.processInfo.environment["AIRTABLE_MODELS_TABLE_ID"] else {
  fatalError("Missing AIRTABLE_MODELS_TABLE_ID")
}

// Get workspace path from command line arguments or use default
let workspacePath: String
let args = CommandLine.arguments

// Check if cache should be used (default is false)
let useCache = true  // args.contains("--use-cache")

// Extract workspace path from arguments
if args.count > 1 && !args[1].hasPrefix("--") {
  workspacePath = args[1]
} else {
  // Default to the workspace directory in the current project
  let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
  let workspaceURL = currentDirectoryURL.appendingPathComponent("workspace")
  workspacePath = workspaceURL.path
}

// Create Airtable client
let airtableClient = AirtableClient(baseID: airtableBaseID, apiKey: airtableAPIKey)

// Load and merge vehicle data
print("Loading vehicle metadata from: \(workspacePath)")
if useCache {
  print("Using cached data if available")
}
print("")

// Use our new static function to load the MergedSupportMatrix
let (supportMatrix, success) = await MergedSupportMatrix.load(
  using: airtableClient,
  modelsTableID: modelsTableID,
  workspacePath: workspacePath,
  useCache: useCache
)

assert(success, "Failed to load vehicle metadata")

print("Generating sitemap...")

let sitemap: Sitemap = [
  // "index.html": Home(),
  // "privacy-policy/index.html": PrivacyPolicy(
  //   appName: "Sidecar",
  //   introText: "Sidecar is delighted to be our users' choice for understanding the state of their garage.",
  //   publicationDate: "October 2, 2024"
  // ),
  // "privacy-policy/elmcheck/index.html": PrivacyPolicy(
  //   appName: "ELMCheck",
  //   introText: "ELMCheck is the easiest way to check the authenticity of your OBD scanner.",
  //   publicationDate: "October 2, 2024"
  // ),
  // "shortcuts/index.html": Shortcuts(),
  // "scanning/index.html": Scanning(),
  // "scanning/extended-pids/index.html": ExtendedParameters(),
  // "bug/index.html": Bug(),
  // "supported-cars/index.html": SupportedCars(),
  "supported-cars-v2/index.html": SupportedCarsV2(supportMatrix: supportMatrix),
  // "beta/index.html": BetaTesterHandbook(),
  // "leaderboard/index.html": LeaderboardPage(),
  // "leaderboard/last24hours/index.html": Leaderboard24HoursPage(),
  // "leaderboard/makes/index.html": LeaderboardByMakePage(),
  // "beta/leaderboard/index.html": Redirect(URL(string: "/leaderboard")),
  // "leave-a-review/index.html": Redirect(URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1663683832&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")),
  // "help/index.html": Help(),
]

try renderSitemap(sitemap, to: outputURL)

print("Done")
