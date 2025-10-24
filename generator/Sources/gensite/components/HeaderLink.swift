import Foundation

import Slipstream

struct NavigationLink: View {
  @Environment(\.path) var path

  init(_ url: URL?, text: String, matchPaths: [String] = []) {
    self.url = url
    self.text = text
    self.matchPaths = matchPaths
  }

  private let url: URL?
  private let text: String
  private let matchPaths: [String]

  var body: some View {
    let link = Link(text, destination: url)
      .fontSize(.small, condition: .mobileOnly)
      .fontWeight(.medium)

    let isActive: Bool = {
      if let url,
         path.hasPrefix(url.absoluteString) {
        return true
      }
      return matchPaths.contains { path.hasPrefix($0) }
    }()

    if isActive {
      link
    } else {
      link
        .opacity(0.7)
        .opacity(1.0, condition: .hover)
    }
  }
}
