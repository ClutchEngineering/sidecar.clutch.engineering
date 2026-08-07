import Foundation

import Slipstream

/// The site's Google Analytics tag.
///
/// Lives in one place so a property change cannot reach some pages and miss
/// others; both the main ``Page`` template and the standalone cheat sheet
/// shell render this.
struct SiteAnalytics: View {
  static let measurementID = "G-TDB4CTWESJ"

  var body: some View {
    Script(URL(string: "https://www.googletagmanager.com/gtag/js?id=\(Self.measurementID)"), executionMode: .async)
    Script("""
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());

gtag('config', '\(Self.measurementID)');
""")
  }
}
