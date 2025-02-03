import Foundation
import Slipstream
import VehicleSupport

struct LeaderboardPage: View {
  private let leaderboardData: [LeaderboardEntry]
  private let makes: [Make: [Model: [VehicleSupportStatus]]]

  init() {
    // Load vehicle support data first
    self.makes = try! VehicleSupportStatus.loadAll()

    // Load and process CSV data
    let csvContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model", withExtension: "csv")!)
    let yesterdayContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model-yesterday", withExtension: "csv")!)
    let driversContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-drivers-by-model", withExtension: "csv")!)

    // Process the data using shared utility
    self.leaderboardData = LeaderboardUtils.processLeaderboardData(
      currentCSV: csvContent,
      yesterdayCSV: yesterdayContent,
      driversCSV: driversContent,
      makes: makes
    )
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
              let vehicleInfo = LeaderboardUtils.findVehicleInfo(series: entry.series, in: makes)
              if vehicleInfo.vehicleName != "/" {
                LeaderboardRow(
                  rank: index + 1,
                  symbolName: vehicleInfo.symbolName,
                  vehicleName: vehicleInfo.vehicleName,
                  count: entry.count,
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
