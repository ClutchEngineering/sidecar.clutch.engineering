import Foundation

import Slipstream

/// A standalone page shell for cheat sheets.
///
/// Cheat sheets deliberately skip the site navigation chrome so the whole
/// reference fits on screen; a 30px bar is all that links back to Pelican.
struct CheatSheetPage<Lede: View, Content: View, Rail: View>: View {
  init(
    _ title: String,
    path: String,
    description: String,
    keywords: Set<String>,
    topBarNote: String? = nil,
    scripts: [URL?] = [],
    @ViewBuilder lede: @escaping @Sendable () -> Lede,
    @ViewBuilder rail: @escaping @Sendable () -> Rail,
    @ViewBuilder content: @escaping @Sendable () -> Content
  ) {
    self.title = title
    self.path = path
    self.description = description
    self.keywords = keywords
    self.topBarNote = topBarNote
    self.scripts = scripts
    self.lede = lede
    self.rail = rail
    self.content = content
  }

  let title: String
  let path: String
  let description: String
  let keywords: Set<String>
  let topBarNote: String?
  let scripts: [URL?]

  /// Runs the full width above the two columns, so the rail below it only
  /// starts tracking the scroll once the reader is past the opening.
  @ViewBuilder
  let lede: @Sendable () -> Lede

  /// Sits in the left column and follows the reader down the page.
  @ViewBuilder
  let rail: @Sendable () -> Rail

  @ViewBuilder
  let content: @Sendable () -> Content

  var body: some View {
    HTML {
      Head {
        let fullTitle = "\(title) - Pelican"
        let rootURL = URL(string: "https://pelican.clutch.engineering/")!
        let canonicalURL = URL(string: path, relativeTo: rootURL)
        Title(fullTitle)
        Charset(.utf8)
        Icon(URL(string: "/favicon.png"))
        Canonical(canonicalURL)
        Viewport(width: .deviceWidth, height: .deviceHeight, initialScale: 1.0)
        Meta("description", content: description)
        Meta("keywords", content: keywords.sorted().joined(separator: ", "))
        Meta("color-scheme", content: "light dark")

        Meta("og:title", content: fullTitle)
        Meta("og:description", content: description)
        Meta("og:type", content: "article")
        if let canonicalURL {
          Meta("og:url", content: canonicalURL.absoluteString)
        }
        Meta("og:image", content: URL(string: "/gfx/appicon.png", relativeTo: rootURL)!.absoluteString)
        Meta("twitter:card", content: "summary")
        Meta("twitter:title", content: fullTitle)
        Meta("twitter:description", content: description)

        Stylesheet(URL(string: "/css/cheatsheet.css"))
        for script in scripts.compactMap({ $0 }) {
          Script(script, executionMode: .defer)
        }

        SiteAnalytics()
      }
      Body {
        Div {
          Link(URL(string: "/")) {
            Image(URL(string: "/gfx/site-logo.png"))
              .accessibilityLabel("Pelican logo")
            Span {
              RawHTML("<b>Pelican</b> runs on its own GitLab CI stack, saving about <b>$70,000 a year</b> in equivalent hosted minutes. Shared with \u{2764}\u{FE0F} \u{1F3CE}\u{FE0F}\u{1F4A8}")
            }
            Span { DOMString("›") }
              .className("cs-topbar-arrow")
          }
          Div {}.className("cs-topbar-spacer")
          Link(URL(string: "https://www.threads.net/@featherless"), openInNewTab: true) {
            DOMString("Found a bug? Poke @featherless")
          }
          .className("cs-topbar-social")
          if let topBarNote {
            Span { DOMString(topBarNote) }
              .className("cs-topbar-meta")
          }
        }
        .className("cs-topbar")

        Div {
          Div {
            lede()
          }
          .className("cs-lede")

          Aside {
            rail()
          }
          .className("cs-rail")

          DocumentMain {
            content()
          }
          .className("cs-main")
        }
        .className("cs-wrap")
      }
      .className("cs")
    }
    .language("en")
  }
}

// MARK: - Structure

struct CheatSheetSection<Content: View>: View {
  let number: Int
  let title: String
  let summary: String
  let accentClass: String
  let anchor: String
  /// Shown instead of the tiles when the page is in agent mode.
  let agentPrompt: String
  /// Extra inputs rendered above the prompt, feeding its placeholders.
  let agentFields: String

  @ViewBuilder
  let content: @Sendable () -> Content

  init(
    number: Int,
    title: String,
    summary: String,
    accentClass: String,
    anchor: String,
    agentPrompt: String = "",
    agentFields: String = "",
    @ViewBuilder content: @escaping @Sendable () -> Content
  ) {
    self.number = number
    self.title = title
    self.summary = summary
    self.accentClass = accentClass
    self.anchor = anchor
    self.agentPrompt = agentPrompt
    self.agentFields = agentFields
    self.content = content
  }

