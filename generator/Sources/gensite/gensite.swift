import Foundation
import ArgumentParser

import AirtableAPI
import DotEnvAPI
import Markdown
import VehicleSupportMatrix

import Slipstream

extension Condition {
  static var mobileOnly: Condition { Condition.within(Breakpoint.small..<Breakpoint.medium) }
  static var desktop: Condition { Condition.startingAt(.medium) }
}

@main
struct Gensite: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "gensite",
    abstract: "Generate the Sidecar website"
  )

  @ArgumentParser.Option(name: .long, help: "Path to workspace directory")
  var workspacePath: String?

  @ArgumentParser.Flag(name: .long, help: "Use cached data if available")
  var useCache = false

  @ArgumentParser.Flag(name: .long, help: "Only generate blog pages")
  var blog = false

  @ArgumentParser.Flag(name: .long, help: "Only generate static pages (home, privacy, shortcuts, etc.)")
  var staticPages = false

  @ArgumentParser.Flag(name: .long, help: "Only generate supported cars pages")
  var supportedCars = false

  @ArgumentParser.Flag(name: .long, help: "Only generate leaderboard pages")
  var leaderboard = false

  mutating func run() async throws {
    // Assumes this file is located in a Sources/gensite sub-directory of a Swift package.
    guard let projectRoot = URL(filePath: #filePath)?
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent() else {
      print("Unable to create URL for \(#filePath)")
      throw ExitCode.failure
    }

    guard let blogURLPrefix = URL(string: "/news/") else {
      throw ExitCode.failure
    }

    let postsURL = projectRoot.appending(path: "posts")
    let outputURL = projectRoot.appending(path: "site")

    // Load environment variables from .env file if it exists
    DotEnv.load(from: projectRoot.appending(path: ".env").path())

    guard let airtableAPIKey = ProcessInfo.processInfo.environment["AIRTABLE_API_KEY"] else {
      fatalError("Missing AIRTABLE_API_KEY")
    }

    guard let airtableBaseID = ProcessInfo.processInfo.environment["AIRTABLE_BASE_ID"] else {
      fatalError("Missing AIRTABLE_BASE_ID")
    }

    guard let modelsTableID = ProcessInfo.processInfo.environment["AIRTABLE_MODELS_TABLE_ID"] else {
      fatalError("Missing AIRTABLE_MODELS_TABLE_ID")
    }

    // Determine workspace path
    let finalWorkspacePath: String
    if let workspacePath {
      finalWorkspacePath = workspacePath
    } else {
      let workspaceURL = projectRoot.appendingPathComponent("workspace")
      finalWorkspacePath = workspaceURL.path
    }

    // Determine what to build
    let buildAll = !blog && !staticPages && !supportedCars && !leaderboard

    print("Generating sitemap...")

    var sitemap: Sitemap = [:]

    // Static pages
    if buildAll || staticPages {
      sitemap = [
        "index.html": Home(),
        "privacy-policy/index.html": PrivacyPolicy(
          appName: "Sidecar",
          introText: "Sidecar is delighted to be our users' choice for understanding the state of their garage.",
          publicationDate: "November 10, 2025"
        ),
        "privacy-policy/canstudio/index.html": PrivacyPolicy(
          appName: "CANStudio",
          introText: "CANStudio is a powerful CAN OBD workbench.",
          publicationDate: "November 10, 2025"
        ),
        "privacy-policy/elmcheck/index.html": PrivacyPolicy(
          appName: "ELMCheck",
          introText: "ELMCheck is the easiest way to check the authenticity of your OBD scanner.",
          publicationDate: "November 10, 2025"
        ),
        "privacy-policy/scout/index.html": PrivacyPolicy(
          appName: "Scout",
          introText: "Scout is the map we build together.",
          publicationDate: "November 10, 2025"
        ),
        "features/index.html": Features(),
        "shortcuts/index.html": Shortcuts(),
        "scanning/index.html": Scanning(),
        "scanning/extended-pids/index.html": ExtendedParameters(),
        "bug/index.html": Bug(),
        "beta/index.html": BetaTesterHandbook(),
        "beta/redeem/index.html": RedeemBetaCode(),
        "beta/leaderboard/index.html": Redirect(URL(string: "/leaderboard")),
        "leave-a-review/index.html": Redirect(URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1663683832&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")),
        "help/index.html": Help(),
        "lifetime-survey/index.html": LifetimeSurvey(),
      ]
    }

    func allBlogFiles(in directory: URL?) -> [URL] {
      guard let directory else {
        return []
      }
      var markdownFiles: [URL] = []
      guard let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil) else {
        return markdownFiles
      }
      for case let fileURL as URL in enumerator {
        if fileURL.pathExtension == "md" {
          markdownFiles.append(fileURL)
        }
      }
      return markdownFiles.sorted { $0.path() < $1.path() }
    }

    func postURL(filePath file: URL) throws -> BlogPost? {
      let datedSlug = file.deletingPathExtension().lastPathComponent
      var parts = datedSlug.components(separatedBy: "-")
      guard parts.count > 3 else {
        print("Malformed slug: ", file)
        return nil
      }
      guard let year = Int(parts[0]),
            let month = Int(parts[1]),
            let day = Int(parts[2]) else {
        print("Malformed slug date: ", file)
        return nil
      }
      let components = DateComponents(calendar: .current, year: year, month: month, day: day)
      guard let date = Calendar.current.date(from: components) else {
        print("Invalid date components: \(components)")
        return nil
      }

      parts.removeFirst(3)
      let slug = parts.joined(separator: "-")

      let postContent = try String(contentsOf: file, encoding: .utf8)
      let document = Document(parsing: postContent)

      let documentHeading = (document.children.first { node in
        if let heading = node as? Markdown.Heading,
           heading.level == 1 {
          return true
        }
        return false
      } as? Markdown.Heading)?.plainText

      let tableOfContents = document.children.compactMap { node in
        return node as? Markdown.Heading
      }

      let postOutputURL = blogURLPrefix
        .appending(components: String(format: "%04d", year), String(format: "%02d", month), String(format: "%02d", day))
        .appending(path: slug)
        .appending(path: "index")
        .appendingPathExtension("html")
      return BlogPost(
        fileURL: file,
        slug: slug,
        outputURL: postOutputURL,
        url: postOutputURL.deletingLastPathComponent(),
        date: date,
        draft: file.deletingLastPathComponent().lastPathComponent == "Drafts",
        title: documentHeading,
        tableOfContents: tableOfContents,
        content: postContent,
        document: document
      )
    }

    // Blog pages
    if buildAll || blog {
      let posts = try allBlogFiles(in: postsURL).compactMap { try postURL(filePath: $0) }
      for (index, post) in posts.enumerated() {
        let previous = index > 0 ? posts[index - 1] : nil
        let next = (index < posts.count - 1) ? posts[index + 1] : nil

        sitemap[post.outputURL.path()] = BlogPostView(
          post: post,
          next: next,
          previous: previous
        )
      }

      sitemap["news/index.html"] = BlogList(posts: posts)
    }

    // Supported cars and leaderboard pages (require Airtable data)
    if buildAll || supportedCars || leaderboard {
      // Create Airtable client
      let airtableClient = AirtableClient(baseID: airtableBaseID, apiKey: airtableAPIKey)

      // Load and merge vehicle data
      print("Loading vehicle metadata from: \(finalWorkspacePath)")
      if useCache {
        print("Using cached data if available")
      }

      let supportMatrix = try await MergedSupportMatrix.load(
        using: airtableClient,
        projectRoot: projectRoot,
        modelsTableID: modelsTableID,
        workspacePath: finalWorkspacePath,
        useCache: useCache
      )

      if buildAll || supportedCars {
        sitemap["supported-cars/index.html"] = MakeGridPage(supportMatrix: supportMatrix, outputURL: outputURL)

        for make in supportMatrix.getAllMakes() {
          guard let url = MakeLink.url(for: make) else {
            continue
          }
          sitemap[url.appending(component: "index.html").path()] = MakePage(supportMatrix: supportMatrix, make: make)
        }
      }

      if buildAll || leaderboard {
        sitemap.merge([
          "leaderboard/index.html": LeaderboardPage(supportMatrix: supportMatrix),
          "leaderboard/last24hours/index.html": Leaderboard24HoursPage(supportMatrix: supportMatrix),
          "leaderboard/makes/index.html": LeaderboardByMakePage(supportMatrix: supportMatrix),
        ],
        uniquingKeysWith: { first, second in first }
        )
      }
    }

    func renderSitemapWithLogs(_ sitemap: Sitemap, to folder: URL, encoding: String.Encoding = .utf8) async throws {
      try await withThrowingTaskGroup(of: Void.self) { group in
        for (path, view) in sitemap.sorted(by: { $0.key < $1.key }) {
          group.addTask {
            print("Rendering \(path)")

            let output = try "<!DOCTYPE html>\n" + renderHTML(view)
            let fileURL = folder.appending(path: path)
            let folderURL = fileURL.deletingLastPathComponent()
            if !FileManager.default.fileExists(atPath: folderURL.path(percentEncoded: false)) {
              try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            }
            try output.write(to: fileURL, atomically: true, encoding: encoding)
          }
        }

        try await group.waitForAll()
      }
    }

    try await renderSitemapWithLogs(sitemap, to: outputURL)

    // Generate and write sitemap.xml
    func generateSitemapXML(from sitemap: Sitemap, baseURL: String = "https://sidecar.clutch.engineering") throws {
      let dateFormatter = ISO8601DateFormatter()
      dateFormatter.formatOptions = [.withFullDate]

      // Function to escape XML special characters in URLs
      func escapeXMLSpecialCharacters(_ string: String) -> String {
        return string
          .replacingOccurrences(of: "&", with: "&amp;")
          .replacingOccurrences(of: "<", with: "&lt;")
          .replacingOccurrences(of: ">", with: "&gt;")
          .replacingOccurrences(of: "'", with: "&apos;")
          .replacingOccurrences(of: "\"", with: "&quot;")
      }

      var xmlContent = """
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

      """

      for path in sitemap.keys.sorted() {
        // Skip redirects as they shouldn't be in the sitemap
        if path.contains("leave-a-review") {
          continue
        }

        // Convert relative path to absolute URL
        var absoluteURL = baseURL + path.replacingOccurrences(of: "index.html", with: "")
        if !absoluteURL.hasSuffix("/"),
           !path.hasPrefix("/") {
          absoluteURL.append("/")
        }

        // Escape special characters for XML
        let escapedURL = escapeXMLSpecialCharacters(absoluteURL)

        xmlContent += """
        <url>
          <loc>\(escapedURL)</loc>
        </url>

        """
      }

      xmlContent += "</urlset>"

      let sitemapURL = outputURL.appending(path: "sitemap.xml")
      try xmlContent.write(to: sitemapURL, atomically: true, encoding: .utf8)
      print("Generated sitemap.xml")
    }

    try generateSitemapXML(from: sitemap)

    print("Done")
  }
}
