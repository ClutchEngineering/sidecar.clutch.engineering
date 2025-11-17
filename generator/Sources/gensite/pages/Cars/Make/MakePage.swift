import Foundation
import Slipstream
import VehicleSupportMatrix
import Markdown

struct MakeHeroIconPuck: View {
  let make: String
  var body: some View {
    Puck {
      Div {
        Image(URL(string: "/gfx/make/\(makeNameForIcon(make)).svg"))
          .frame(width: 104, height: 104)
          .padding(8)
          .colorInvert(condition: .dark)
      }
      .background(.white)
      .background("sidecar-gray", condition: .dark)
      .margin(.horizontal, .auto)
      .margin(.top, 8)
      .margin(.bottom, 24)
      .cornerRadius(.extraExtraExtraLarge)
    }
    .border(.init(.zinc, darkness: 700), width: 4)
    .border(.white, condition: .dark)
  }
}

struct MakePage: View {
  let supportMatrix: MergedSupportMatrix
  let make: String
  let projectRoot: URL

  /// Helper function to read markdown content from articles directory
  private func readMarkdownFile(relativePath: String) -> String? {
    let articlesPath = projectRoot.appending(path: "articles").appending(path: relativePath)
    guard FileManager.default.fileExists(atPath: articlesPath.path()) else {
      return nil
    }
    return try? String(contentsOf: articlesPath, encoding: .utf8)
  }

  /// Get the markdown content for the make's about section
  private var makeAboutMarkdown: String? {
    let makeForPath = makeNameForSorting(make)
    return readMarkdownFile(relativePath: "\(makeForPath)/about.md")
  }

  var body: some View {
    Page(
      "\(make) OBD support",
      path: "/cars/\(make.lowercased())/",
      description: "Check which Sidecar features work with your \(make).",
      keywords: [
        make,
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ],
      scripts: [URL(string: "/scripts/vehicle-search.js")]
    ) {
      // Search bar - always visible, sticky at top
      Section {
        ContentContainer {
          VehicleSearchBar()
        }
        .padding(.vertical, 16)
        .position(.sticky)
        .classNames(["top-0", "z-40"])
      }

      ContentContainer {
        VStack(alignment: .center) {
          HStack(spacing: 32) {
            Link(URL(string: "/cars/")) {
              HeroIconPuck(url: URL(string: "/gfx/supported-vehicle.png")!)
            }
            .pointerStyle(.pointer)
            MakeHeroIconPuck(make: make)
          }

          Div {
            H1(make + " OBD Support")
              .fontSize(.extraLarge)
              .fontSize(.fourXLarge, condition: .desktop)
              .bold()
              .fontDesign("rounded")
            Slipstream.Text("Check which Sidecar features work with your \(make)")
          }
          .textAlignment(.center)
        }
        .padding(.vertical, 16)
      }

      Section {
        ContentContainer {
          VStack(alignment: .center, spacing: 8) {
            Link(becomeBetaURL) {
              VStack(alignment: .center, spacing: 4) {
                H1("Don't see your car?")
                  .fontSize(.large)
                  .fontSize(.extraLarge, condition: .desktop)
                  .bold()
                  .fontDesign("rounded")
                Slipstream.Text("Become a Sidecar beta tester, get \(betaSubscriptionLength) months free")
                  .fontSize(.small)
                  .fontSize(.base, condition: .desktop)
                  .fontWeight(.medium)
                  .fontDesign("rounded")
                Slipstream.Text("Learn more")
                  .fontWeight(.bold)
                  .fontDesign("rounded")
                  .fontSize(.large)
                  .underline(condition: .hover)
              }
              .textAlignment(.center)
              .classNames(["bg-gradient-to-tl", "from-cyan-500", "to-blue-600"])
              .transition(.all)
              .textColor(.white)
              .padding(.horizontal, 16)
              .padding(.vertical, 12)
              .background(.zinc, darkness: 100)
              .background(.zinc, darkness: 900, condition: .dark)
              .cornerRadius(.extraExtraLarge)
            }
          }
          .frame(width: 0.8)
          .frame(width: 0.6, condition: .desktop)
          .margin(.horizontal, .auto)
          .margin(.bottom, 32)

          // Grid of model cards
          Div {
            for obdbID in supportMatrix.getOBDbIDs(for: make) {
              if let modelSupport = supportMatrix.getModel(id: obdbID) {
                ModelCard(make: make, modelSupport: modelSupport)
              }
            }
          }
          .display(.grid)
          .modifier(ClassModifier(add: "grid-cols-2"))
          .modifier(ClassModifier(add: "md:grid-cols-3"))
          .modifier(ClassModifier(add: "lg:grid-cols-4"))
          .modifier(ClassModifier(add: "gap-4"))
        }
      }
      .margin(.vertical, 32)

      // Make About Section - Only show if markdown file exists
      if let makeContent = makeAboutMarkdown {
        HorizontalRule()

        Section {
          ContentContainer {
            VStack(alignment: .leading, spacing: 16) {
              Article(makeContent)
            }
            .padding(.vertical, 16)
          }
        }
        .margin(.bottom, 32)
      }
    }
  }
}
