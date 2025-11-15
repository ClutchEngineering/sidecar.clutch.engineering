import Foundation

import SupportMatrix

extension MergedSupportMatrix {
  /// Structure to hold combined model data with command support information
  public struct ModelSupport: Codable, Sendable {
    public let obdbID: OBDbID
    public let make: String
    public let model: String
    public enum EngineType: String, Codable, Sendable {
      case combustion = "Combustion"
      case hybrid = "Hybrid"
      case electric = "Electric"

      public var hasBattery: Bool {
        switch self {
        case .hybrid, .electric:
          return true
        case .combustion:
          return false
        }
      }
      public var hasFuel: Bool {
        switch self {
        case .combustion, .hybrid:
          return true
        case .electric:
          return false
        }
      }
    }
    public let engineType: EngineType
    public let modelSVGs: [String]
    public let numberOfDrivers: Int
    public let numberOfMilesDriven: Int
    public let onboarded: Bool

    enum CodingKeys: String, CodingKey {
      case obdbID
      case make
      case model
      case engineType
      case modelSVGs
      case onboarded
      case yearCommandSupport
      case yearConfirmedSignals
      case generations
      case numberOfDrivers
      case numberOfMilesDriven
    }

    public var yearCommandSupport: [Int: CommandSupport]
    public var yearConfirmedSignals: [Int: Set<String>]
    public var generations: [Generation]

    public init(
      obdbID: OBDbID,
      make: String,
      model: String,
      engineType: EngineType,
      modelSVGs: [String],
      numberOfDrivers: Int,
      numberOfMilesDriven: Int,
      onboarded: Bool
    ) {
      self.obdbID = obdbID
      self.make = make
      self.model = model
      self.engineType = engineType
      self.modelSVGs = modelSVGs
      self.yearCommandSupport = [:]
      self.yearConfirmedSignals = [:]
      self.generations = []
      self.numberOfDrivers = numberOfDrivers
      self.numberOfMilesDriven = numberOfMilesDriven
      self.onboarded = onboarded
    }

    public var allModelYears: [Int] {
      var years = Set(yearCommandSupport.keys).union(Set(yearConfirmedSignals.keys))

      // Add years from generations
      for generation in generations {
        if let yearRange = generation.yearRange {
          for year in yearRange {
            years.insert(year)
          }
        }
      }

      // Only return years since OBD was introduced.
      return years.filter { $0 >= 1988 }.sorted()
    }

    public var modelYearRange: ClosedRange<Int>? {
      let allModelYears = self.allModelYears
      guard let minYear = allModelYears.min(),
            let maxYear = allModelYears.max() else {
        return nil
      }
      return minYear...maxYear
    }

    public enum ConnectableSupportLevel: Int, Comparable, Sendable {
      case unknown = 0
      case shouldBeSupported = 1
      case confirmed = 2

      public static func < (lhs: MergedSupportMatrix.ModelSupport.ConnectableSupportLevel, rhs: MergedSupportMatrix.ModelSupport.ConnectableSupportLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
      }
    }
    public func connectableSupportByModelYear(
      filterableSignalMap: FilterableSignalMap,
      saeConnectables: FilterableSignalMap
    ) -> [Int: [Connectable: ConnectableSupportLevel]] {
      var support: [Int: [Connectable: ConnectableSupportLevel]] = [:]

      for modelYear in allModelYears {
        support[modelYear] = [:]

        guard let connectedSignals = filterableSignalMap.connectedSignals(modelYear: modelYear) else {
          print("Warning: No connected signals found for model year \(modelYear)")
          continue
        }

        let nonSAEConnectedSignals = connectedSignals.filter {
          saeConnectables.connectedSignals(modelYear: modelYear)?[$0.key] == nil
        }
        for connectable in nonSAEConnectedSignals.values {
          guard connectable.isVisualizedInSupportMatrix else {
            continue
          }
          support[modelYear, default: [:]][connectable] = .shouldBeSupported
        }

        // Track any connectables that *should* be supported
        if let commandSupport = yearCommandSupport[modelYear] {
          let allSupportedSignals = Set(commandSupport.allSupportedSignals)
          let allSupportedConnectables = Set(allSupportedSignals.compactMap { connectedSignals[$0]})
          for connectable in allSupportedConnectables {
            guard connectable.isVisualizedInSupportMatrix else {
              continue
            }
            support[modelYear, default: [:]][connectable] = .shouldBeSupported
          }
        }

        // And then check for any connectables that are confirmed with real vehicle data
        if let confirmedSignals = yearConfirmedSignals[modelYear] {
          let confirmedConnectables = Set(confirmedSignals.compactMap { connectedSignals[$0]})
          for confirmedConnectable in confirmedConnectables {
            guard confirmedConnectable.isVisualizedInSupportMatrix else {
              continue
            }
            support[modelYear, default: [:]][confirmedConnectable] = .confirmed
          }
        }
      }

      // Propagate confirmed signals within generations
      // First, collect all confirmed and shouldBeSupported connectables by generation
      var confirmedByGeneration: [Generation: Set<Connectable>] = [:]
      var shouldBeSupportedByGeneration: [Generation: Set<Connectable>] = [:]

      for generation in generations {
        guard let yearRange = generation.yearRange else { continue }

        var generationConfirmed = Set<Connectable>()
        var generationShouldBeSupported = Set<Connectable>()

        for year in yearRange {
          if let yearSupport = support[year] {
            for (connectable, level) in yearSupport {
              if level == .confirmed {
                generationConfirmed.insert(connectable)
              } else if level == .shouldBeSupported {
                generationShouldBeSupported.insert(connectable)
              }
            }
          }
        }

        if !generationConfirmed.isEmpty {
          confirmedByGeneration[generation] = generationConfirmed
        }

        if !generationShouldBeSupported.isEmpty {
          shouldBeSupportedByGeneration[generation] = generationShouldBeSupported
        }
      }

      // Then apply those connectables to all years in each generation
      // First apply shouldBeSupported, then confirmed (to ensure confirmed takes priority)
      for (generation, shouldBeSupportedConnectables) in shouldBeSupportedByGeneration {
        guard let yearRange = generation.yearRange else { continue }

        for year in yearRange {
          for connectable in shouldBeSupportedConnectables {
            // Only set if not already set to .confirmed
            if support[year]?[connectable] != .confirmed {
              support[year, default: [:]][connectable] = .shouldBeSupported
            }
          }
        }
      }

      for (generation, confirmedConnectables) in confirmedByGeneration {
        guard let yearRange = generation.yearRange else { continue }

        for year in yearRange {
          for connectable in confirmedConnectables {
            support[year, default: [:]][connectable] = .confirmed
          }
        }
      }

      for year in support.keys {
        support[year] = support[year]?.filter {
          ($0.key.isBatteryRelated && self.engineType.hasBattery)
          || ($0.key.isFuelRelated && self.engineType.hasFuel)
          || (!$0.key.isBatteryRelated && !$0.key.isFuelRelated)
        }
      }

      return support
    }

