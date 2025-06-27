import Foundation

@preconcurrency import Markdown

struct Post: Sendable {
  let content: String
  let tableOfContents: [Heading]

  init(content: String) {
    self.content = content

    let document = Document(parsing: content)
    self.tableOfContents = document.children.compactMap { node in
      return node as? Markdown.Heading
    }
  }
}
