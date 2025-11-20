import Foundation
import Slipstream
import VehicleSupportMatrix
import SwiftSoup

/// View component for displaying the full parameter support table
struct ParameterSupportTable: View {
  let sections: [MergedSupportMatrix.ModelSupport.ParameterTableSection]

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      H2("Parameter support by model year")
        .fontSize(.large)
        .fontSize(.extraExtraLarge, condition: .desktop)
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

            ParameterTable(section: section)
          }
        }
      }
    }
  }
}

/// Individual parameter table for a section
struct ParameterTable: View {
  let section: MergedSupportMatrix.ModelSupport.ParameterTableSection

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let wrapper = try container.appendElement("div")
    try wrapper.addClass("overflow-x-auto w-full")

    let table = try wrapper.appendElement("table")
    try table.addClass("w-full border-collapse text-xs sm:text-sm")

    // Header row
    let thead = try table.appendElement("thead")
    let headerRow = try thead.appendElement("tr")
    try headerRow.addClass("border-b-2 border-zinc-300 dark:border-zinc-700 bg-zinc-100 dark:bg-zinc-800")

    // Parameter name header
    let paramHeader = try headerRow.appendElement("th")
    try paramHeader.text("Parameter")
    try paramHeader.addClass("text-left py-2 px-3 font-bold min-w-[200px]")

    // Year column headers
    for (index, yearColumn) in section.yearColumns.enumerated() {
      let yearHeader = try headerRow.appendElement("th")
      try yearHeader.text(yearColumn.label)
      try yearHeader.addClass("text-center py-2 px-2 font-bold min-w-[60px]")

      // Add alternating background colors
      if index % 2 == 0 {
        try yearHeader.addClass("bg-zinc-100 dark:bg-zinc-800")
      } else {
        try yearHeader.addClass("bg-zinc-50 dark:bg-zinc-900")
      }
    }

    // Body rows
    let tbody = try table.appendElement("tbody")

    for (rowIndex, row) in section.rows.enumerated() {
      let tr = try tbody.appendElement("tr")
      if rowIndex < section.rows.count - 1 {
        try tr.addClass("border-b border-zinc-200 dark:border-zinc-700")
      }

      // Parameter name cell
      let nameCell = try tr.appendElement("td")
      try nameCell.addClass("py-2 px-3")

      let nameDiv = try nameCell.appendElement("div")
      try nameDiv.addClass("flex flex-col gap-1")

      let nameSpan = try nameDiv.appendElement("span")
      try nameSpan.text(row.parameter.name)

      if let unit = row.parameter.unit {
        let unitSpan = try nameSpan.appendElement("span")
        try unitSpan.text(" (\(unit))")
        try unitSpan.addClass("text-xs text-zinc-600 dark:text-zinc-400")
      }

      try nameSpan.addClass("font-medium")

      // Signal ID in smaller, secondary color
      let idSpan = try nameDiv.appendElement("span")
      try idSpan.text(row.parameter.id)
      try idSpan.addClass("text-xs text-zinc-500 dark:text-zinc-500 font-mono")

      // Year support cells - use the first year in each column since they're all the same
      for (index, yearColumn) in section.yearColumns.enumerated() {
        let cell = try tr.appendElement("td")
        try cell.addClass("py-2 px-2 text-center")

        // Add alternating background colors
        if index % 2 == 0 {
          try cell.addClass("bg-zinc-50 dark:bg-zinc-800")
        } else {
          try cell.addClass("bg-white dark:bg-zinc-900")
        }

        // Get support level from the first year in this column (all years in the range have the same level)
        if let supportLevel = row.supportByYear[yearColumn.startYear] {
          let indicator = try cell.appendElement("span")

          switch supportLevel {
          case .confirmed:
            try indicator.text("✓")
            try indicator.addClass("text-green-600 dark:text-green-400 font-bold text-lg")
          case .shouldBeSupported:
            try indicator.text("○")
            try indicator.addClass("text-blue-600 dark:text-blue-400 text-lg")
          case .unknown:
            try indicator.text("")
          case .unsupported:
            try indicator.text("✗")
            try indicator.addClass("text-red-600 dark:text-red-400 font-bold")
          }
        }
      }
    }
  }
}
