import Foundation
import Slipstream
import VehicleSupportMatrix

/// View component for displaying the full parameter support table
struct ParameterSupportTable: View {
  let sections: [MergedSupportMatrix.ModelSupport.ParameterTableSection]
  let modelYears: [Int]

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      H2("All Parameters by Model Year")
        .fontSize(.extraLarge)
        .fontSize(.twoXLarge, condition: .desktop)
        .bold()
        .fontDesign("rounded")
        .margin(.bottom, 16)

      if sections.isEmpty {
        Slipstream.Text("No parameter data available yet.")
          .textColor(.zinc, darkness: 600)
          .textColor(.zinc, darkness: 400, condition: .dark)
      } else {
        ForEach(sections, id: \.path) { section in
          VStack(alignment: .leading, spacing: 12) {
            H3(section.path)
              .fontSize(.large)
              .bold()
              .fontDesign("rounded")
              .margin(.bottom, 8)

            // Create a responsive table
            Div {
              // Table header
              Div {
                Div {
                  Span("Parameter")
                    .bold()
                    .padding(8)
                }
                .gridColumn(start: 1, end: 2)

                ForEach(Array(modelYears.enumerated()), id: \.offset) { index, year in
                  Div {
                    Span(String(year))
                      .bold()
                      .padding(8)
                  }
                  .gridColumn(start: index + 2, end: index + 3)
                }
              }
              .display(.grid)
              .gridTemplateColumns(["200px"] + Array(repeating: "60px", count: modelYears.count))
              .background(.zinc, darkness: 100)
              .background(.zinc, darkness: 800, condition: .dark)

              // Table rows
              ForEach(section.rows, id: \.parameter.id) { row in
                Div {
                  Div {
                    VStack(alignment: .leading, spacing: 4) {
                      Span(row.parameter.name)
                        .bold()
                      if let unit = row.parameter.unit {
                        Span("(\(unit))")
                          .fontSize(.small)
                          .textColor(.zinc, darkness: 600)
                          .textColor(.zinc, darkness: 400, condition: .dark)
                      }
                    }
                    .padding(8)
                  }
                  .gridColumn(start: 1, end: 2)

                  ForEach(Array(modelYears.enumerated()), id: \.offset) { index, year in
                    Div {
                      if let supportLevel = row.supportByYear[year] {
                        SupportLevelIndicator(level: supportLevel)
                      } else {
                        Span("")
                      }
                    }
                    .gridColumn(start: index + 2, end: index + 3)
                    .textAlignment(.center)
                    .padding(8)
                  }
                }
                .display(.grid)
                .gridTemplateColumns(["200px"] + Array(repeating: "60px", count: modelYears.count))
                .border(.init(.zinc, darkness: 200), width: 1)
                .border(.init(.zinc, darkness: 700), width: 1, condition: .dark)
              }
            }
            .className("overflow-x-auto")
            .margin(.bottom, 16)
          }
          .padding(16)
          .background(.zinc, darkness: 50)
          .background(.zinc, darkness: 900, condition: .dark)
          .cornerRadius(.large)
        }
      }
    }
  }
}

/// Indicator for parameter support level
struct SupportLevelIndicator: View {
  let level: ParameterSupportLevel

  var body: some View {
    switch level {
    case .confirmed:
      Span("✓")
        .textColor(.green, darkness: 600)
        .textColor(.green, darkness: 400, condition: .dark)
        .bold()
    case .shouldBeSupported:
      Span("○")
        .textColor(.blue, darkness: 600)
        .textColor(.blue, darkness: 400, condition: .dark)
    case .unknown:
      Span("")
        .textColor(.zinc, darkness: 400)
    case .unsupported:
      Span("✗")
        .textColor(.red, darkness: 600)
        .textColor(.red, darkness: 400, condition: .dark)
    }
  }
}
