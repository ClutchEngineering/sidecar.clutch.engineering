import Foundation
import Slipstream
import VehicleSupport

struct LeaderboardPage: View {
  private struct LeaderboardEntry {
    let series: String
    let customName: String
    let count: Float
  }

  private struct LeaderboardRow: View {
    let rank: Int
    let symbolName: String?
    let vehicleName: String
    let count: Float

    var body: some View {
      TableRow {
        // Rank column
        Bordered {
          TableCell {
            Text("\(rank)")
          }
          .textAlignment(.trailing)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)

        // Vehicle column with icon
        Bordered {
          TableCell {
            HStack {
              Text(vehicleName)
              if let symbolName = symbolName {
                Image(URL(string: "/gfx/model/\(symbolName).svg")!)
                  .colorInvert(condition: .dark)
                  .frame(width: 48)
                  .margin(.right, 8)
              }
            }
            .justifyContent(.between)
            .frame(height: 48)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)

        // Score column
        Bordered(showTrailingBorder: false) {
          TableCell {
            Text(String(format: "%.0f", count))
              .textAlignment(.leading)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
      }
    }
  }

  private let leaderboardData: [LeaderboardEntry]
  private let makes: [Make: [Model: [VehicleSupportStatus]]]

  init() {
    // Load and process CSV data
    let csvContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model", withExtension: "csv")!)

    var entries: [LeaderboardEntry] = []
    let rows = csvContent.components(separatedBy: .newlines)
    for row in rows.dropFirst() { // Skip header
      let columns = row.components(separatedBy: ",")
      if columns.count == 3,
         let count = Float(columns[2]) {
        entries.append(LeaderboardEntry(
          series: columns[0],
          customName: columns[1],
          count: count
        ))
      }
    }

    // Sort by count descending
    self.leaderboardData = entries.sorted { $0.count > $1.count }

    // Load vehicle support data
    self.makes = try! VehicleSupportStatus.loadAll()
  }

  private func findVehicleInfo(series: String, in makes: [Make: [Model: [VehicleSupportStatus]]]) -> (symbolName: String?, vehicleName: String) {
    for (make, models) in makes {
      for (model, _) in models {
        if series.contains(make) && series.contains(model.name) {
          return (model.symbolName, "\(make) \(model.name)")
        }
      }
    }
    return (nil, series)
  }

  var body: some View {
    Page(
      "Beta Tester Leaderboard",
      path: "/beta/leaderboard/",
      description: "See which vehicles are being tested the most in Sidecar.",
      keywords: [
        "OBD-II",
        "beta testing",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      ContentContainer {
        ContentContainer {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/leaderboard.png")!)

            Div {
              H1("Beta Tester Leaderboard")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Most-driven vehicles in the Turn-by-Turn Navigation beta")
                .fontSize(.large)
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
        .margin(.bottom, 16)

        Image(URL(string: "/gfx/carplay.png"))
          .frame(width: 0.75)
          .margin(.horizontal, .auto)
          .margin(.bottom, 16)

        Section {
          ContentContainer {
            VStack(alignment: .center, spacing: 8) {
              Link(URL(string: "mailto:jeff@featherless.design")) {
                VStack(alignment: .center, spacing: 4) {
                  H1("Want to join the beta?")
                    .fontSize(.extraLarge)
                    .fontSize(.fourXLarge, condition: .desktop)
                    .bold()
                    .fontDesign("rounded")
                  Text("Email jeff@featherless.design to join")
                    .fontSize(.large)
                    .fontSize(.extraLarge, condition: .desktop)
                    .fontWeight(.medium)
                    .fontDesign("rounded")
                    .underline(condition: .hover)
                  Text("Include your vehicle make/model/year with the subject \"CarPlay navigation TestFlight\"")
                    .fontWeight(.bold)
                    .fontDesign("rounded")
                    .fontSize(.large)
                }
                .textAlignment(.center)
                .classNames(["bg-gradient-to-tl", "from-cyan-500", "to-blue-600"])
                .transition(.all)
                .textColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
                .background(.zinc, darkness: 100)
                .background(.zinc, darkness: 900, condition: .dark)
                .cornerRadius(.extraExtraLarge)
              }
            }
            .frame(width: 0.8)
            .frame(width: 0.6, condition: .desktop)
            .margin(.horizontal, .auto)
          }
          .padding(.vertical, 8)
          .padding(.vertical, 16, condition: .desktop)
        }
        .margin(.bottom, 32)

        // Table showing the leaderboard
        Table {
          TableHeader {
            HeaderCell { Text("Rank") }
            HeaderCell { Text("Vehicle") }
            HeaderCell { Text("Miles driven") }
          }
          .background(.gray, darkness: 100)
          .background(.zinc, darkness: 950, condition: .dark)

          TableBody {
            for (index, entry) in leaderboardData.enumerated() {
              let vehicleInfo = findVehicleInfo(series: entry.series, in: makes)
              if vehicleInfo.vehicleName != "/" {
                LeaderboardRow(
                  rank: index + 1,
                  symbolName: vehicleInfo.symbolName,
                  vehicleName: vehicleInfo.vehicleName,
                  count: entry.count
                )
              }
            }
          }
        }
        .margin(.bottom, 32)
        .border(.init(.zinc, darkness: 400), width: 1)
        .border(.init(.zinc, darkness: 600), width: 1, condition: .dark)
        .cornerRadius(.large)
        .fontSize(.extraSmall, condition: .mobileOnly)
        .margin(.horizontal, .auto)
        .frame(width: 0.8)
        .frame(width: 0.6, condition: .desktop)
      }
    }
  }
}
