import Foundation
import Slipstream

struct LeaderboardRow: View {
  let rank: Int
  let symbolName: String?
  let vehicleName: String
  let count: Float
  let driverCount: Int
  let rankChange: Int?
  let mileageChange: Float?
  let showDriverCount: Bool

  init(
    rank: Int,
    symbolName: String?,
    vehicleName: String,
    count: Float,
    driverCount: Int,
    rankChange: Int? = nil,
    mileageChange: Float? = nil,
    showDriverCount: Bool = true
  ) {
    self.rank = rank
    self.symbolName = symbolName
    self.vehicleName = vehicleName
    self.count = count
    self.driverCount = driverCount
    self.rankChange = rankChange
    self.mileageChange = mileageChange
    self.showDriverCount = showDriverCount
  }

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

      // Driver count column (optional)
      if showDriverCount {
        Bordered {
          TableCell {
            Text("\(driverCount)")
              .textAlignment(.center)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
      }

      // Score column with change
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

