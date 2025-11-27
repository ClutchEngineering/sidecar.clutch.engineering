import Foundation
import ArgumentParser

import AirtableAPI
import DotEnvAPI
import Markdown
import VehicleSupportMatrix
import VehicleSupport
import Yams

import Slipstream

extension Condition {
  static var mobileOnly: Condition { Condition.within(Breakpoint.small..<Breakpoint.medium) }
  static var desktop: Condition { Condition.startingAt(.medium) }
}

private struct AtomEntry {
  let title: String?
  let url: URL
  let date: Date
  let html: String

  static let site = "https://sidecar.clutch.engineering"

  var toString: String {
    let dateFormatter = ISO8601DateFormatter()
    return """
<entry>
  <title>\(title ?? "No title")</title>
  <link rel="alternate" type="text/html" href="\(Self.site)\(url.path())"/>
  <id>\(Self.site)\(url.path())</id>
  <published>\(dateFormatter.string(from: date))</published>
  <updated>\(dateFormatter.string(from: date))</updated>
  <content type="html"><![CDATA[\(html)]]></content>
</entry>
"""
  }
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

  @ArgumentParser.Option(name: .long, help: "Filter supported cars by make (e.g., volkswagen)")
  var make: String?

  @ArgumentParser.Option(name: .long, help: "Filter supported cars by model (e.g., id.4)")
  var model: String?

  @ArgumentParser.Flag(name: .long, help: "Only generate leaderboard pages")
  var leaderboard = false

#if os(macOS)
  @ArgumentParser.Flag(name: .long, help: "Watch for file changes and regenerate")
  var watch = false
#endif

