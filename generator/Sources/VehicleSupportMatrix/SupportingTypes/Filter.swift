import Foundation

public struct Filter: Codable, Hashable, Equatable, Sendable {
  /// Model year lower bound, inclusive.
  ///
  /// If provided, vehicles whose model year is greater than or equal to this value will pass the filter.
  public let from: Int?

  /// Model year upper bound, inclusive.
  ///
  /// If provided, only vehicles whose model year is less than or equal to this value will pass the filter.
  public let to: Int?

  /// A collection of specific model years.
  ///
  /// If provided, any vehicle whose model year is in this set will pass the filter.
  public let years: Set<Int>?

  init(rawValue: String) {
    guard rawValue != "ALL" else {
      self.from = nil
      self.to = nil
      self.years = nil
      return
    }

    let components = rawValue.split(separator: ",")
    var from: Int?
    var to: Int?
    var years: Set<Int> = Set()

    for component in components {
      if component.hasSuffix("<=") {
        let yearString = component.replacingOccurrences(of: "<=", with: "")
        if let year = Int(yearString) {
          from = year
        }
      } else if component.hasPrefix("<=") {
        let yearString = component.replacingOccurrences(of: ">=", with: "")
        if let year = Int(yearString) {
          to = year
        }
      } else if let year = Int(component) {
        years.insert(year)
      }
    }

    self.from = from
    self.to = to
    if years.isEmpty {
      self.years = nil
    } else {
      self.years = years
    }
  }

  public func matches(modelYear: Int?) -> Bool {
    if let modelYear {
      if let from,
         let to {
        if from < to {
          if modelYear >= from,
             modelYear <= to {
            return true
          }
        } else if modelYear >= from || modelYear <= to {
          return true
        }
      } else if let to {
        if modelYear <= to {
          return true
        }
      } else if let from {
        if modelYear >= from {
          return true
        }
      }
      if let years,
         years.contains(modelYear) {
        return true
      }
    }
    return false
  }
}
