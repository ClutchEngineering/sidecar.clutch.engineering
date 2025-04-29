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

    if args.count > 1 {
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
    print("")

    // Use our new MergedSupportMatrix to load and merge the data
    let merged = MergedSupportMatrix.shared
    let success = await merged.loadAndMerge(
      using: airtableClient,
      modelsTableID: modelsTableID,
      workspacePath: workspacePath
    )

    if !success {
      if let error = merged.lastError {
        print("Error loading support matrix: \(error)")
      } else {
        print("Error loading support matrix")
      }
      exit(1)
    }

    // Display statistics
    let stats = merged.getStatistics()
    print("Summary:")
    print("  • Makes: \(stats.makes)")
    print("  • Models: \(stats.models)")
    print("  • Model Years: \(stats.modelYears)")
    print("")

    // Display makes and models
    print("Vehicle Makes and Models:")
    print("------------------------")

    let makes = merged.getAllMakes()

    for make in makes {
      print("• \(make)")
      let models = merged.getModels(for: make)

      for model in models {
        let years = merged.getYears(for: make, model: model)
        print(
          "  • \(model) (\(years.count) model years: \(years.sorted().map { String($0) }.joined(separator: ", ")))"
        )
      }

      print("")
    }

    // Command statistics
    print("Command Support Statistics:")
    print("--------------------------")

    // Common OBD-II PIDs to check for
    let commonCommands = [
      "0101": "Monitor status since DTCs cleared",
      "0104": "Engine Load",
      "010C": "Engine RPM",
      "010D": "Vehicle Speed",
      "0111": "Throttle Position",
    ]

    for (command, description) in commonCommands {
      let supportingVehicles = merged.getVehiclesSupporting(command: command)
      var vehicleCount = 0

      for (_, models) in supportingVehicles {
        for (_, _) in models {
          vehicleCount += 1
        }
      }

      print("• \(command): \(description)")
      print("  • Supported by \(vehicleCount) vehicles")
    }

    // Allow for specific vehicle lookup
    if args.count > 3 {
      let specifiedMake = args[2]
      let specifiedModel = args[3]
      var specifiedYear: Year? = nil

      if args.count > 4, let year = Int(args[4]) {
        specifiedYear = year
      }

      print("")
      print(
        "Details for \(specifiedMake) \(specifiedModel)\(specifiedYear != nil ? " (\(specifiedYear!))" : ""):"
      )
      print("-------------------------------------------------------")

      let years = merged.getYears(for: specifiedMake, model: specifiedModel)
      if !years.isEmpty {
        if let year = specifiedYear {
          if let commandSupport = merged.getCommandSupport(
            for: specifiedMake,
            model: specifiedModel,
            year: year
          ) {
            printCommandSupport(for: commandSupport)
          } else {
            print("No data available for year \(year)")
          }
        } else {
          // Print data for all years
          for year in years.sorted() {
            if let commandSupport = merged.getCommandSupport(
              for: specifiedMake,
              model: specifiedModel,
              year: year
            ) {
              print("• Year: \(year)")
              printCommandSupport(for: commandSupport)
              print("")
            }
          }
        }
      } else {
        print("Vehicle not found: \(specifiedMake) \(specifiedModel)")
      }
    }
  }

  /// Helper function to print command support details
  static func printCommandSupport(for commandSupport: CommandSupport) {
    print("  • Model Year: \(commandSupport.modelYear)")
    print("  • CAN ID Format: \(commandSupport.canIdFormat)")
    print(
      "  • Extended Addressing: \(commandSupport.extendedAddressingEnabled ? "Enabled" : "Disabled")"
    )

    print("  • ECUs:")
    for (ecu, commands) in commandSupport.supportedCommandsByEcu {
      print("    • \(ecu): \(commands.count) commands")

      // Optionally print all commands (uncomment if needed)
      // for command in commands {
      //     print("      • \(command)")
      // }
    }
  }
}
