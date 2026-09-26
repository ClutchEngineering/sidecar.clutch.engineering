import Foundation

import Slipstream
import SwiftSoup

/// The footer switch for Clutch Telemetry, which the script finds by
/// `data-analytics-toggle` and labels from the two data attributes. The choice
/// is kept in the browser, and Global Privacy Control turns it off as well.
struct AnalyticsToggle: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let element = try container.appendElement("button")
    try element.attr("type", "button")
    try element.attr("class", "text-blue-300 font-medium hover:underline")
    try element.attr("data-analytics-toggle", "")
    try element.attr("data-label-on", "Analytics: on")
    try element.attr("data-label-off", "Analytics: off")
    try element.text("Analytics: on")
  }
}
