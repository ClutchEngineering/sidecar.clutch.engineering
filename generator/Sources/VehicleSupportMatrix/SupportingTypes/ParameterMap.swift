import Foundation

/// Structure to manage all parameters with year range support
public struct ParameterMap: Sendable {
  /// Map of filters to parameters
  private var filterableParameters: [Filter: [String: Parameter]] = [:]

  public init() {}

  public init(filterableParameters: [Filter: [String: Parameter]]) {
    self.filterableParameters = filterableParameters
  }

  public subscript(filter: Filter) -> [String: Parameter]? {
    get { filterableParameters[filter] }
    set { filterableParameters[filter] = newValue }
  }

  public subscript(filter: Filter, default defaultValue: [String: Parameter]) -> [String: Parameter] {
    get { filterableParameters[filter, default: defaultValue] }
    set { filterableParameters[filter] = newValue }
  }

  /// Returns all parameters for a given model year
  /// - Parameter modelYear: The model year to find parameters for
  /// - Returns: Dictionary mapping parameter IDs to Parameters
  public func parameters(modelYear: Int) -> [String: Parameter]? {
    let matchingParameterMaps = filterableParameters.filter { $0.key.matches(modelYear: modelYear) }.values

    return matchingParameterMaps.reduce(into: [:]) { (result, parameterMap) in
      for (parameterID, parameter) in parameterMap {
        result[parameterID] = parameter
      }
    }
  }

  /// Returns all unique parameters across all filters
  public var allParameters: [Parameter] {
    let allParamsDict = filterableParameters.values.reduce(into: [:]) { result, params in
      result.merge(params) { _, new in new }
    }
    return Array(allParamsDict.values)
  }

  /// Returns all unique parameter IDs across all filters
  public var allParameterIDs: Set<String> {
    Set(filterableParameters.values.flatMap { $0.keys })
  }
}
