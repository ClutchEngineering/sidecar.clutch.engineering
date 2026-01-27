import Foundation
import Slipstream
import SwiftSoup

// MARK: - Scanner Row

struct ScannerRow: View {
  let scanner: Scanner
  let country: Country

  var body: some View {
    TableRow {
      // Product cell with name + links
      TableCell {
        Div {
          Text(scanner.name)
        }
        Div {
          if let url = scanner.amazonURL(for: country) {
            Link("Amazon", destination: url)
              .textColor(.blue, darkness: 500)
              .underline()
          }
          if let altURL = scanner.alternateVendorURL,
             let altName = scanner.alternateVendorName {
            if scanner.amazonURL(for: country) != nil {
              Span(" · ")
            }
            Link(altName, destination: altURL)
              .textColor(.blue, darkness: 500)
              .underline()
          }
        }
      }
      .className("pl-2 md:pl-4 py-2")

      // Supported status
      TableCell {
        if scanner.isSupported {
          Text("✔")
        } else {
          Span {
            Text("✘")
          }
          .textColor(.red, darkness: 500)
        }
      }
      .className("pl-2 md:pl-4 py-2 text-center")

      // Connection type
      TableCell {
        Text(scanner.connectionType.rawValue)
      }
      .className("pl-2 md:pl-4 py-2")

      // PIDs/second
      TableCell {
        if let pids = scanner.pidsPerSecond {
          if scanner.isFastScanner {
            Span {
              Text(pids)
            }
            .bold()
          } else {
            Text(pids)
          }
        } else {
          Text("Unknown")
        }
      }
      .className("pl-2 md:pl-4 py-2")

      // Price
      TableCell {
        let price = scanner.prices[country]!
        Text(price.displayValue)
        if price.isUnavailable {
          Div {
            Text("Unavailable")
          }
          .italic()
          .fontSize(.extraSmall)
        }
      }
      .className("px-2 md:px-4 py-2")
    }
    .className("text-xs md:text-base")
  }
}

// MARK: - Scanner Table

struct ScannerTable: View {
  let country: Country

  var body: some View {
    Table {
      TableHeader {
        TableRow {
          TableHeaderCell { Text("Product") }
            .className("pl-2 md:pl-4 py-2")
          TableHeaderCell { Text("Supported") }
            .className("pl-2 md:pl-4 py-2")
          TableHeaderCell { Text("Type") }
            .className("pl-2 md:pl-4 py-2")
          TableHeaderCell { Text("PIDs / second") }
            .className("pl-2 md:pl-4 py-2")
          TableHeaderCell { Text("Price (\(country.currencyLabel))") }
            .className("px-2 md:px-4 py-2")
        }
        .className("bg-gray-800 text-xs md:text-base text-white text-left")
      }

      TableBody {
        for scanner in scannersForCountry(country) {
          ScannerRow(scanner: scanner, country: country)
        }
      }
      .className("text-xs md:text-base")
    }
    .className("table-auto border-collapse border border-gray-800 mt-4")
  }
}

// MARK: - Scanner Tables (main container with country selector)

struct ScannerTables: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    // Country selector (radio buttons) - must be sibling of product divs for CSS to work
    for country in Country.allCases {
      let input = try container.appendElement("input")
      try input.attr("type", "radio")
      try input.attr("name", "country")
      try input.attr("id", country.radioInputID)
      try input.addClass("mr-2")
      if country == .us {
        try input.attr("checked", "")
      }

      let label = try container.appendElement("label")
      try label.attr("for", country.radioInputID)
      try label.addClass("mr-4")
      try label.text("\(country.displayName) \(country.flag)")
    }

    // Product tables wrapped in divs with CSS IDs
    for country in Country.allCases {
      let div = try container.appendElement("div")
      try div.attr("id", country.productsDivID)

      // Render the table into this div
      try ScannerTable(country: country).render(div, environment: environment)
    }
  }
}
