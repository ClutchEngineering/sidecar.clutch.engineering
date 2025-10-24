import Foundation

import Slipstream

struct Page<Content: View>: View {
  init(
    _ title: String,
    path: String,
    description: String,
    keywords: Set<String>,
    scripts: Set<URL?> = Set(),
    additionalStylesheets: Set<URL?> = Set(),
    socialBannerPath: String? = nil,
    @ViewBuilder content: @escaping @Sendable () -> Content
  ) {
    self.title = title
    self.path = path
    self.description = description
    self.keywords = keywords
    self.scripts = scripts
    self.additionalStylesheets = additionalStylesheets
    self.socialBannerPath = socialBannerPath
    self.content = content
  }

  let title: String
  let path: String
  let description: String
  let keywords: Set<String>
  let scripts: Set<URL?>
  let additionalStylesheets: Set<URL?>
  let socialBannerPath: String?
  @ViewBuilder
  let content: @Sendable () -> Content

  var body: some View {
    HTML {
      Head {
        let title = "\(title) - Sidecar"
        let rootURL = URL(string: "https://sidecar.clutch.engineering/")!
        let canonicalURL = URL(string: path, relativeTo: rootURL)
        Title(title)
        Charset(.utf8)
        Icon(URL(string: "/favicon.png"))
        Canonical(canonicalURL)
        Viewport(width: .deviceWidth, height: .deviceHeight, initialScale: 1.0)
        Meta("apple-itunes-app", content: "app-id=1663683832")
        Meta("description", content: description)
        Meta("keywords", content: keywords.sorted().joined(separator: ", "))

        Meta("og:title", content: title)
        Meta("og:description", content: description)
        if let socialBannerPath,
           let socialBannerURL = URL(string: socialBannerPath, relativeTo: rootURL) {
          Meta("og:image", content: socialBannerURL.absoluteString)
        }
        if let canonicalURL {
          Meta("og:url", content: canonicalURL.absoluteString)
        }
        Meta("og:type", content: "website")
        Meta("og:site_name", content: "Sidecar — Your personal automotive assistant")

        Meta("og:image", content: "/gfx/appicon.png")
        Stylesheet(URL(string: "/css/main.css"))
        for stylesheet in additionalStylesheets.compactMap({ $0 }).sorted(by: { $0.absoluteString < $1.absoluteString }) {
          Stylesheet(stylesheet)
        }
        for script in scripts.compactMap({ $0 }).sorted(by: { $0.absoluteString < $1.absoluteString }) {
          Script(script)
        }

        Script(URL(string: "https://www.googletagmanager.com/gtag/js?id=G-TDB4CTWESJ"), async: true)
        Script("""
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());

gtag('config', 'G-TDB4CTWESJ');
""")
      }
      Body {
        DocumentMain {
          NavigationBar()
          content()
        }
        .frame(minHeight: .dvh)
        NavigationFooter()
      }
      .background(.gray, darkness: 100)
      .background(.zinc, darkness: 950, condition: .dark)
      .textColor("sidecar-gray")
      .textColor(.white, condition: .dark)
      .antialiased()
    }
    .language("en")
    .environment(\.path, path)
  }
}

private struct PathEnvironmentKey: EnvironmentKey {
  static let defaultValue: String = "/"
}

extension EnvironmentValues {
  var path: String {
    get { self[PathEnvironmentKey.self] }
    set { self[PathEnvironmentKey.self] = newValue }
  }
}
