import Foundation
import Slipstream
import VehicleSupportMatrix
import Markdown
import SupportMatrix

struct ModelHeroIconPuck: View {
  let modelSVGs: [String]

  var body: some View {
    Puck {
      Div {
        if !modelSVGs.isEmpty {
          Image(URL(string: "/gfx/vehicle/\(modelSVGs[0])"))
            .frame(width: 104, height: 104)
            .padding(8)
            .colorInvert(condition: .dark)
        } else {
          Image(URL(string: "/gfx/placeholder-car.png"))
            .colorInvert(condition: .dark)
            .display(.inlineBlock)
            .frame(width: 32)
            .frame(width: 64, condition: .desktop)
            .margin(14)
            .margin(.horizontal, 20, condition: .desktop)
            .margin(.vertical, 24, condition: .desktop)
        }
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

struct ModelPage: View {
  let supportMatrix: MergedSupportMatrix
  let make: String
  let obdbID: MergedSupportMatrix.OBDbID
  let projectRoot: URL

  var modelSupport: MergedSupportMatrix.ModelSupport? {
    supportMatrix.getModel(id: obdbID)
  }

  /// Helper function to read markdown content from articles directory
  private func readMarkdownFile(relativePath: String) -> String? {
    let articlesPath = projectRoot.appending(path: "articles").appending(path: relativePath)
    guard FileManager.default.fileExists(atPath: articlesPath.path()) else {
      return nil
    }
    return try? String(contentsOf: articlesPath, encoding: .utf8)
  }

  /// Get the markdown content for this model's about section
  private var modelAboutMarkdown: String? {
    let makeForPath = makeNameForSorting(make)
    guard let model = modelSupport else { return nil }
    let modelForPath = modelNameForURL(model.model)
    return readMarkdownFile(relativePath: "\(makeForPath)/\(modelForPath)/about.md")
  }

  /// Get the markdown content for the make's about section
  private var makeAboutMarkdown: String? {
    let makeForPath = makeNameForSorting(make)
    return readMarkdownFile(relativePath: "\(makeForPath)/about.md")
  }

  @ViewBuilder
  var body: some View {
    if let modelSupport = modelSupport {
      Page(
        "OBD pids for the \(make) \(modelSupport.model)",
        path: "/cars/\(makeNameForSorting(make))/\(modelNameForURL(modelSupport.model))/",
        description: "OBD pids for the \(make) \(modelSupport.model).",
        keywords: [
          make,
          modelSupport.model,
          "OBD-II",
          "OBD pids",
          "OBD pid database",
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
              Link(URL(string: "/cars/\(makeNameForSorting(make))/")) {
                MakeHeroIconPuck(make: make)
              }
              .pointerStyle(.pointer)
              ModelHeroIconPuck(modelSVGs: modelSupport.modelSVGs)
            }

            Div {
              H1("\(make) \(modelSupport.model)")
                .fontSize(.extraLarge)
                .fontSize(.fourXLarge, condition: .desktop)
                .bold()
                .fontDesign("rounded")
              Slipstream.Text("OBD pids for the \(make) \(modelSupport.model)")

              Link(URL(string: "https://github.com/OBDb/\(modelSupport.obdbID)")) {
                Text("OBDb")
                  .bold()
                  .fontDesign("rounded")
                  .textColor(.link, darkness: 700)
                  .textColor(.link, darkness: 400, condition: .dark)
                  .underline(condition: .hover)
              }
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }

        // Feature Support Table - Above the fold for better SEO
        Section {
          ContentContainer {
            ModelSupportSectionV2(
              make: make,
              modelSupport: modelSupport,
              obdbID: obdbID,
              supportMatrix: supportMatrix,
              becomeBetaURL: becomeBetaURL
            )
          }
        }
        .margin(.vertical, 32)

        // Legend
        Section {
          ContentContainer {
            VStack(alignment: .leading, spacing: 16) {
              H1("Legend")
                .fontSize(.extraLarge)
                .fontSize(.fourXLarge, condition: .desktop)
                .bold()
                .fontDesign("rounded")

              HStack(spacing: 16) {
                SupportedSeal()
                Slipstream.Text("Vehicle is fully onboarded and does not currently need new beta testers.")
              }
              HStack(spacing: 16) {
                OBDStamp()
                Slipstream.Text {
                  DOMString("Feature is supported via OBD. ")
                  Link("Requires a connected OBD-II scanner.", destination: URL(string: "/scanning/"))
                    .textColor(.link, darkness: 700)
                    .textColor(.link, darkness: 400, condition: .dark)
                    .fontWeight(600)
                    .underline(condition: .hover)
                }
              }
              HStack(spacing: 16) {
                OTAStamp()
                Slipstream.Text("Feature is supported via Connected Accounts (Beta).")
              }
              HStack(spacing: 16) {
                NotApplicableStamp()
                Slipstream.Text("Not applicable to this vehicle.")
              }
              HStack(spacing: 16) {
                Slipstream.Text {
                  Span("PID?")
                    .bold()
                  DOMString(" The OBD parameter identifier (PID) is unknown.")
                }
              }
            }
            .alignItems(.center, condition: .desktop)
            .textAlignment(.center, condition: .desktop)
            .padding(.vertical, 16)
          }
        }
        .margin(.bottom, 32)

        // General support
        Section {
          ContentContainer {
            VStack(alignment: .leading, spacing: 8) {
              HStack(spacing: 8) {
                Image(URL(string: "/gfx/symbols/checkmark.seal.png"))
                  .colorInvert(condition: .dark)
                  .display(.inlineBlock)
                  .frame(width: 36)

                H1("General support")
                  .fontSize(.extraLarge)
                  .fontSize(.fourXLarge, condition: .desktop)
                  .bold()
                  .fontDesign("rounded")
              }
              Article("Sidecar supports the [SAEJ1979 OBD-II standard](https://en.wikipedia.org/wiki/OBD-II_PIDs) for vehicles produced in the USA since 1996 and vehicles worldwide in the 2000's. For vehicles that support OBD-II — typically combustion and hybrid vehicles — this enables out-of-the-box support for odometer, speed, fuel tank levels, and 100s of other parameters. You can test your vehicle's OBD-II support with Sidecar for free.")
            }
            .padding([.top, .horizontal], 16)
            .background(.zinc, darkness: 0)
            .background(.zinc, darkness: 900, condition: .dark)
            .cornerRadius(.extraExtraLarge)
            .margin(.horizontal, .auto, condition: .desktop)
            .frame(width: 0.5, condition: .desktop)
          }
        }
        .margin(.bottom, 32)

        // Parameter Support Table
        Section {
          ContentContainer {
            VStack(alignment: .leading, spacing: 16) {
              let parameterMap = supportMatrix.parameters(for: obdbID)
              let sections = modelSupport.buildParameterSupportTable(parameterMap: parameterMap)

              if !sections.isEmpty {
                ParameterSupportTable(sections: sections)
              }
            }
            .padding(.vertical, 16)
          }
        }
        .margin(.bottom, 32)

        if let aboutContent = modelAboutMarkdown {
          Section {
            ContentContainer {
              VStack(alignment: .leading, spacing: 16) {
                Article(aboutContent)
              }
              .padding(.vertical, 16)
            }
          }
          .margin(.bottom, 32)
        }
      }
    } else {
      Page(
        "Model not found",
        path: "/cars/\(makeNameForSorting(make))/\(obdbID.lowercased())/",
        description: "Model not found.",
        keywords: []
      ) {
        ContentContainer {
          Slipstream.Text("Model not found")
        }
      }
    }
  }
}