  var body: some View {
    Section {
      Div {
        Span { DOMString(String(number)) }
          .className("cs-step")
        H2 { DOMString(title) }
        Text { DOMString(summary) }
      }
      .className("cs-section-head")

      Div {
        content()
      }
      .className("cs-grid cs-human")

      if !agentPrompt.isEmpty {
        Div {
          AgentPrompt(title: title, prompt: agentPrompt, fields: agentFields)
        }
        .className("cs-agent")
      }
    }
    .id(anchor)
    .className("cs-section \(accentClass)")
  }
}

/// A self-contained prompt, with enough context that an agent can act on it.
struct AgentPrompt: View {
  let title: String
  let prompt: String
  let fields: String

  var body: some View {
    let escaped = htmlEscape(prompt)
    let attribute = htmlAttributeEscape(prompt)
    RawHTML("""
<div class="cs-tile cs-prompt">
  <div class="cs-prompt-head">
    <h3>Prompt: \(title)</h3>
    <button type="button" class="cs-copy cs-copy-block" data-copy="\(attribute)" aria-label="Copy this prompt">Copy</button>
  </div>
  <p class="cs-sub">Fill in anything in angle brackets, then hand it to your agent.</p>
  \(fields)
  <pre class="cs-code cs-prompt-body">\(escaped)</pre>
</div>
""")
  }
}

/// A single card in the cheat sheet grid.
struct Tile<Content: View>: View {
  let title: String
  let subtitle: String?
  let width: Width
  /// An extra class, set when CSS or JavaScript needs to find this tile.
  let identifier: String?

  enum Width {
    case single
    case medium
    case wide
    case full

    var cssClass: String? {
      switch self {
      case .single: return nil
      case .medium: return "cs-tile-medium"
      case .wide: return "cs-tile-wide"
      case .full: return "cs-tile-full"
      }
    }
  }

  @ViewBuilder
  let content: @Sendable () -> Content

  init(
    _ title: String,
    subtitle: String? = nil,
    width: Width = .single,
    identifier: String? = nil,
    @ViewBuilder content: @escaping @Sendable () -> Content
  ) {
    self.title = title
    self.subtitle = subtitle
    self.width = width
    self.identifier = identifier
    self.content = content
  }

  var body: some View {
    Div {
      H3 { DOMString(title) }
      if let subtitle {
        Text { DOMString(subtitle) }
          .className("cs-sub")
      }
      content()
    }
    .className(["cs-tile", width.cssClass, identifier].compactMap { $0 }.joined(separator: " "))
  }
}

// MARK: - Escaping

func htmlEscape(_ text: String) -> String {
  text
    .replacingOccurrences(of: "&", with: "&amp;")
    .replacingOccurrences(of: "<", with: "&lt;")
    .replacingOccurrences(of: ">", with: "&gt;")
}

func htmlAttributeEscape(_ text: String) -> String {
  htmlEscape(text)
    .replacingOccurrences(of: "\"", with: "&quot;")
    .replacingOccurrences(of: "\n", with: "&#10;")
}

// MARK: - Content primitives

/// A shell transcript. Lines beginning with `#` render as comments, and every
/// runnable command gets a copy button.
///
/// Commands continued with a trailing backslash are treated as one command, so
/// copying gives you something that actually runs.
struct CodeBlock: View {
  let source: String
  /// Reference listings are for reading, not for pasting.
  let showsCopy: Bool

  init(_ source: String, showsCopy: Bool = true) {
    self.source = source
    self.showsCopy = showsCopy
  }



  private static func isComment(_ line: String) -> Bool {
    line.trimmingCharacters(in: .whitespaces).hasPrefix("#")
  }

  private static func isBlank(_ line: String) -> Bool {
    line.trimmingCharacters(in: .whitespaces).isEmpty
  }

