import Foundation

import Slipstream

struct NavigationLink: View {
  @Environment(\.path) var path

  init(_ url: URL?, text: String) {
    self.url = url
    self.text = text
  }

  private let url: URL?
  private let text: String

  var body: some View {
    let link = Link(text, destination: url)
      .fontSize(.small, condition: .mobileOnly)
      .fontWeight(.medium)
    if url?.absoluteString == path {
      link
    } else {
      link
        .opacity(0.7)
        .opacity(1.0, condition: .hover)
    }
  }
}
