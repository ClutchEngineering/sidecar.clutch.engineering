import Foundation

// Extension to get current year from Date
extension Date {
    var year: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return Int(formatter.string(from: self))!
    }
}

public typealias Year = Int
public typealias Make = String
public typealias Model = String

/// Represents a vehicle generation with name and year range
public struct Generation: Codable, Equatable, Hashable {
  public let name: String
  public let startYear: Int
  public let endYear: Int?
  public let description: String?

  public var yearRange: ClosedRange<Int>? {
    guard let endYear = endYear else {
      // For generations that are still ongoing, use current year
      return startYear...Int(Date().year)
    }
    return startYear...endYear
  }

  enum CodingKeys: String, CodingKey {
    case name
    case startYear = "start_year"
    case endYear = "end_year"
    case description
  }
}

/// A vehicle represents a particular make and model
public struct Vehicle {
  public let make: Make
  public let model: Model
  public var years: [Year: CommandSupport]

  public init(make: Make, model: Model, years: [Year: CommandSupport] = [:]) {
    self.make = make
    self.model = model
    self.years = years
  }
}

/// Container for all vehicle metadata
public struct VehicleMetadata {
  public var vehicles: [Make: [Model: [Year: CommandSupport]]]
  public var confirmedSignals: [Make: [Model: [Year: Set<String>]]]
  public var generations: [Make: [Model: [Generation]]]

  public init() {
    self.vehicles = [:]
    self.confirmedSignals = [:]
    self.generations = [:]
  }

  public mutating func addVehicle(
    make: Make, model: Model, year: Year, commandSupport: CommandSupport
  ) {
    if vehicles[make] == nil {
      vehicles[make] = [:]
    }

    if vehicles[make]?[model] == nil {
      vehicles[make]?[model] = [:]
    }

    vehicles[make]?[model]?[year] = commandSupport
  }

  public mutating func addGenerations(
    make: Make, model: Model, generations: [Generation]
  ) {
    if self.generations[make] == nil {
      self.generations[make] = [:]
    }

    if self.generations[make]?[model] == nil {
      self.generations[make]?[model] = []
    }

    self.generations[make]?[model] = generations
  }
}
