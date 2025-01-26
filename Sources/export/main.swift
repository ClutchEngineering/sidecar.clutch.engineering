import Foundation

import VehicleSupport

// Helper function to convert SupportState to string
func supportStateToString(_ state: VehicleSupportStatus.SupportState?) -> String {
  state?.rawValue ?? ""
}

// Helper function to extract tester username
func getTesterUsername(_ status: VehicleSupportStatus.TestingStatus) -> String {
  switch status {
  case .activeTester(let username):
    return username
  default:
    return ""
  }
}

// Helper function to convert testing status to string
func getTestingStatusString(_ status: VehicleSupportStatus.TestingStatus) -> String {
  switch status {
  case .onboarded:
    return "onboarded"
  case .partiallyOnboarded:
    return "partiallyOnboarded"
  case .testerNeeded:
    return "testerNeeded"
  case .activeTester:
    return "activeTester"
  }
}

// CSV header
let header = "make,model,year,symbolName,testingStatus,testerUsername,cells,charging,fuelLevel,odometer,speed,stateOfCharge,stateOfHealth"
print(header)

do {
  let matrix = try VehicleSupportStatus.loadAll()

  // Process each make
  for (make, models) in matrix.sorted(by: { $0.key < $1.key }) {
    // Process each model
    for (model, statuses) in models.sorted(by: { $0.key.name < $1.key.name }) {
      // Process each status
      for status in statuses.sorted(by: { $0.years.lowerBound < $1.years.lowerBound }) {
        // For each year in the range
        for year in status.years {
          let row = [
            make,
            model.name,
            String(year),
            model.symbolName ?? "",
            getTestingStatusString(status.testingStatus),
            getTesterUsername(status.testingStatus),
            supportStateToString(status.cells),
            supportStateToString(status.charging),
            supportStateToString(status.fuelLevel),
            supportStateToString(status.odometer),
            supportStateToString(status.speed),
            supportStateToString(status.stateOfCharge),
            supportStateToString(status.stateOfHealth)
          ].map { value in
            // Escape commas and quotes in values
            if value.contains(",") || value.contains("\"") {
              return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
            }
            return value
          }.joined(separator: ",")

          print(row)
        }
      }
    }
  }
} catch {
  print("Error loading support matrix: \(error)")
  exit(1)
}