  mutating func run() async throws {
    // Assumes this file is located in a Sources/gensite sub-directory of a Swift package.
    let projectRoot = URL(filePath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()

    guard let blogURLPrefix = URL(string: "/news/") else {
      throw ExitCode.failure
    }

    let postsURL = projectRoot.appending(path: "posts")
    let outputURL = projectRoot.appending(path: "site")

    // Load environment variables from .env file if it exists
    DotEnv.load(from: projectRoot.appending(path: ".env").path())

    guard let airtableAPIKey = ProcessInfo.processInfo.environment["AIRTABLE_API_KEY"] else {
      FileHandle.standardError.write("Error: Missing required environment variable AIRTABLE_API_KEY\n".data(using: .utf8)!)
      throw ExitCode.failure
    }

    guard let airtableBaseID = ProcessInfo.processInfo.environment["AIRTABLE_BASE_ID"] else {
      FileHandle.standardError.write("Error: Missing required environment variable AIRTABLE_BASE_ID\n".data(using: .utf8)!)
      throw ExitCode.failure
    }

    guard let modelsTableID = ProcessInfo.processInfo.environment["AIRTABLE_MODELS_TABLE_ID"] else {
      FileHandle.standardError.write("Error: Missing required environment variable AIRTABLE_MODELS_TABLE_ID\n".data(using: .utf8)!)
      throw ExitCode.failure
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

      // Parse YAML frontmatter if present
      var contentWithoutFrontmatter = postContent
      var frontmatter: BlogPostFrontmatter?
      if postContent.hasPrefix("---") {
        let lines = postContent.components(separatedBy: "\n")
        if let endIndex = lines.dropFirst().firstIndex(where: { $0 == "---" }) {
          let yamlLines = lines[1..<endIndex]
          let yamlString = yamlLines.joined(separator: "\n")
          frontmatter = try? YAMLDecoder().decode(BlogPostFrontmatter.self, from: yamlString)
          contentWithoutFrontmatter = lines[(endIndex + 1)...].joined(separator: "\n")
        }
      }

      let document = Document(parsing: contentWithoutFrontmatter)

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

      let thumbnailURL: URL?
      if let thumbnailPath = frontmatter?.thumbnail {
        thumbnailURL = URL(string: thumbnailPath)
      } else {
        thumbnailURL = nil
      }

      return BlogPost(
        fileURL: file,
        slug: slug,
        outputURL: postOutputURL,
        url: postOutputURL.deletingLastPathComponent(),
        date: date,
        draft: file.deletingLastPathComponent().lastPathComponent == "Drafts",
        thumbnail: thumbnailURL,
        summary: frontmatter?.summary,
        title: documentHeading,
        tableOfContents: tableOfContents,
        content: contentWithoutFrontmatter,
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

      // Generate Atom feed
      func generateAtomFeed(from posts: [BlogPost], to outputURL: URL) throws {
        let site = AtomEntry.site
        let dateFormatter = ISO8601DateFormatter()

        // Filter out drafts and sort by date (newest first)
        let publishedPosts = posts
          .filter { !$0.draft }
          .sorted { $0.date > $1.date }

        let entries = try publishedPosts.map { post in
          AtomEntry(
            title: post.title,
            url: post.url,
            date: post.date,
            html: try renderHTML(Article(post.document))
          )
        }

        let atomFeed = """
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Sidecar News</title>
  <link href="\(site)/feed.atom" rel="self" type="application/atom+xml"/>
  <link href="\(site)/news/" rel="alternate" type="text/html"/>
  <id>\(site)/</id>
  <updated>\(dateFormatter.string(from: .now))</updated>
  <author>
    <name>Sidecar</name>
  </author>
\(entries.map(\.toString).joined(separator: "\n"))
</feed>
"""

        let feedURL = outputURL.appending(path: "feed.atom")
        try atomFeed.write(to: feedURL, atomically: true, encoding: .utf8)
        print("Generated feed.atom")
      }

      try generateAtomFeed(from: posts, to: outputURL)
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

      print("Calling MergedSupportMatrix.load()...")
      let supportMatrix = try await MergedSupportMatrix.load(
        using: airtableClient,
        projectRoot: projectRoot,
        modelsTableID: modelsTableID,
        workspacePath: finalWorkspacePath,
        useCache: useCache
      )
      print("MergedSupportMatrix.load() returned successfully")
      print("Getting all makes...")
      let makes = supportMatrix.getAllMakes()
      print("Support matrix loaded, contains \(makes.count) makes")

      // Load CarPlay support database
      print("Loading CarPlay support database...")
      let carPlayDB: CarPlaySupportDatabase?
      do {
        carPlayDB = try CarPlaySupportDatabase(
          jsonURL: projectRoot.appending(path: "data/carplay_support.json")
        )
        let manufacturerCount = carPlayDB?.manufacturers.count ?? 0
        print("CarPlay database loaded with \(manufacturerCount) manufacturers")
      } catch {
        print("Warning: Failed to load CarPlay database: \(error)")
        carPlayDB = nil
      }

      if buildAll || supportedCars {
        print("Generating supported cars pages...")

        // Filter makes if --make option is specified
        let allMakes = supportMatrix.getAllMakes()
        let makesToGenerate: [String]
        if let makeFilter = make {
          let filteredMakes = allMakes.filter { $0.lowercased() == makeFilter.lowercased() }
          if filteredMakes.isEmpty {
            FileHandle.standardError.write("Warning: No makes found matching '\(makeFilter)'\n".data(using: .utf8)!)
            FileHandle.standardError.write("Available makes: \(allMakes.joined(separator: ", "))\n".data(using: .utf8)!)
          }
          makesToGenerate = filteredMakes
        } else {
          makesToGenerate = allMakes
        }

        // Generate vehicle search index (only when not filtering)
        if make == nil,
           model == nil {
          try VehicleSearchIndex.generate(supportMatrix: supportMatrix, outputURL: outputURL)
        }

        // Only generate the make grid page if not filtering by make or model
        if make == nil,
           model == nil {
          sitemap["cars/index.html"] = MakeGridPage(supportMatrix: supportMatrix, outputURL: outputURL)
          // Redirect old URL to new URL
          sitemap["supported-cars/index.html"] = Redirect(URL(string: "/cars"))
        }

        for make in makesToGenerate {
          guard let url = MakeLink.url(for: make) else {
            continue
          }

          // Only generate the make page if not filtering by model
          if model == nil {
            sitemap[url.appending(component: "index.html").path()] = MakePage(supportMatrix: supportMatrix, make: make, projectRoot: projectRoot)
            // Redirect old make URL to new URL
            let oldMakeURL = URL(string: "/supported-cars/\(makeNameForSorting(make))")
            if let oldMakeURL {
              sitemap[oldMakeURL.appending(component: "index.html").path()] = Redirect(url)
            }
          }

          // Generate individual model pages
          for obdbID in supportMatrix.getOBDbIDs(for: make) {
            guard let modelSupport = supportMatrix.getModel(id: obdbID),
                  let modelURL = ModelLink.url(for: make, model: modelSupport.model) else {
              continue
            }

            // Filter by model if specified
            if let modelFilter = model {
              let modelName = modelSupport.model.lowercased()
              if !modelName.contains(modelFilter.lowercased()) {
                continue
              }
            }

            sitemap[modelURL.appending(component: "index.html").path()] = ModelPage(
              supportMatrix: supportMatrix,
              make: make,
              obdbID: obdbID,
              projectRoot: projectRoot,
              carPlayDB: carPlayDB
            )
            // Redirect old model URL to new URL
            let oldModelURL = URL(string: "/supported-cars/\(makeNameForSorting(make))/\(modelNameForURL(modelSupport.model))")
            if let oldModelURL {
              sitemap[oldModelURL.appending(component: "index.html").path()] = Redirect(modelURL)
            }
          }
        }
      }

      if buildAll || leaderboard {
        print("Generating leaderboard pages...")
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
        let cleanPath = path.replacingOccurrences(of: "index.html", with: "")
        var absoluteURL = baseURL
        if !absoluteURL.hasSuffix("/"),
           !cleanPath.hasPrefix("/") {
          absoluteURL.append("/")
        }
        absoluteURL.append(cleanPath)

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

#if os(macOS)
    // Watch mode: monitor for file changes and regenerate
    if watch {
      print("\nWatching for changes...")

      // Determine which directories to watch based on flags
      var watchPaths: [URL] = []
      if blog || buildAll {
        watchPaths.append(postsURL)
      }
      if staticPages || buildAll {
        watchPaths.append(projectRoot.appending(path: "generator/Sources/gensite"))
      }

      guard !watchPaths.isEmpty else {
        print("No paths to watch. Use --blog, --static-pages, or no filter flags.")
        return
      }

      let fileDescriptors = watchPaths.compactMap { url -> Int32? in
        let fd = open(url.path(percentEncoded: false), O_EVTONLY)
        if fd == -1 {
          print("Warning: Could not watch \(url.path())")
          return nil
        }
        return fd
      }

      guard !fileDescriptors.isEmpty else {
        print("Error: Could not watch any directories")
        return
      }

      // Use a simple polling approach for recursive directory watching
      var lastModificationDates: [String: Date] = [:]

      func getModificationDates(in directory: URL) -> [String: Date] {
        var dates: [String: Date] = [:]
        guard let enumerator = FileManager.default.enumerator(
          at: directory,
          includingPropertiesForKeys: [.contentModificationDateKey],
          options: [.skipsHiddenFiles]
        ) else {
          return dates
        }
        for case let fileURL as URL in enumerator {
          if let values = try? fileURL.resourceValues(forKeys: [.contentModificationDateKey]),
             let modDate = values.contentModificationDate {
            dates[fileURL.path()] = modDate
          }
        }
        return dates
      }

      // Initialize with current state
      for watchPath in watchPaths {
        lastModificationDates.merge(getModificationDates(in: watchPath)) { _, new in new }
      }

      print("Watching \(watchPaths.map { $0.lastPathComponent }.joined(separator: ", ")) for changes. Press Ctrl+C to stop.")

      // Poll for changes
      while true {
        try? await Task.sleep(for: .seconds(1))

        var currentDates: [String: Date] = [:]
        for watchPath in watchPaths {
          currentDates.merge(getModificationDates(in: watchPath)) { _, new in new }
        }

        // Check for changes
        var hasChanges = false
        var changedFiles: [String] = []

        for (path, date) in currentDates {
          if let lastDate = lastModificationDates[path] {
            if date > lastDate {
              hasChanges = true
              changedFiles.append(URL(filePath: path).lastPathComponent)
            }
          } else {
            // New file
            hasChanges = true
            changedFiles.append(URL(filePath: path).lastPathComponent)
          }
        }

        // Check for deleted files
        for path in lastModificationDates.keys where currentDates[path] == nil {
          hasChanges = true
          changedFiles.append("\(URL(filePath: path).lastPathComponent) (deleted)")
        }

        if hasChanges {
          print("\n[\(Date().formatted(date: .omitted, time: .standard))] Changes detected: \(changedFiles.joined(separator: ", "))")
          print("Regenerating...")

          lastModificationDates = currentDates

          // Re-run the generation (simplified - just regenerate what was requested)
          do {
            // For blog mode, regenerate blog pages
            if blog || buildAll {
              var blogSitemap: Sitemap = [:]
              let posts = try allBlogFiles(in: postsURL).compactMap { try postURL(filePath: $0) }
              for (index, post) in posts.enumerated() {
                let previous = index > 0 ? posts[index - 1] : nil
                let next = (index < posts.count - 1) ? posts[index + 1] : nil

                blogSitemap[post.outputURL.path()] = BlogPostView(
                  post: post,
                  next: next,
                  previous: previous
                )
              }

              blogSitemap["news/index.html"] = BlogList(posts: posts)
              try await renderSitemapWithLogs(blogSitemap, to: outputURL)
            }
            print("Done")
          } catch {
            print("Error during regeneration: \(error)")
          }
        }
      }
    }
#endif
  }
}
