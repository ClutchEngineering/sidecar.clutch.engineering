import Foundation
import Slipstream

extension Condition {
  static var mobileOnly: Condition { Condition.within(Breakpoint.small..<Breakpoint.medium) }
  static var desktop: Condition { Condition.startingAt(.medium) }
}

let sitemap: Sitemap = [
  "index.html": Home(),
  "privacy-policy/index.html": PrivacyPolicy(
    appName: "Sidecar",
    introText: "Sidecar is delighted to be our users' choice for understanding the state of their garage.",
    publicationDate: "October 2, 2024"
  ),
  "privacy-policy/elmcheck/index.html": PrivacyPolicy(
    appName: "ELMCheck",
    introText: "ELMCheck is the easiest way to check the authenticity of your OBD scanner.",
    publicationDate: "October 2, 2024"
  ),
  "shortcuts/index.html": Shortcuts(),
  "scanning/index.html": Scanning(),
  "scanning/extended-pids/index.html": ExtendedParameters(),
  "scanning/vehicle-support/index.html": VehicleSupport(),
  "bug/index.html": Bug(),
  "supported-cars/index.html": SupportedCars(),
  "beta/index.html": BetaTesterHandbook(),
  "leaderboard/index.html": LeaderboardPage(),
  "leaderboard/last24hour/index.html": Leaderboard24HoursPage(),
  "beta/leaderboard/index.html": Redirect(URL(string: "/leaderboard")),
  "leave-a-review/index.html": Redirect(URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1663683832&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")),
  "help/index.html": Help(),
]

// Assumes this file is located in a Sources/gensite sub-directory of a Swift package.
guard let projectURL = URL(filePath: #filePath)?
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent() else {
  print("Unable to create URL for \(#filePath)")
  exit(1)
}

let outputURL = projectURL.appending(path: "site")

try renderSitemap(sitemap, to: outputURL)
