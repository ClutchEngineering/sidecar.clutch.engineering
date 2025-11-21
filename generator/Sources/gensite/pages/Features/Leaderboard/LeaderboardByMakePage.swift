import Foundation
import Slipstream
import VehicleSupport
import VehicleSupportMatrix

struct LeaderboardByMakePage: View {
  private struct MakeEntry {
    let standardizedMake: String
    let count: Float
    let driverCount: Int
    let modelCount: Int
    var rankChange: Int?
    var mileageChange: Float?
    var logoURL: URL?
  }

  private struct LeaderboardData {
    let totalMilesDriven: Float
    let leaderboard: [MakeEntry]
  }
  private let leaderboardData: LeaderboardData
  let supportMatrix: MergedSupportMatrix

  private static func getLogoURL(for make: String) -> URL? {
    let normalizedMake = make.lowercased()
    let mapping: [String: String] = [
      "alfa romeo": "alfaromeo",
      "land rover": "landrover",
      "mercedes-benz": "mercedes",
      "mercedes benz": "mercedes",
      "opel": "vauxhall-opel",
      "citroën": "citroen",
      "vauxhall": "vauxhall-opel",
      "vauxhall/opel": "vauxhall-opel",
    ]

    let filename = mapping[normalizedMake] ?? normalizedMake
    return URL(string: "/gfx/make/\(standardizeMake(filename)).svg")
  }

  init(supportMatrix: MergedSupportMatrix) {
    self.supportMatrix = supportMatrix

    // Load and process CSV data
    let csvContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model", withExtension: "csv")!, encoding: .utf8)
    let yesterdayContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model-yesterday", withExtension: "csv")!, encoding: .utf8)
    let driversContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-drivers-by-model", withExtension: "csv")!, encoding: .utf8)

    // Process the raw data using shared utility
    let rawEntries = LeaderboardUtils.processLeaderboardData(
      currentCSV: csvContent,
      yesterdayCSV: yesterdayContent,
      driversCSV: driversContent,
      supportMatrix: supportMatrix
    )

    // Group entries by make
    var makeEntries: [String: MakeEntry] = [:]

    // Process entries to aggregate by make
    for entry in rawEntries.filter({ $0.series != anonymousDriverName }) {
      let standardizedMake = standardizeMake(entry.series.split(separator: "/").first?.description ?? "Unknown")

      // Update or create make entry
      if let existing = makeEntries[standardizedMake] {
        makeEntries[standardizedMake] = MakeEntry(
          standardizedMake: standardizedMake,
          count: existing.count + entry.milesDriven,
          driverCount: existing.driverCount + entry.driverCount,
          modelCount: existing.modelCount + 1,
          rankChange: nil,
          mileageChange: (existing.mileageChange ?? 0) + (entry.mileageChange ?? 0),
          logoURL: existing.logoURL
        )
      } else {
        makeEntries[standardizedMake] = MakeEntry(
          standardizedMake: standardizedMake,
          count: entry.milesDriven,
          driverCount: entry.driverCount,
          modelCount: 1,
          rankChange: nil,
          mileageChange: entry.mileageChange,
          logoURL: Self.getLogoURL(for: standardizedMake)
        )
      }
    }

    // Process yesterday's data to get yesterday's rankings
    let yesterdayEntries = LeaderboardUtils.processLeaderboardData(
      currentCSV: yesterdayContent,
      yesterdayCSV: nil,
      driversCSV: driversContent,
      supportMatrix: supportMatrix
    )

    // Group yesterday's entries by make
    var yesterdayMakeEntries: [String: Float] = [:]
    for entry in yesterdayEntries.filter({ $0.series != anonymousDriverName }) {
      let standardizedMake = standardizeMake(entry.series.split(separator: "/").first?.description ?? "Unknown")
      yesterdayMakeEntries[standardizedMake] = (yesterdayMakeEntries[standardizedMake] ?? 0) + entry.milesDriven
    }

    // Calculate yesterday's rankings
    let sortedYesterdayMakes = yesterdayMakeEntries.sorted { $0.value > $1.value }
    var yesterdayRanks: [String: Int] = [:]
    for (index, entry) in sortedYesterdayMakes.filter({ $0.key != anonymousDriverName }).enumerated() {
      yesterdayRanks[standardizeMake(entry.key)] = index + 1
    }

    // Sort current makes by total miles
    let sortedMakes = makeEntries.sorted { $0.value.count > $1.value.count }
    var todayRanks: [String: Int] = [:]
    for (index, entry) in sortedMakes.filter({ $0.key != anonymousDriverName }).enumerated() {
      todayRanks[standardizeMake(entry.key)] = index + 1
    }

    // Update rank changes and mileage changes based on current position
    var finalEntries: [MakeEntry] = []
    for (_, entry) in sortedMakes.enumerated() {
      var updatedEntry = entry
      if let yesterdayRank = yesterdayRanks[entry.value.standardizedMake],
         let todayRank = todayRanks[entry.value.standardizedMake] {
        updatedEntry.value.rankChange = yesterdayRank - todayRank
      }
      // Calculate mileage change
      let yesterdayMiles = yesterdayMakeEntries[entry.value.standardizedMake] ?? 0
      updatedEntry.value.mileageChange = entry.value.count - yesterdayMiles
      finalEntries.append(updatedEntry.value)
    }

    self.leaderboardData = LeaderboardData(
      totalMilesDriven: rawEntries.map { $0.milesDriven }.reduce(0, +),
      leaderboard: finalEntries
    )
  }

  private struct MakeRow: View {
    let rank: Int
    let make: String
    let count: Float
    let driverCount: Int
    let modelCount: Int
    let rankChange: Int?
    let mileageChange: Float?
    let logoURL: URL?

