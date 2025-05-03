import Foundation
import Slipstream

struct IsLastRowEnvironmentKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

extension EnvironmentValues {
  var isLastRow: Bool {
    get { self[IsLastRowEnvironmentKey.self] }
    set { self[IsLastRowEnvironmentKey.self] = newValue }
  }
}