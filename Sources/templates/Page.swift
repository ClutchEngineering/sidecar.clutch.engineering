import Foundation

import Slipstream

struct Page<Content: View>: View {
  init(
    _ title: String,
    path: String,
    description: String,
    keywords: Set<String>,
    additionalStylesheets: Set<URL?> = Set(),
    socialBannerPath: String? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.path = path
    self.description = description
    self.keywords = keywords
    self.additionalStylesheets = additionalStylesheets
    self.socialBannerPath = socialBannerPath
    self.content = content
  }

  let title: String
  let path: String
  let description: String
  let keywords: Set<String>
  let additionalStylesheets: Set<URL?>
  let socialBannerPath: String?
  @ViewBuilder
  let content: () -> Content

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

        Script("""
!function(t,e){var o,n,p,r;e.__SV||(window.posthog=e,e._i=[],e.init=function(i,s,a){function g(t,e){var o=e.split(".");2==o.length&&(t=t[o[0]],e=o[1]),t[e]=function(){t.push([e].concat(Array.prototype.slice.call(arguments,0)))}}(p=t.createElement("script")).type="text/javascript",p.async=!0,p.src=s.api_host.replace(".i.posthog.com","-assets.i.posthog.com")+"/static/array.js",(r=t.getElementsByTagName("script")[0]).parentNode.insertBefore(p,r);var u=e;for(void 0!==a?u=e[a]=[]:a="posthog",u.people=u.people||[],u.toString=function(t){var e="posthog";return"posthog"!==a&&(e+="."+a),t||(e+=" (stub)"),e},u.people.toString=function(){return u.toString(1)+".people (stub)"},o="init capture register register_once register_for_session unregister unregister_for_session getFeatureFlag getFeatureFlagPayload isFeatureEnabled reloadFeatureFlags updateEarlyAccessFeatureEnrollment getEarlyAccessFeatures on onFeatureFlags onSessionId getSurveys getActiveMatchingSurveys renderSurvey canRenderSurvey getNextSurveyStep identify setPersonProperties group resetGroups setPersonPropertiesForFlags resetPersonPropertiesForFlags setGroupPropertiesForFlags resetGroupPropertiesForFlags reset get_distinct_id getGroups get_session_id get_session_replay_url alias set_config startSessionRecording stopSessionRecording sessionRecordingStarted captureException loadToolbar get_property getSessionProperty createPersonProfile opt_in_capturing opt_out_capturing has_opted_in_capturing has_opted_out_capturing clear_opt_in_out_capturing debug".split(" "),n=0;n<o.length;n++)g(u,o[n]);e._i.push([i,s,a])},e.__SV=1)}(document,window.posthog||[]);
posthog.init('phc_eDtYLUe7s9m2FdF3d1hsw8XXnG57yJNU4rLvbT0IXNV',{api_host:'https://eu.i.posthog.com', person_profiles: 'identified_only'
    })
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
