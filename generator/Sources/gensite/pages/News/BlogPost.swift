import Foundation

@preconcurrency import Markdown

struct BlogPostFrontmatter: Decodable {
  let thumbnail: String?
  let summary: String?
}

struct BlogPost: Sendable {
  // Locations
  let fileURL: URL
  let slug: String
  let outputURL: URL
  let url: URL

  // Metadata
  let date: Date
  let draft: Bool
  let thumbnail: URL?
  let summary: String?

  // Article structure
  let title: String?
  let tableOfContents: [Heading]
  let content: String
  let document: Document
}
