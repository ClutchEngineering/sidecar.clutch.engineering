import Slipstream
import SwiftSoup

struct ComparisonTable: View {
  let headers: [String]
  let rows: [[String]]

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let table = try container.appendElement("div")
    try table.addClass("overflow-x-auto w-full")

    let tableElement = try table.appendElement("table")
    try tableElement.addClass("w-full border-collapse text-xs sm:text-sm table-fixed")

    // Header
    let thead = try tableElement.appendElement("thead")
    let headerRow = try thead.appendElement("tr")
    try headerRow.addClass("border-b border-gray-300 dark:border-gray-600")

    let lastColumnIndex = headers.count - 1
    for (index, header) in headers.enumerated() {
      let th = try headerRow.appendElement("th")
      try th.text(header)
      if index == 0 {
        try th.addClass("text-left py-3 px-2 font-bold")
      } else if index == lastColumnIndex {
        try th.addClass("text-center py-3 px-2 font-black text-lg bg-green-50/30 dark:bg-green-950/30")
      } else {
        try th.addClass("text-center py-3 px-2 font-bold")
      }
    }

    // Body
    let tbody = try tableElement.appendElement("tbody")

    for (index, rowData) in rows.enumerated() {
      let tr = try tbody.appendElement("tr")
      if index < rows.count - 1 {
        try tr.addClass("border-b border-gray-200 dark:border-gray-700")
      } else {
        try tr.addClass("font-bold bg-gray-50 dark:bg-gray-700/50")
      }

      for (colIndex, cellData) in rowData.enumerated() {
        let td = try tr.appendElement("td")
        try td.addClass("py-3 px-2")

        // Top-align pricing row cells
        if index == rows.count - 1 {
          try td.addClass("align-top")
        }

        if colIndex == 0 {
          try td.addClass("font-medium")
        } else {
          try td.addClass("text-center")
        }

        // Add light background to Sidecar column (last column)
        if colIndex == lastColumnIndex {
          try td.addClass("bg-green-50/60 dark:bg-green-950/60")
        }

        // Apply color coding to checkmarks and X's with rounded square backgrounds
        if cellData == "✓" {
          let span = try td.appendElement("span")
          try span.text("✓")
          // Add shadow and thicker styling for Sidecar column (last column)
          if colIndex == lastColumnIndex {
            try span.addClass("inline-flex items-center justify-center w-7 h-7 text-green-600 dark:text-green-400 bg-green-600/10 dark:bg-green-400/10 border-2 border-green-600/40 dark:border-green-400/40 rounded font-black shadow-lg")
          } else {
            try span.addClass("inline-flex items-center justify-center w-7 h-7 text-green-600 dark:text-green-400 bg-green-600/5 dark:bg-green-400/5 border border-green-600/20 dark:border-green-400/20 rounded font-bold")
          }
        } else if cellData == "✗" {
          let span = try td.appendElement("span")
          try span.text("✗")
          try span.addClass("text-red-600 dark:text-red-400 font-bold")
        } else if cellData.starts(with: "✗") {
          // Handle cases like "✗ (ads in free)"
          let span = try td.appendElement("span")
          try span.html(cellData.replacingOccurrences(of: "✗", with: "<span class=\"text-red-600 dark:text-red-400 font-bold\">✗</span>"))
        } else {
          try td.html(cellData)
        }
      }
    }
  }
}
