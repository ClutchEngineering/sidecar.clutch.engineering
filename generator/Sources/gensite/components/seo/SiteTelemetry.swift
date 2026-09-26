import Foundation

import Slipstream
import SwiftSoup

/// Clutch Telemetry, reported beside ``SiteAnalytics``.
///
/// The script is built in the monorepo from the Pelican site's own telemetry
/// (`sites/pelican/scripts/build-standalone-telemetry.mjs`) and copied to
/// `site/scripts/clutch-telemetry.js`; rebuild it there rather than editing it
/// here. It reports as the same product as the site that will replace this
/// one, told apart by `codebase` and by the commit each page was built from.
///
/// Rendered only in a GitHub Actions build, which is the one that deploys. A
/// page generated locally has no commit to name and nowhere it should report.
struct SiteTelemetry: View {
  static let api = "https://telemetry.clutch.engineering/v1"
  static let appStoreURL = "https://apps.apple.com/us/app/electric-sidecar/id1663683832"

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    guard let build = ProcessInfo.processInfo.environment["GITHUB_SHA"], !build.isEmpty else {
      return
    }
    // Slipstream's Script takes no data attributes, so the tag is written here.
    let element = try container.appendElement("script")
    try element.attr("src", "/scripts/clutch-telemetry.js")
    try element.attr("defer", "")
    try element.attr("data-api", Self.api)
    try element.attr("data-tier", "production")
    try element.attr("data-build", build)
    try element.attr("data-codebase", "sidecar")
    try element.attr("data-app-store", Self.appStoreURL)
  }
}