  var body: some View {
    var rows: [String] = []
    var pending: [String] = []
    var joinWithNewlines = false

    func flush() {
      guard !pending.isEmpty else { return }
      let display = pending.map(htmlEscape).joined(separator: "\n")
      let command: String
      if joinWithNewlines {
        command = pending.joined(separator: "\n")
      } else {
        command = pending
          .map { $0.hasSuffix("\\") ? String($0.dropLast()).trimmingCharacters(in: .whitespaces) : $0.trimmingCharacters(in: .whitespaces) }
          .joined(separator: " ")
      }
      let copy = showsCopy
        ? "<button type=\"button\" class=\"cs-copy\" data-copy=\"\(htmlAttributeEscape(command))\" aria-label=\"Copy this command\">Copy</button>"
        : ""
      rows.append("<span class=\"cs-line\"><span class=\"cs-line-text\">\(display)</span>\(copy)</span>")
      pending = []
      joinWithNewlines = false
    }

    // A statement continues while it ends in a backslash, sits inside an open
    // quote, or has an unclosed brace or bracket. That keeps a curl with a JSON
    // body, and a multi-line Ruby hash in gitlab.rb, each copyable as one unit.
    var openQuote = false
    var depth = 0
    for line in source.components(separatedBy: "\n") {
      let inGroup = openQuote || depth > 0
      if !inGroup, Self.isComment(line) || Self.isBlank(line) {
        flush()
        rows.append(Self.isBlank(line)
          ? "<span class=\"cs-gap\"></span>"
          : "<span class=\"cs-line cs-line-comment\"><span class=\"cs-line-text c\">\(htmlEscape(line))</span></span>")
        continue
      }

      pending.append(line)
      if line.filter({ $0 == "'" }).count % 2 == 1 {
        openQuote.toggle()
      }
      if !openQuote {
        let opens = line.filter { $0 == "{" || $0 == "[" }.count
        let closes = line.filter { $0 == "}" || $0 == "]" }.count
        depth = max(0, depth + opens - closes)
      }
      if openQuote || depth > 0 {
        joinWithNewlines = true
        continue
      }
      if !line.hasSuffix("\\") {
        flush()
      }
    }
    flush()

    return RawHTML("<pre class=\"cs-code\">\(rows.joined())</pre>")
  }
}

/// Two files side by side, so the same pipeline can be read in both dialects.
struct CodeComparison: View {
  let leftTitle: String
  let left: String
  let rightTitle: String
  let right: String

  var body: some View {
    Div {
      Div {
        Div { DOMString(leftTitle) }
          .className("cs-compare-file")
        CodeBlock(left, showsCopy: false)
      }
      Div {
        Div { DOMString(rightTitle) }
          .className("cs-compare-file")
        CodeBlock(right, showsCopy: false)
      }
    }
    .className("cs-side-by-side")
  }
}

/// An unordered list of short facts.
struct Bullets: View {
  let items: [String]

  init(_ items: [String]) {
    self.items = items
  }

  var body: some View {
    List {
      for item in items {
        ListItem { RawHTML(item) }
      }
    }
  }
}

/// A list you can actually tick off, remembered between visits.
struct Checklist: View {
  let id: String
  let items: [String]

  init(id: String, _ items: [String]) {
    self.id = id
    self.items = items
  }

  var body: some View {
    let rows = items.enumerated().map { index, item in
      """
  <li><label><input type="checkbox" data-key="\(id)-\(index)"><span>\(item)</span></label></li>
"""
    }.joined(separator: "\n")
    RawHTML("""
<ul class="cs-checklist" data-checklist="\(id)">
\(rows)
</ul>
<div class="cs-checklist-foot">
  <span id="\(id)-status"></span>
  <button type="button" class="cs-checklist-reset" data-reset="\(id)">Reset</button>
</div>
""")
  }
}

/// A two-or-three column reference table.
struct RefTable: View {
  let headers: [String]
  let rows: [[String]]
  /// Column indices that should right-align as numbers.
  let numericColumns: Set<Int>

  init(headers: [String], rows: [[String]], numericColumns: Set<Int> = []) {
    self.headers = headers
    self.rows = rows
    self.numericColumns = numericColumns
  }

  var body: some View {
    Div {
      Table {
        TableHeader {
          TableRow {
            for (index, header) in headers.enumerated() {
              RefTableHeaderCell(text: header, isNumeric: numericColumns.contains(index))
            }
          }
        }
        TableBody {
          for row in rows {
            RefTableRow(cells: row, numericColumns: numericColumns)
          }
        }
      }
      .className("cs-table")
    }
    .className("cs-scroll")
  }
}

private struct RefTableHeaderCell: View {
  let text: String
  let isNumeric: Bool

  var body: some View {
    if isNumeric {
      TableHeaderCell { DOMString(text) }
        .className("num")
    } else {
      TableHeaderCell { DOMString(text) }
    }
  }
}

private struct RefTableRow: View {
  let cells: [String]
  let numericColumns: Set<Int>

  var body: some View {
    TableRow {
      for (index, cell) in cells.enumerated() {
        RefTableCell(html: cell, isNumeric: numericColumns.contains(index))
      }
    }
  }
}

private struct RefTableCell: View {
  let html: String
  let isNumeric: Bool

  var body: some View {
    if isNumeric {
      TableCell { RawHTML(html) }
        .className("num")
    } else {
      TableCell { RawHTML(html) }
    }
  }
}

struct Note: View {
  let text: String

  init(_ text: String) {
    self.text = text
  }

  var body: some View {
    Text { RawHTML(text) }
      .className("cs-note")
  }
}

