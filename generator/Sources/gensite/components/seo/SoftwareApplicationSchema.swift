import Foundation
import Slipstream

struct SoftwareApplicationSchema: View {
  var body: some View {
    let jsonLD = """
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Sidecar",
      "operatingSystem": "iOS",
      "applicationCategory": "NavigationApplication"
    }
    """
    RawHTML("<script type=\"application/ld+json\">\(jsonLD)</script>")
  }
}
