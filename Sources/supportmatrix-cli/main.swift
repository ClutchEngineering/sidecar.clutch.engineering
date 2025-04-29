import Foundation
import SupportMatrix

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

print("Loading vehicle metadata from: \(workspacePath)")
print("")

// Load vehicle metadata
do {
  try SupportMatrix.shared.loadVehicleMetadata(from: workspacePath)

  if let vehicleMetadata = SupportMatrix.shared.vehicleMetadata {
    // Print summary statistics
    var totalVehicles = 0
    var totalYears = 0

    for (_, models) in vehicleMetadata.vehicles {
      totalVehicles += models.count
      for (_, years) in models {
        totalYears += years.count
      }
    }

    print("Summary:")
    print("  • Makes: \(vehicleMetadata.vehicles.count)")
    print("  • Models: \(totalVehicles)")
    print("  • Model Years: \(totalYears)")
    print("")

    // Display makes and models
    print("Vehicle Makes and Models:")
    print("------------------------")

    let makes = SupportMatrix.shared.getAllMakes()

    for make in makes {
      print("• \(make)")
      let models = SupportMatrix.shared.getModels(for: make)

      for model in models {
        let years = SupportMatrix.shared.getYears(for: make, model: model)
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
      let supportingVehicles = SupportMatrix.shared.getVehiclesSupporting(command: command)
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

      if let years = vehicleMetadata.vehicles[specifiedMake]?[specifiedModel] {
        if let year = specifiedYear {
          if let commandSupport = years[year] {
            printCommandSupport(for: commandSupport)
          } else {
            print("No data available for year \(year)")
          }
        } else {
          // Print data for all years
          for (year, commandSupport) in years.sorted(by: { $0.key < $1.key }) {
            print("• Year: \(year)")
            printCommandSupport(for: commandSupport)
            print("")
          }
        }
      } else {
        print("Vehicle not found: \(specifiedMake) \(specifiedModel)")
      }
    }
  } else {
    print("No vehicle metadata loaded.")
  }
} catch {
  print("Error loading vehicle metadata: \(error)")
  exit(1)
}

/// Helper function to print command support details
func printCommandSupport(for commandSupport: CommandSupport) {
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
