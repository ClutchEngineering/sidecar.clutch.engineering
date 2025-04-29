import Foundation

import Yams

/// A parser for vehicle metadata from the workspace directory
public class VehicleMetadataParser {
  private let fileManager = FileManager.default
  private let workspacePath: String

  // Special cases for makes with dashes in their names
  private let specialMakes = [
    "Alfa-Romeo",
    "Aston-Martin",
    "Mercedes-Benz",
    "Rolls-Royce",
    "Land-Rover",
  ]

  public init(workspacePath: String) {
    self.workspacePath = workspacePath
  }

  /// Parse all vehicles in the workspace directory
  public func parseAllVehicles() throws -> VehicleMetadata {
    var metadata = VehicleMetadata()

    let workspaceContents = try fileManager.contentsOfDirectory(atPath: workspacePath)

    for item in workspaceContents {
      let itemPath = (workspacePath as NSString).appendingPathComponent(item)
      var isDirectory: ObjCBool = false

      if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory),
        isDirectory.boolValue,
        item.contains("-")
      {
        do {
          let (make, model) = parseMakeAndModel(from: item)
          let vehicleData = try parseVehicleDirectory(at: itemPath, make: make, model: model)

          for (year, commandSupport) in vehicleData {
            metadata.addVehicle(
              make: make, model: model, year: year, commandSupport: commandSupport)
          }
        } catch {
          print("Error parsing vehicle directory \(item): \(error)")
        }
      }
    }

    return metadata
  }

  /// Parse make and model from a directory name
  private func parseMakeAndModel(from directoryName: String) -> (make: String, model: String) {
    // Check if it's one of the special makes
    for specialMake in specialMakes {
      if directoryName.hasPrefix(specialMake + "-") {
        let model = String(directoryName.dropFirst(specialMake.count + 1))  // +1 for the dash
        return (specialMake, model)
      }
    }

    // Regular case: First component is make, rest is model
    let components = directoryName.components(separatedBy: "-")
    let make = components[0]
    let model = components.dropFirst().joined(separator: "-")

    return (make, model)
  }

  /// Parse a vehicle directory for command support information
  private func parseVehicleDirectory(at path: String, make: String, model: String) throws -> [Year:
    CommandSupport]
  {
    var yearData = [Year: CommandSupport]()

    // Path to tests/test_cases
    let testCasesPath = (path as NSString).appendingPathComponent("tests/test_cases")

    if !fileManager.fileExists(atPath: testCasesPath) {
      return yearData
    }

    let years = try fileManager.contentsOfDirectory(atPath: testCasesPath)

    for yearString in years {
      let yearPath = (testCasesPath as NSString).appendingPathComponent(yearString)
      var isDirectory: ObjCBool = false

      if fileManager.fileExists(atPath: yearPath, isDirectory: &isDirectory),
        isDirectory.boolValue,
        let year = Int(yearString)
      {

        let commandSupportPath = (yearPath as NSString).appendingPathComponent(
          "command_support.yaml")

        if fileManager.fileExists(atPath: commandSupportPath) {
          let yamlData = try String(contentsOfFile: commandSupportPath, encoding: .utf8)
          let commandSupport = try YAMLDecoder().decode(CommandSupport.self, from: yamlData)
          yearData[year] = commandSupport
        }
      }
    }

    return yearData
  }
}
