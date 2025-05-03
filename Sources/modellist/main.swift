import AirtableAPI
import DotEnvAPI
import Foundation

// Main program
@main
struct ModelsListApp {
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

    // Create Airtable client
    let airtableClient = AirtableClient(baseID: airtableBaseID, apiKey: airtableAPIKey)

    // Fetch and print all models
    let sortedRecords: [AirtableRecord] = try await airtableClient.fetchModels(from: modelsTableID)

    // Print header
    print("\n=== Models List ===")
    print("Total models: \(sortedRecords.count)\n")

    // Print each model
    for record: AirtableRecord in sortedRecords {
      print("- \(String(describing: record.fields.make)) \(String(describing: record.fields.model))")
    }

    print("\nDone.")
  }
}