    public func connectableSupportGroupByModelYearRange(
      filterableSignalMap: FilterableSignalMap,
      saeConnectables: FilterableSignalMap
    ) -> [ClosedRange<Int>: [Connectable: ConnectableSupportLevel]] {
      // Get support by individual model years first
      let supportByYear = connectableSupportByModelYear(
        filterableSignalMap: filterableSignalMap,
        saeConnectables: saeConnectables
      )

      // Return empty dictionary if there's no support data
      guard !supportByYear.isEmpty else {
        return [:]
      }

      // Get all years sorted
      let years = supportByYear.keys.sorted()

      var result: [ClosedRange<Int>: [Connectable: ConnectableSupportLevel]] = [:]
      var currentRange: (start: Int, end: Int)? = nil
      var currentSupport: [Connectable: ConnectableSupportLevel]? = nil

      for year in years {
        let yearSupport = supportByYear[year]!

        if currentRange == nil {
          // First year in sequence
          currentRange = (year, year)
          currentSupport = yearSupport
        } else if yearSupport == currentSupport {
          // Same support as previous year, extend the range
          currentRange!.end = year
        } else {
          // Different support, add the current range to result and start a new one
          result[currentRange!.start...currentRange!.end] = currentSupport!
          currentRange = (year, year)
          currentSupport = yearSupport
        }
      }

      // Add the last range
      if let range = currentRange, let support = currentSupport {
        result[range.start...range.end] = support
      }

      return result
    }

    /// Structure representing a row in the parameter support table
    public struct ParameterTableRow: Sendable {
      public let parameter: Parameter
      public let supportByYear: [Int: ParameterSupportLevel]

      public init(parameter: Parameter, supportByYear: [Int: ParameterSupportLevel]) {
        self.parameter = parameter
        self.supportByYear = supportByYear
      }
    }

    /// Structure grouping parameters by their path
    public struct ParameterTableSection: Sendable {
      public let path: String
      public let rows: [ParameterTableRow]

      public init(path: String, rows: [ParameterTableRow]) {
        self.path = path
        self.rows = rows
      }
    }

    /// Build a parameter support table organized by path
    /// - Parameter parameterMap: The ParameterMap containing all parameters for this vehicle
    /// - Returns: Array of sections, each containing parameters grouped by path
    public func buildParameterSupportTable(
      parameterMap: ParameterMap
    ) -> [ParameterTableSection] {
      let allModelYears = self.allModelYears

      // Get all unique parameters and organize by path
      var parametersByPath: [String: Set<Parameter>] = [:]

      for year in allModelYears {
        guard let yearParameters = parameterMap.parameters(modelYear: year) else {
          continue
        }

        for parameter in yearParameters.values {
          parametersByPath[parameter.path, default: Set()].insert(parameter)
        }
      }

      // Build rows for each parameter
      var sections: [ParameterTableSection] = []

      for (path, parameters) in parametersByPath.sorted(by: { $0.key < $1.key }) {
        var rows: [ParameterTableRow] = []

        for parameter in parameters.sorted(by: { $0.name < $1.name }) {
          var supportByYear: [Int: ParameterSupportLevel] = [:]

          for year in allModelYears {
            // Only mark as confirmed if we have actual vehicle data
            if let confirmedSignals = yearConfirmedSignals[year],
               confirmedSignals.contains(parameter.id) {
              supportByYear[year] = .confirmed
            } else {
              // If the parameter exists in the definition but isn't confirmed, mark as unknown
              supportByYear[year] = .unknown
            }
          }

          rows.append(ParameterTableRow(parameter: parameter, supportByYear: supportByYear))
        }

        if !rows.isEmpty {
          sections.append(ParameterTableSection(path: path, rows: rows))
        }
      }

      return sections
    }
  }
}
