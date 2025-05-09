import Foundation

public typealias SignalID = String

/// Structure to manage signal mappings with year range support
public struct FilterableSignalMap {
  private var filterableSignals: [Filter: [SignalID: Connectable]] = [:]

  public init() {}

  public init(filterableSignals: [Filter: [SignalID: Connectable]]) {
    self.filterableSignals = filterableSignals
  }

  public subscript(filter: Filter) -> [SignalID: Connectable]? {
    get { filterableSignals[filter] }
    set { filterableSignals[filter] = newValue }
  }

  public subscript(filter: Filter, default defaultValue: [SignalID: Connectable]) -> [SignalID: Connectable] {
    get { filterableSignals[filter, default: defaultValue] }
    set { filterableSignals[filter] = newValue }
  }

  /// Returns the signal map for a given model year, falling back to default if no specific range matches
  /// - Parameter modelYear: The model year to find signals for
  /// - Returns: The signal map if found, nil otherwise
  public func connectedSignals(modelYear: Int) -> [SignalID: Connectable]? {
    let matchingSignalMaps = filterableSignals.filter { $0.key.matches(modelYear: modelYear) }.values

    return matchingSignalMaps.reduce(into: [:]) { (result, signalMap) in
      for (signalID, connectable) in signalMap {
        result[signalID] = connectable
      }
    }
  }
}
