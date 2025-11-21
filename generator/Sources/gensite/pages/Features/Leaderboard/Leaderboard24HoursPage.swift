import Foundation
import Slipstream
import VehicleSupport
import VehicleSupportMatrix

struct Leaderboard24HoursPage: View {
  private let leaderboardData: [LeaderboardEntry]
  let supportMatrix: MergedSupportMatrix
  private let totalMilesDriven: Float

  init(supportMatrix: MergedSupportMatrix) {
    self.supportMatrix = supportMatrix

    // Load CSV data for today and yesterday
    let csvContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model", withExtension: "csv")!, encoding: .utf8)
    let yesterdayContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-distance-traveled-by-model-yesterday", withExtension: "csv")!, encoding: .utf8)
    let driversContent = try! String(contentsOf: Bundle.module.url(forResource: "export-carplay-drivers-by-model", withExtension: "csv")!, encoding: .utf8)

    // Process the data using shared utility
    let entries = LeaderboardUtils.processLeaderboardData(
      currentCSV: csvContent,
      yesterdayCSV: yesterdayContent,
      driversCSV: driversContent,
      supportMatrix: supportMatrix
    )

    // Sort by mileage change instead of total miles
    self.leaderboardData = entries
      .filter { $0.mileageChange != nil }  // Only include entries with changes
      .sorted {
        let change1 = $0.mileageChange ?? 0
        let change2 = $1.mileageChange ?? 0
        return change1 > change2  // Sort by delta
      }

    // Calculate total miles driven in last 24 hours
    self.totalMilesDriven = entries.reduce(0) { $0 + ($1.mileageChange ?? 0) }
  }

  var body: some View {
    Page(
      "Last 24 Hours",
      path: "/leaderboard/24h/",
      description: "See which vehicles covered the most ground in Sidecar in the last 24 hours.",
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
              H1("Last 24 Hours")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Most miles covered in the last day")
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

        // Total mileage display for last 24h
        VStack(alignment: .center, spacing: 16) {
          VStack(alignment: .center) {
            Text("Miles Driven (Last 24h)")
              .bold()
              .fontSize(.large)
            Text(LeaderboardUtils.formatNumber(totalMilesDriven))
              .fontSize(.extraExtraLarge)
              .bold()
              .fontDesign("rounded")
          }
        }
        .margin(.bottom, 32)
        .textAlignment(.center)
      }

      // Table showing the leaderboard
      Table {
        TableHeader {
          HeaderCell { Text("Rank") }
          HeaderCell { Text("Vehicle") }
          HeaderCell { Text("Miles in 24h") }
        }
        .background(.gray, darkness: 100)
        .background(.zinc, darkness: 950, condition: .dark)

        TableBody {
          // Show all entries with non-zero changes
          for (index, entry) in leaderboardData.filter({ $0.series != anonymousDriverName }).enumerated() {
            let vehicleInfo = LeaderboardUtils.findVehicleInfo(series: entry.series, in: supportMatrix)
            if vehicleInfo.vehicleName != "/",
               (entry.mileageChange ?? 0) > 0 {
              LeaderboardRow(
                rank: index + 1,
                symbolName: vehicleInfo.symbolName,
                vehicleName: vehicleInfo.vehicleName,
                vehicleURL: vehicleInfo.vehicleURL,
                count: entry.mileageChange ?? 0,  // Show the delta instead of total
                driverCount: entry.driverCount,
                showDriverCount: false
              )
            }
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
            Text("← By Model")
              .fontSize(.large)
              .bold()
          }
          Link(URL(string: "/leaderboard/makes/")) {
            Text("By Make")
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
