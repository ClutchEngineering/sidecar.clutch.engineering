import Foundation

package struct Model: Codable, Comparable, Hashable, ExpressibleByStringLiteral {
  package let name: String
  package let symbolName: String?

  package init(model: String) {
    self.name = model
    self.symbolName = nil
  }

  package init(stringLiteral value: StringLiteralType) {
    self.name = value.trimmingCharacters(in: .whitespacesAndNewlines)
    if !value.hasPrefix(" ") {
      symbolName = value.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    } else {
      symbolName = nil
    }
  }

  // Implement Equatable
  package static func == (lhs: Model, rhs: Model) -> Bool {
    lhs.name == rhs.name && lhs.symbolName == rhs.symbolName
  }

  // Implement Comparable
  package static func < (lhs: Model, rhs: Model) -> Bool {
    lhs.name < rhs.name
  }
}

