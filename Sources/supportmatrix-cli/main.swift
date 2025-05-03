import AirtableAPI
import DotEnvAPI
import Foundation
import SupportMatrix
import VehicleSupportMatrix

@main
struct SupportMatrixCLI {
  static func main() async throws {
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

    // Print program header
    print("Support Matrix CLI")
    print("=================")

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
    print("")

    // Use our new static function to load the MergedSupportMatrix
    let (merged, success) = await MergedSupportMatrix.load(
      using: airtableClient,
      modelsTableID: modelsTableID,
      workspacePath: workspacePath,
      useCache: useCache
    )

    if !success {
      if let error = merged.lastError {
        print("Error loading support matrix: \(error)")
      } else {
        print("Error loading support matrix")
      }
      exit(1)
    }

    let obdbID = "Nissan-Rogue"
    guard let taycan = merged.getModel(id: obdbID) else {
      exit(1)
    }

    // TODO: Need to handle the case where we have no service 01 or command data, but we do have potential connectables.

    let yearRangeSignalMap = merged.connectables(for: obdbID)
    let supportByModelYear = taycan.connectableSupportByModelYear(yearRangeSignalMap: yearRangeSignalMap, saeConnectables: merged.saeConnectables)
    let supportGroupedByModelYear = taycan.connectableSupportGroupByModelYearRange(yearRangeSignalMap: yearRangeSignalMap, saeConnectables: merged.saeConnectables)
    print(supportByModelYear)
    print(supportGroupedByModelYear)

    // Display statistics
    let stats = merged.getStatistics()
    print("Summary:")
    print("  • Makes: \(stats.makes)")
    print("  • Models: \(stats.models)")
    print("  • Model Years: \(stats.modelYears)")
    print("")
  }
}
