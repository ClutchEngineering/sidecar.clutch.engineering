import Foundation

@preconcurrency import Markdown

struct BlogPost: Sendable {
  // Locations
  let fileURL: URL
  let slug: String
  let outputURL: URL
  let url: URL

  // Metadata
  let date: Date
  let draft: Bool

  // Article structure
  let title: String?
  let tableOfContents: [Heading]
  let content: String
  let document: Document
}