    private func formatRankChange(_ change: Int) -> String? {
      if change == 0 { return nil }
      return change > 0 ? "▼\(abs(change))" : "▲\(abs(change))"
    }

    var body: some View {
      TableRow {
        // Rank column with change indicator
        Bordered {
          TableCell {
            HStack(spacing: 8) {
              Text("\(rank)")
              if let rankChange = rankChange {
                if let formattedChange = formatRankChange(-rankChange) {
                  Text(formattedChange)
                }
              }
            }
          }
          .textAlignment(.center)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)

        // Make column with logo
        Bordered {
          TableCell {
            HStack(spacing: 16) {
              if let logoURL = logoURL {
                Image(logoURL)
                  .colorInvert(condition: .dark)
                  .display(.inlineBlock)
                  .frame(width: 16, height: 16)
                  .frame(width: 48, height: 48, condition: .desktop)
              }
              Text(localizedNameForStandardizedMake(make))
                .bold()
            }
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)

        // Models column
        Bordered {
          TableCell {
            Text("\(modelCount)")
              .textAlignment(.center)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)

        // Drivers column
        Bordered {
          TableCell {
            Text("\(driverCount)")
              .textAlignment(.center)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)

        // Miles column with change
        Bordered(showTrailingBorder: false) {
          TableCell {
            HStack(alignment: .baseline, spacing: 8) {
              Text(LeaderboardUtils.formatNumber(count))
              if let mileageChange = mileageChange,
                 abs(mileageChange) > 0 {
                Text((mileageChange > 0 ? "+" : "") + LeaderboardUtils.formatNumber(mileageChange))
                  .fontSize(.extraSmall, condition: .mobileOnly)
                  .fontSize(.small)
                  .bold()
              }
            }
            .justifyContent(.between)
            .textAlignment(.center)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
      }
    }
  }

  var body: some View {
    Page(
      "Leaderboard by Make",
      path: "/leaderboard/makes/",
      description: "See which vehicle manufacturers are being driven the most in Sidecar.",
      keywords: [
        "OBD-II",
        "car manufacturers",
        "vehicle brands",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ],
      scripts: [
        URL(string: "/scripts/miles-counter.js")
      ]
    ) {
      FeaturesBreadcrumb()

      ContentContainer {
        ContentContainer {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/leaderboard.png")!)

            Div {
              H1("Leaderboard by Make")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Most-driven vehicle manufacturers")
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

        // Total statistics display
        VStack(alignment: .center, spacing: 16) {
          VStack(alignment: .center) {
            Text("Total Miles Driven")
              .bold()
              .fontSize(.large)
            Text(LeaderboardUtils.formatNumber(leaderboardData.totalMilesDriven))
              .fontSize(.extraExtraLarge)
              .bold()
              .fontDesign("rounded")
              .id("total-miles-counter")
              .data([
                "base-value": String(leaderboardData.totalMilesDriven),
                "snapshot-date": LeaderboardUtils.getCSVModificationDate(resourceName: "export-carplay-distance-traveled-by-model")
              ])
          }
          HStack(spacing: 32) {
            VStack(alignment: .center) {
              Text("Makes")
                .bold()
                .fontSize(.large)
              Text("\(leaderboardData.leaderboard.count)")
                .fontSize(.extraLarge)
                .bold()
                .fontDesign("rounded")
            }
            VStack(alignment: .center) {
              Text("Models")
                .bold()
                .fontSize(.large)
              Text("\(leaderboardData.leaderboard.reduce(0) { $0 + $1.modelCount })")
                .fontSize(.extraLarge)
                .bold()
                .fontDesign("rounded")
            }
            VStack(alignment: .center) {
              Text("Stigs")
                .bold()
                .fontSize(.large)
              Text("\(leaderboardData.leaderboard.reduce(0) { $0 + $1.driverCount })")
                .fontSize(.extraLarge)
                .bold()
                .fontDesign("rounded")
            }
          }
        }
        .margin(.bottom, 32)
        .textAlignment(.center)
      }

      // Table showing the leaderboard
      Table {
        TableHeader {
          HeaderCell { Text("Rank") }
          HeaderCell { Text("Make") }
          HeaderCell { Text("Models") }
          HeaderCell { Text("Stigs") }
          HeaderCell { Text("Miles driven") }
        }
        .background(.gray, darkness: 100)
        .background(.zinc, darkness: 950, condition: .dark)

        TableBody {
          for (index, entry) in leaderboardData.leaderboard.enumerated() {
            MakeRow(
              rank: index + 1,
              make: entry.standardizedMake,
              count: entry.count,
              driverCount: entry.driverCount,
              modelCount: entry.modelCount,
              rankChange: entry.rankChange,
              mileageChange: entry.mileageChange,
              logoURL: entry.logoURL
            )
          }
        }
      }
      .margin(.bottom, 32)
      .border(.init(.zinc, darkness: 400), width: 1)
      .border(.init(.zinc, darkness: 600), width: 1, condition: .dark)
      .cornerRadius(.large, condition: .desktop)
      .fontSize(.extraSmall, condition: .mobileOnly)
      .margin(.horizontal, .auto)

      // Navigation links
      ContentContainer {
        HStack(spacing: 16) {
          Link(URL(string: "/leaderboard/")) {
            Text("← Model Leaderboard")
              .fontSize(.large)
              .bold()
          }
          Link(URL(string: "/leaderboard/last24hours/")) {
            Text("Last 24 Hours →")
              .fontSize(.large)
              .bold()
          }
        }
        .margin(.bottom, 32)
        .textAlignment(.center)
      }
    }
  }
}

