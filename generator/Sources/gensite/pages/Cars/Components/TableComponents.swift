import Foundation
import Slipstream
import VehicleSupport

struct Bordered<Content: View>: View {
  let showTrailingBorder: Bool
  init(showTrailingBorder: Bool = true, @ViewBuilder content: @escaping @Sendable () -> Content) {
    self.showTrailingBorder = showTrailingBorder
    self.content = content
  }
  @ViewBuilder let content: @Sendable () -> Content
  @Environment(\.isLastRow) var isLastRow

  var edges: Edge.Set {
    var set: Edge.Set = []
    if !isLastRow {
      set.insert(.bottom)
    }
    if showTrailingBorder {
      set.insert(.right)
    }
    return set
  }

  var body: some View {
    content()
      .border(.init(.zinc, darkness: 400), width: 1, edges: edges)
      .border(.init(.zinc, darkness: 600), width: 1, edges: edges, condition: .dark)
  }
}

struct Borderless<Content: View>: View {
  @ViewBuilder let content: @Sendable () -> Content

  var body: some View {
    content()
      .className("border-0")
  }
}

struct HeaderCell<Content: View>: View {
  let isLast: Bool
  @ViewBuilder let content: @Sendable () -> Content

  init(isLast: Bool = false, @ViewBuilder content: @escaping @Sendable () -> Content) {
    self.isLast = isLast
    self.content = content
  }

  var body: some View {
    Bordered(showTrailingBorder: !isLast) {
      TableHeaderCell(content: content)
        .padding(8)
        .background(.zinc, darkness: 200)
        .background(.zinc, darkness: 900, condition: .dark)
        .textAlignment(.center)
        .fontSize(.extraSmall, condition: .mobileOnly)
        .className("first:rounded-tl-lg")
        .className("last:rounded-tr-lg")
    }
  }
}

struct EnvironmentAwareRow<Content: View>: View {
  let isLastRow: Bool
  @ViewBuilder
  let content: @Sendable () -> Content

  var body: some View {
    TableRow {
      content()
    }
    .environment(\.isLastRow, isLastRow)
  }
}

struct YearsCell: View {
  let years: ClosedRange<Int>

  var body: some View {
    Bordered {
      TableCell {
        if years.lowerBound == years.upperBound {
          Text("\(years.lowerBound)")
        } else {
          Text("\(years.lowerBound)-\(years.upperBound)")
        }
      }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 12)
  }
}

struct AllYearsCell: View {
  var body: some View {
    Bordered {
      TableCell {
        Text("All model years")
      }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 12)
  }
}

struct OnboardedStatusCell: View {
  var body: some View {
    Bordered {
      TableCell {
        SupportedSeal()
      }
    }
  }
}

struct TesterNeededStatusCell: View {
  var body: some View {
    Bordered {
      TableCell {
        Link("Tester needed", destination: becomeBetaURL)
          .textColor(.link, darkness: 700)
          .textColor(.link, darkness: 400, condition: .dark)
          .fontWeight(600)
          .underline(condition: .hover)
          .textAlignment(.leading)
      }
    }
    .padding(.horizontal, 4)
    .padding(.horizontal, 8, condition: .desktop)
    .padding(.vertical, 12)
  }
}
