import Foundation
import Slipstream
import VehicleSupport
import VehicleSupportMatrix

struct LeaderboardPage: View {
  let supportMatrix: MergedSupportMatrix
  private let leaderboardData: [LeaderboardEntry]

  init(supportMatrix: MergedSupportMatrix) {
    self.supportMatrix = supportMatrix

    // Load and process CSV data
    let csvContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model", withExtension: "csv")!, encoding: .utf8)
    let yesterdayContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model-yesterday", withExtension: "csv")!, encoding: .utf8)
    let driversContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-drivers-by-model", withExtension: "csv")!, encoding: .utf8)

    // Process the data using shared utility
    self.leaderboardData = LeaderboardUtils.processLeaderboardData(
      currentCSV: csvContent,
      yesterdayCSV: yesterdayContent,
      driversCSV: driversContent,
      supportMatrix: supportMatrix
    )

    exportStatsForDiscord()
  }

  var body: some View {
    Page(
      "Leaderboard",
      path: "/leaderboard/",
      description: "See which vehicles are being driven the most in Sidecar.",
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
      FeaturesBreadcrumb()

      ContentContainer {
        ContentContainer {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/leaderboard.png")!)

            Div {
              H1("Leaderboard")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Most-driven Sidecar vehicles")
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

        // Total mileage and driver display
        VStack(alignment: .center, spacing: 16) {
          VStack(alignment: .center) {
            Text("Total Miles Driven")
              .bold()
              .fontSize(.large)
            Text(LeaderboardUtils.formatNumber(leaderboardData.reduce(0) { $0 + $1.milesDriven }))
              .fontSize(.extraExtraLarge)
              .bold()
              .fontDesign("rounded")
              .id("total-miles-counter")
              .data([
                "base-value": String(leaderboardData.reduce(0) { $0 + $1.milesDriven }),
                "snapshot-date": LeaderboardUtils.getCSVModificationDate(resourceName: "export-carplay-distance-traveled-by-model")
              ])
          }
          VStack(alignment: .center) {
            Text("# of Stigs")
              .bold()
              .fontSize(.large)
            Text(LeaderboardUtils.formatNumber(Float(leaderboardData.reduce(0) { $0 + $1.driverCount })))
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
            for (index, entry) in leaderboardData.filter({ $0.series != anonymousDriverName }).enumerated() {
              let vehicleInfo = LeaderboardUtils.findVehicleInfo(series: entry.series, in: supportMatrix)
              if vehicleInfo.vehicleName != "/" {
                LeaderboardRow(
                  rank: index + 1,
                  symbolName: vehicleInfo.symbolName,
                  vehicleName: vehicleInfo.vehicleName,
                  count: entry.milesDriven,
                  driverCount: entry.driverCount,
                  rankChange: entry.rankChange,
                  mileageChange: entry.mileageChange,
                  showDriverCount: true
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

        // Navigation links
        HStack(spacing: 16) {
          Link(URL(string: "/leaderboard/makes/")) {
            Text("By Make")
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

extension LeaderboardPage {
  private func padString(_ str: String, toWidth width: Int, alignment: TextAlignment = .left) -> String {
    if str.count >= width {
      return str
    }
    let padding = String(repeating: " ", count: width - str.count)
    switch alignment {
    case .left:
      return str + padding
    case .right:
      return padding + str
    case .center:
      let leftPad = String(repeating: " ", count: (width - str.count) / 2)
      let rightPad = String(repeating: " ", count: width - str.count - leftPad.count)
      return leftPad + str + rightPad
    }
  }

  private enum TextAlignment {
    case left, right, center
  }

  private func exportStatsForDiscord() {
    // Build the message content
    var message = "🏁 **Daily Leaderboard Update**\n\n• Main leaderboard: https://sidecar.clutch.engineering/leaderboard/\n• Last 24 hours: https://sidecar.clutch.engineering/leaderboard/last24hours/\n• By make: https://sidecar.clutch.engineering/leaderboard/makes/\n\n"

    // Overall stats section
    let totalMiles = leaderboardData.reduce(0) { $0 + $1.milesDriven }
    let totalStigs = leaderboardData.reduce(0) { $0 + $1.driverCount }

    message += "📊 **Overall Stats**\n"
    message += "• Total Miles: \(LeaderboardUtils.formatNumber(totalMiles))\n"
    message += "• Total Stigs: \(LeaderboardUtils.formatNumber(Float(totalStigs)))\n\n"

    // Top 10 vehicles section
    message += "🏆 **Top 10 Vehicles**\n```"

    // Define column widths
    let rankWidth = 3
    let vehicleWidth = 20
    let milesWidth = 15
    let stigsWidth = 6

    // Create header
    message += "\n"
    message += padString("#", toWidth: rankWidth)
    message += padString("Vehicle", toWidth: vehicleWidth)
    message += padString("Miles", toWidth: milesWidth, alignment: .right)
    message += padString("Stigs", toWidth: stigsWidth, alignment: .right)

    // Add separator line
    message += "\n"
    message += String(repeating: "─", count: rankWidth + vehicleWidth + milesWidth + stigsWidth)

    let top10 = leaderboardData.filter({ $0.series != anonymousDriverName }).prefix(10).enumerated()
    for (index, entry) in top10 {
      let vehicleInfo = LeaderboardUtils.findVehicleInfo(series: entry.series, in: supportMatrix)
      let rank = index + 1

      // Format the rank change indicator if it exists
      let rankText: String
      if let rankChange = entry.rankChange {
        if rankChange > 0 {
          rankText = "\(rank) ↑\(rankChange)"
        } else if rankChange < 0 {
          rankText = "\(rank) ↓\(abs(rankChange))"
        } else {
          rankText = "\(rank)"
        }
      } else {
        rankText = "\(rank)"
      }

      // Format the mileage with change if it exists
      let milesText: String
      let baseText = LeaderboardUtils.formatNumber(entry.milesDriven)
      if let mileageChange = entry.mileageChange {
        let sign = mileageChange > 0 ? "+" : ""
        milesText = "(\(sign)\(LeaderboardUtils.formatNumber(mileageChange))) \(baseText)"
      } else {
        milesText = baseText
      }

      // Add table row
      message += "\n"
      message += padString(rankText, toWidth: rankWidth)
      message += padString(vehicleInfo.vehicleName, toWidth: vehicleWidth)
      message += padString(milesText, toWidth: milesWidth, alignment: .right)
      message += padString("\(entry.driverCount)", toWidth: stigsWidth, alignment: .right)
    }

    message += "\n```"

    // Write to file
    do {
      try message.write(
        toFile: "discord_message.txt",
        atomically: true,
        encoding: .utf8
      )
    } catch {
      print("Error writing discord message file: \(error)")
    }
  }
}
