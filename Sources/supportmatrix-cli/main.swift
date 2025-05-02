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

    print(merged.getAllMakes())

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

    // Confirmed signals statistics
    print("")
    print("Confirmed Signals Statistics:")
    print("----------------------------")
    let signalStats = merged.getConfirmedSignalsStatistics()
    print("• Total unique confirmed signals: \(signalStats.signals)")
    print("• Vehicles with confirmed signals: \(signalStats.vehicles)")

    // Display some example signals if there are any
    let commonSignalPrefixes = ["VSS", "TIRE", "SPEED", "SOC", "RANGE", "BATT", "TEMP"]
    print("\nExample Confirmed Signals:")

    var foundExamples = false
    for prefix in commonSignalPrefixes {
      // Search for all models supporting signals with this prefix
      // We'll limit to just a couple of examples per prefix
      var count = 0
      for (make, models) in merged.supportMatrix where count < 3 {
        for (_, support) in models.yearConfirmedSignals {
          for signal in support where signal.contains(prefix) {
            print("• \(signal)")
            let vehiclesWithSignal = merged.getVehiclesSupporting(signalName: signal)
            var vehicleCount = 0
            for (_, models) in vehiclesWithSignal {
              vehicleCount += models.count
            }
            print("  • Supported by \(vehicleCount) vehicles")
            count += 1
            foundExamples = true
            break
          }
          if count >= 3 { break }
        }
        if count >= 3 { break }
      }
    }

    if !foundExamples {
      print("• No confirmed signals found in test cases")
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
            enhanceVehicleDetailsWithConfirmedSignals(for: specifiedMake, model: specifiedModel, year: year, merged: merged)
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
              enhanceVehicleDetailsWithConfirmedSignals(for: specifiedMake, model: specifiedModel, year: year, merged: merged)
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

  /// Enhances the vehicle details display with confirmed signals information
  @MainActor
  static func enhanceVehicleDetailsWithConfirmedSignals(
    for make: String, model: String, year: Int?, merged: MergedSupportMatrix
  ) {
    if let year = year {
      // Show signals for a specific year
      let signals = merged.getConfirmedSignals(for: make, model: model, year: year)
      print("\n  • Confirmed Signals: \(signals.count)")
      if !signals.isEmpty {
        for signal in signals.sorted() {
          print("    • \(signal)")
        }
      } else {
        print("    • No confirmed signals found in test cases for this year")
      }
    } else {
      // Show signals for all years
      let allSignals = merged.getAllConfirmedSignals(for: make, model: model)
      let totalSignals = Set(allSignals.values.flatMap { $0 })

      print("\n  • Confirmed Signals across all years: \(totalSignals.count)")

      if !totalSignals.isEmpty {
        let years = allSignals.keys.sorted()
        for year in years {
          if let yearSignals = allSignals[year], !yearSignals.isEmpty {
            print("    • Year \(year): \(yearSignals.count) signals")
            for signal in yearSignals.sorted() {
              print("      • \(signal)")
            }
          }
        }
      } else {
        print("    • No confirmed signals found in test cases for this vehicle")
      }
    }
  }
}
