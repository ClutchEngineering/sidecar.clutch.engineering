import Foundation
import Slipstream

extension Condition {
  static var mobileOnly: Condition { Condition.within(Breakpoint.small..<Breakpoint.medium) }
  static var desktop: Condition { Condition.startingAt(.medium) }
}

let sitemap: Sitemap = [
  "index.html": Home(),
  "privacy-policy/index.html": PrivacyPolicy(),
  "shortcuts/index.html": Shortcuts(),
  "scanning/index.html": Scanning(),
  "scanning/extended-pids/index.html": ExtendedParameters(),
  "scanning/vehicle-support/index.html": VehicleSupport(),
  "bug/index.html": Bug(),
  "supported-cars/index.html": SupportedCars(),
  "beta/index.html": BetaTesterHandbook(),
  "help/index.html": Help(),
]

// Assumes this file is located in a Sources/ sub-directory of a Swift package.
guard let projectURL = URL(filePath: #filePath)?
  .deletingLastPathComponent()
  .deletingLastPathComponent() else {
  print("Unable to create URL for \(#filePath)")
  exit(1)
}

let outputURL = projectURL.appending(path: "site")

try renderSitemap(sitemap, to: outputURL)
