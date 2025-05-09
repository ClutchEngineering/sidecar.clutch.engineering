import Foundation

import AirtableAPI
import DotEnvAPI
import VehicleSupportMatrix

import Slipstream

// Assumes this file is located in a Sources/gensite sub-directory of a Swift package.
guard let projectURL = URL(filePath: #filePath)?
  .deletingLastPathComponent()
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
DotEnv.load(from: projectURL.appending(path: ".env").path())

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
let useCache = true // args.contains("--use-cache")

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

let supportMatrix = try await MergedSupportMatrix.load(
  using: airtableClient,
  modelsTableID: modelsTableID,
  workspacePath: workspacePath,
  useCache: useCache
)

print("Generating sitemap...")

var sitemap: Sitemap = [
  "index.html": Home(),
  "privacy-policy/index.html": PrivacyPolicy(
    appName: "Sidecar",
    introText: "Sidecar is delighted to be our users' choice for understanding the state of their garage.",
    publicationDate: "October 2, 2024"
  ),
  "privacy-policy/elmcheck/index.html": PrivacyPolicy(
    appName: "ELMCheck",
    introText: "ELMCheck is the easiest way to check the authenticity of your OBD scanner.",
    publicationDate: "October 2, 2024"
  ),
  "shortcuts/index.html": Shortcuts(),
  "scanning/index.html": Scanning(),
  "scanning/extended-pids/index.html": ExtendedParameters(),
  "bug/index.html": Bug(),
  "supported-cars/index.html": MakeGridPage(supportMatrix: supportMatrix),
  "beta/index.html": BetaTesterHandbook(),
  "leaderboard/index.html": LeaderboardPage(supportMatrix: supportMatrix),
  "leaderboard/last24hours/index.html": Leaderboard24HoursPage(supportMatrix: supportMatrix),
  "leaderboard/makes/index.html": LeaderboardByMakePage(supportMatrix: supportMatrix),
  "beta/leaderboard/index.html": Redirect(URL(string: "/leaderboard")),
  "leave-a-review/index.html": Redirect(URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1663683832&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")),
  "help/index.html": Help(),
]

for make in supportMatrix.getAllMakes() {
  guard let url = MakeLink.url(for: make) else {
    continue
  }
  sitemap[url.appending(component: "index.html").path()] = MakePage(supportMatrix: supportMatrix, make: make)
}

func renderSitemapWithLogs(_ sitemap: Sitemap, to folder: URL, encoding: String.Encoding = .utf8) throws {
  for (path, view) in sitemap.sorted(by: { $0.key < $1.key }) {
    print("Rendering \(path)")

    let output = try "<!DOCTYPE html>\n" + renderHTML(view)
    let fileURL = folder.appending(path: path)
    let folderURL = fileURL.deletingLastPathComponent()
    if !FileManager.default.fileExists(atPath: folderURL.path(percentEncoded: false)) {
      try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
    }
    try output.write(to: fileURL, atomically: true, encoding: encoding)
  }
}

try renderSitemapWithLogs(sitemap, to: outputURL)

// Generate and write sitemap.xml
func generateSitemapXML(from sitemap: Sitemap, baseURL: String = "https://sidecar.clutch.engineering") throws {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate]

    // Function to escape XML special characters in URLs
    func escapeXMLSpecialCharacters(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "'", with: "&apos;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    var xmlContent = """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

    """

    for path in sitemap.keys.sorted() {
        // Skip redirects as they shouldn't be in the sitemap
        if path.contains("leave-a-review") {
            continue
        }

        // Convert relative path to absolute URL
        var absoluteURL = baseURL
        if !absoluteURL.hasSuffix("/"),
           !path.hasPrefix("/") {
          absoluteURL.append("/")
        }
        absoluteURL += path.replacingOccurrences(of: "index.html", with: "")

        // Escape special characters for XML
        let escapedURL = escapeXMLSpecialCharacters(absoluteURL)

        xmlContent += """
        <url>
          <loc>\(escapedURL)</loc>
        </url>

        """
    }

    xmlContent += "</urlset>"

    let sitemapURL = outputURL.appending(path: "sitemap.xml")
    try xmlContent.write(to: sitemapURL, atomically: true, encoding: .utf8)
    print("Generated sitemap.xml")
}

try generateSitemapXML(from: sitemap)

print("Done")
