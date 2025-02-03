import Foundation
import Slipstream
import VehicleSupport

struct LeaderboardByMakePage: View {
  private struct MakeEntry {
    let make: String
    let count: Float
    let driverCount: Int
    let modelCount: Int
    var rankChange: Int?
    var mileageChange: Float?
  }

  private let leaderboardData: [MakeEntry]
  private let makes: [Make: [Model: [VehicleSupportStatus]]]

  init() {
    // Load vehicle support data first
    self.makes = try! VehicleSupportStatus.loadAll()

    // Load and process CSV data
    let csvContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model", withExtension: "csv")!)
    let yesterdayContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model-yesterday", withExtension: "csv")!)
    let driversContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-drivers-by-model", withExtension: "csv")!)

    // Process the raw data using shared utility
    let rawEntries = LeaderboardUtils.processLeaderboardData(
      currentCSV: csvContent,
      yesterdayCSV: yesterdayContent,
      driversCSV: driversContent,
      makes: makes
    )

    // Group entries by make
    var makeEntries: [String: MakeEntry] = [:]
    var yesterdayRanks: [String: Int] = [:]

    // Process entries to aggregate by make
    for entry in rawEntries {
      let vehicleInfo = LeaderboardUtils.findVehicleInfo(series: entry.series, in: makes)
      let makeName = vehicleInfo.vehicleName.split(separator: " ").first?.description ?? "Unknown"

      // Update or create make entry
      if let existing = makeEntries[makeName] {
        makeEntries[makeName] = MakeEntry(
          make: makeName,
          count: existing.count + entry.count,
          driverCount: existing.driverCount + entry.driverCount,
          modelCount: existing.modelCount + 1,
          rankChange: nil,
          mileageChange: (existing.mileageChange ?? 0) + (entry.mileageChange ?? 0)
        )
      } else {
        makeEntries[makeName] = MakeEntry(
          make: makeName,
          count: entry.count,
          driverCount: entry.driverCount,
          modelCount: 1,
          rankChange: nil,
          mileageChange: entry.mileageChange
        )
      }
    }

    // Process yesterday's data to get yesterday's rankings
    let yesterdayEntries = LeaderboardUtils.processLeaderboardData(
      currentCSV: yesterdayContent,
      yesterdayCSV: nil,
      driversCSV: driversContent,
      makes: makes
    )

    // Group yesterday's entries by make
    var yesterdayMakeEntries: [String: Float] = [:]
    for entry in yesterdayEntries {
      let vehicleInfo = LeaderboardUtils.findVehicleInfo(series: entry.series, in: makes)
      let makeName = vehicleInfo.vehicleName.split(separator: " ").first?.description ?? "Unknown"
      yesterdayMakeEntries[makeName] = (yesterdayMakeEntries[makeName] ?? 0) + entry.count
    }

    // Calculate yesterday's rankings
    let sortedYesterdayMakes = yesterdayMakeEntries.sorted { $0.value > $1.value }
    for (index, entry) in sortedYesterdayMakes.enumerated() {
      yesterdayRanks[entry.key] = index + 1
    }

    // Sort current makes by total miles
    let sortedMakes = makeEntries.values.sorted { $0.count > $1.count }

    // Update rank changes and mileage changes based on current position
    var finalEntries: [MakeEntry] = []
    for (currentRank, entry) in sortedMakes.enumerated() {
      var updatedEntry = entry
      if let yesterdayRank = yesterdayRanks[entry.make] {
        updatedEntry.rankChange = yesterdayRank - (currentRank + 1)
      }
      // Calculate mileage change
      let yesterdayMiles = yesterdayMakeEntries[entry.make] ?? 0
      updatedEntry.mileageChange = entry.count - yesterdayMiles
      finalEntries.append(updatedEntry)
    }

    self.leaderboardData = finalEntries
  }

  private struct MakeRow: View {
    let rank: Int
    let make: String
    let count: Float
    let driverCount: Int
    let modelCount: Int
    let rankChange: Int?
    let mileageChange: Float?

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

        // Make column
        Bordered {
          TableCell {
            Text(make)
              .bold()
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
            Text(LeaderboardUtils.formatNumber(leaderboardData.reduce(0) { $0 + $1.count }))
              .fontSize(.extraExtraLarge)
              .bold()
              .fontDesign("rounded")
              .id("total-miles-counter")
              .data([
                "base-value": String(leaderboardData.reduce(0) { $0 + $1.count }),
                "snapshot-date": LeaderboardUtils.getCSVModificationDate(resourceName: "export-carplay-distance-traveled-by-model")
              ])
          }
          HStack(spacing: 32) {
            VStack(alignment: .center) {
              Text("Makes")
                .bold()
                .fontSize(.large)
              Text("\(leaderboardData.count)")
                .fontSize(.extraLarge)
                .bold()
                .fontDesign("rounded")
            }
            VStack(alignment: .center) {
              Text("Models")
                .bold()
                .fontSize(.large)
              Text("\(leaderboardData.reduce(0) { $0 + $1.modelCount })")
                .fontSize(.extraLarge)
                .bold()
                .fontDesign("rounded")
            }
            VStack(alignment: .center) {
              Text("Stigs")
                .bold()
                .fontSize(.large)
              Text("\(leaderboardData.reduce(0) { $0 + $1.driverCount })")
                .fontSize(.extraLarge)
                .bold()
                .fontDesign("rounded")
            }
          }
        }
        .margin(.bottom, 32)
        .textAlignment(.center)

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
            for (index, entry) in leaderboardData.enumerated() {
              MakeRow(
                rank: index + 1,
                make: entry.make,
                count: entry.count,
                driverCount: entry.driverCount,
                modelCount: entry.modelCount,
                rankChange: entry.rankChange,
                mileageChange: entry.mileageChange
              )
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

        // Navigation links
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
