import Foundation
import Slipstream
import VehicleSupport

private let modelNormalizations: [String: String] = [
  "BMW/335d Xdrive": "BMW/3 Series",
]

private func getCSVModificationDate() -> String {
  let fileManager = FileManager.default
  let bundle = Bundle.module

  guard let csvPath = bundle.path(forResource: "export-carplay-distance-traveled-by-model", ofType: "csv") else {
    print("CSV file not found")
    return "2024-01-07T00:00:00Z" // Fallback date
  }

  do {
    let attributes = try fileManager.attributesOfItem(atPath: csvPath)
    if let modificationDate = attributes[.modificationDate] as? Date {
      // Format the date in ISO 8601 format which JavaScript can parse
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime]
      return formatter.string(from: modificationDate)
    }
  } catch {
    print("Error getting file attributes: \(error)")
  }

  return "2025-01-06T00:00:00Z" // Fallback date
}

struct LeaderboardPage: View {
  private static func formatNumber(_ value: Float) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: value)) ?? "0"
  }

  private struct LeaderboardEntry {
    let series: String
    let customName: String
    let count: Float
    let driverCount: Int
    var rankChange: Int?  // Change in rank since yesterday
    var mileageChange: Float?  // Change in miles since yesterday
  }

  private struct LeaderboardRow: View {
    let rank: Int
    let symbolName: String?
    let vehicleName: String
    let count: Float
    let driverCount: Int
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
                if let formattedChange = formatRankChange(-rankChange) {  // Negative because moving up means lower rank number
                  Text(formattedChange)
                }
              }
            }
          }
          .textAlignment(.center)
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

        // Driver count column
        Bordered {
          TableCell {
            Text("\(driverCount)")
              .textAlignment(.center)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)

        // Score column with change
        Bordered(showTrailingBorder: false) {
          TableCell {
            HStack(alignment: .baseline) {
              Text(LeaderboardPage.formatNumber(count))
              if let mileageChange = mileageChange,
                 abs(mileageChange) > 0 {
                Text((mileageChange > 0 ? "+" : "") + LeaderboardPage.formatNumber(mileageChange))
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

  private let leaderboardData: [LeaderboardEntry]
  private let makes: [Make: [Model: [VehicleSupportStatus]]]

  init() {
    // Load vehicle support data first
    self.makes = try! VehicleSupportStatus.loadAll()

    // Load and process current CSV data
    let csvContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model", withExtension: "csv")!)
    let yesterdayContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model-yesterday", withExtension: "csv")!)
    let driversContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-drivers-by-model", withExtension: "csv")!)

    // Process entries and combine duplicates for today
    var vehicleEntries: [String: (LeaderboardEntry, String)] = [:]
    var yesterdayEntries: [String: Float] = [:]
    var yesterdayRanks: [String: Int] = [:]
    var driverCounts: [String: Int] = [:]

    // Process drivers data first
    let driverRows = driversContent.components(separatedBy: .newlines)
    for row in driverRows.dropFirst() {
      let columns = row.components(separatedBy: ",")
      if columns.count == 3,
         let driverCount = Int(columns[2]) {
        let vehicleInfo = Self.findVehicleInfo(series: columns[0], in: makes)
        if vehicleInfo.vehicleName != "/" {
          let normalizedName = vehicleInfo.vehicleName.lowercased()
          driverCounts[normalizedName] = (driverCounts[normalizedName] ?? 0) + driverCount
        }
      }
    }

    // Process yesterday's data
    let yesterdayRows = yesterdayContent.components(separatedBy: .newlines)
    var rank = 1
    for row in yesterdayRows.dropFirst() {
      let columns = row.components(separatedBy: ",")
      if columns.count == 3,
         let count = Float(columns[2]) {
        let vehicleInfo = Self.findVehicleInfo(series: columns[0], in: makes)
        if vehicleInfo.vehicleName != "/" {
          let normalizedName = vehicleInfo.vehicleName.lowercased()
          yesterdayEntries[normalizedName] = (yesterdayEntries[normalizedName] ?? 0) + count
          if yesterdayRanks[normalizedName] == nil {
            yesterdayRanks[normalizedName] = rank
            rank += 1
          }
        }
      }
    }

    // Process today's data
    let rows = csvContent.components(separatedBy: .newlines)
    for row in rows.dropFirst() {
      let columns = row.components(separatedBy: ",")
      if columns.count == 3,
         let count = Float(columns[2]) {
        let normalizedSeries = modelNormalizations[columns[0]] ?? columns[0]
        let vehicleInfo = Self.findVehicleInfo(series: normalizedSeries, in: makes)
        if vehicleInfo.vehicleName != "/" {
          let normalizedName = vehicleInfo.vehicleName.lowercased()
          let entry = LeaderboardEntry(
            series: normalizedSeries,
            customName: columns[1],
            count: count,
            driverCount: driverCounts[normalizedName] ?? 0,
            rankChange: nil,
            mileageChange: nil
          )

          if let existingEntry = vehicleEntries[normalizedName] {
            // Add the count to the existing entry
            let updatedEntry = LeaderboardEntry(
              series: existingEntry.0.series,
              customName: existingEntry.0.customName,
              count: existingEntry.0.count + entry.count,
              driverCount: existingEntry.0.driverCount,  // Keep existing driver count
              rankChange: nil,
              mileageChange: nil
            )
            vehicleEntries[normalizedName] = (updatedEntry, existingEntry.1)
          } else {
            // Create new entry
            vehicleEntries[normalizedName] = (entry, vehicleInfo.vehicleName)
          }
        }
      }
    }

    // Convert to array and sort by count
    var sortedEntries = vehicleEntries.values.map { entry -> (LeaderboardEntry, String) in
      let normalizedName = entry.1.lowercased()
      let yesterdayCount = yesterdayEntries[normalizedName] ?? 0
      let yesterdayRank = yesterdayRanks[normalizedName]

      var updatedEntry = entry.0
      updatedEntry.mileageChange = entry.0.count - yesterdayCount
      updatedEntry.rankChange = yesterdayRank

      return (updatedEntry, entry.1)
    }.sorted { $0.0.count > $1.0.count }

    // Update rank changes based on current position
    for (currentRank, entry) in sortedEntries.enumerated() {
      let normalizedName = entry.1.lowercased()
      if let yesterdayRank = yesterdayRanks[normalizedName] {
        sortedEntries[currentRank].0.rankChange = yesterdayRank - (currentRank + 1)
      }
    }

    // Final assignment
    self.leaderboardData = sortedEntries.map { $0.0 }
  }

  private static func findVehicleInfo(series: String, in makes: [Make: [Model: [VehicleSupportStatus]]]) -> (symbolName: String?, vehicleName: String) {
    let components = series.components(separatedBy: "/")
    guard components.count >= 2 else { return (nil, series) }

    let seriesMake = components[0].lowercased()
    let seriesModel = components[1].lowercased()

    for (make, models) in makes {
      let normalizedMake = make.lowercased()
      if normalizedMake == seriesMake {
        for (model, _) in models {
          let normalizedModel = model.name.lowercased()
          if normalizedModel == seriesModel {
            return (model.symbolName, "\(make) \(model.name)")
          }
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
              Link(URL(string: "mailto:jeff@featherless.design?subject=CarPlay navigation TestFlight&body=I'd like to help beta test Sidecar turn-by-turn navigation in CarPlay. My vehicle is a...")) {
                VStack(alignment: .center, spacing: 4) {
                  H1("Want to join the beta?")
                    .fontSize(.extraLarge)
                    .fontSize(.fourXLarge, condition: .desktop)
                    .bold()
                    .fontDesign("rounded")
                  Text("Email jeff@featherless.design to join")
                    .fontSize(.small)
                    .fontSize(.extraLarge, condition: .desktop)
                    .fontWeight(.medium)
                    .fontDesign("rounded")
                    .underline(condition: .hover)
                  Text("Include your vehicle make/model/year with the subject \"CarPlay navigation TestFlight\"")
                    .fontWeight(.bold)
                    .fontDesign("rounded")
                    .fontSize(.small)
                    .fontSize(.large, condition: .desktop)
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

        // Total mileage and driver display
        VStack(alignment: .center, spacing: 16) {
          VStack(alignment: .center) {
            Text("Total Miles Driven")
              .bold()
              .fontSize(.large)
            Text(Self.formatNumber(leaderboardData.reduce(0) { $0 + $1.count }))
              .fontSize(.extraExtraLarge)
              .bold()
              .fontDesign("rounded")
              .id("total-miles-counter")
              .data([
                "base-value": String(leaderboardData.reduce(0) { $0 + $1.count }),
                "snapshot-date": getCSVModificationDate()
              ])
          }
          VStack(alignment: .center) {
            Text("# of Stigs")
              .bold()
              .fontSize(.large)
            Text("\(leaderboardData.reduce(0) { $0 + $1.driverCount })")
              .fontSize(.extraExtraLarge)
              .bold()
              .fontDesign("rounded")
          }
        }
        .margin(.bottom, 32)
        .textAlignment(.center)

        // Table showing the leaderboard
        Table {
          TableHeader {
            HeaderCell { Text("Rank") }
            HeaderCell { Text("Vehicle") }
            HeaderCell { Text("Stigs") }
            HeaderCell { Text("Miles driven") }
          }
          .background(.gray, darkness: 100)
          .background(.zinc, darkness: 950, condition: .dark)

          TableBody {
            for (index, entry) in leaderboardData.enumerated() {
              let vehicleInfo = Self.findVehicleInfo(series: entry.series, in: makes)
              if vehicleInfo.vehicleName != "/" {
                LeaderboardRow(
                  rank: index + 1,
                  symbolName: vehicleInfo.symbolName,
                  vehicleName: vehicleInfo.vehicleName,
                  count: entry.count,
                  driverCount: entry.driverCount,
                  rankChange: entry.rankChange,
                  mileageChange: entry.mileageChange
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
