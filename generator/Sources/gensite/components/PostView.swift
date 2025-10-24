import Foundation

@preconcurrency import Markdown
import Slipstream

struct TOCHyperlink: View {
  let url: URL?
  let text: String
  var body: some View {
    Slipstream.Link(url) {
      Slipstream.DOMString(text)
    }
    .textColor(.link, darkness: 700)
    .textColor(.link, darkness: 400, condition: .dark)
    .fontWeight(600)
    .fontSize(.small)
    .underline(condition: .hover)
  }
}

struct TOCListItem<Content: View>: View {
  let content: @Sendable () -> Content

  var body: some View {
    Slipstream.ListItem {
      content()
    }
    .listStyle(.disc)
  }
}

struct PostView: View {
  let post: Post

  init(_ content: String) {
    self.post = .init(content: content)
  }

  var body: some View {
    Div {
      let headings = post.tableOfContents.filter({ $0.level == 2 })
      if !headings.isEmpty {
        Div {
          Slipstream.Text("On this page")
            .bold()
          Slipstream.List {
            for heading in headings {
              TOCListItem {
                TOCHyperlink(url: URL(string: "#\(heading.headerID)"), text: heading.plainText)
              }
            }
          }
        }
        .className("toc-hide")
        .position(.absolute)
        .float(.right)
        .hidden()
        .display(.block, condition: .desktop)
        .padding(.horizontal, 16)
        .className("w-[calc((100vw-948px)/2)]")
        .position(.sticky)
        .placement(top: 16)
      }

      Container {
        Article(post.content)
      }
      .padding(.horizontal, 4)
      .padding(.bottom, 32)
    }
    .position(.relative)
  }
}
