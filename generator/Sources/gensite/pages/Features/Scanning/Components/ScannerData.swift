import Foundation

// MARK: - Country

enum Country: String, CaseIterable, Hashable {
  case us
  case be
  case br
  case ca
  case de
  case `in`
  case uk

  var flag: String {
    switch self {
    case .us: return "🇺🇸"
    case .be: return "🇧🇪"
    case .br: return "🇧🇷"
    case .ca: return "🇨🇦"
    case .de: return "🇩🇪"
    case .in: return "🇮🇳"
    case .uk: return "🇬🇧"
    }
  }

  var displayName: String {
    switch self {
    case .us: return "United States"
    case .be: return "Belgium"
    case .br: return "Brazil"
    case .ca: return "Canada"
    case .de: return "Germany"
    case .in: return "India"
    case .uk: return "UK"
    }
  }

  var currencyLabel: String {
    switch self {
    case .us: return "USD"
    case .be: return "EUR"
    case .br: return "BRL"
    case .ca: return "CAD"
    case .de: return "EUR"
    case .in: return "INR"
    case .uk: return "GBP"
    }
  }

  var amazonDomain: String {
    switch self {
    case .us: return "amazon.com"
    case .be: return "amazon.com.be"
    case .br: return "amazon.com.br"
    case .ca: return "amazon.ca"
    case .de: return "amazon.de"
    case .in: return "amazon.in"
    case .uk: return "amazon.co.uk"
    }
  }

  /// The radio input ID used by the CSS sibling selectors
  var radioInputID: String {
    switch self {
    case .us: return "us"
    case .be: return "be"
    case .br: return "br"
    case .ca: return "canada"
    case .de: return "germany"
    case .in: return "india"
    case .uk: return "uk"
    }
  }

  /// The products div ID used by the CSS sibling selectors
  var productsDivID: String {
    "\(rawValue)-products"
  }
}

// MARK: - Connection Type

enum ConnectionType: String {
  case btle = "BTLE"
  case wifi = "Wi-Fi"
  case classicBluetooth = "Classic Bluetooth"
}

// MARK: - Price

struct Price: Comparable {
  let displayValue: String
  let sortValue: Double
  let isUnavailable: Bool

  init(displayValue: String, sortValue: Double, isUnavailable: Bool = false) {
    self.displayValue = displayValue
    self.sortValue = sortValue
    self.isUnavailable = isUnavailable
  }

  static func < (lhs: Price, rhs: Price) -> Bool {
    lhs.sortValue < rhs.sortValue
  }

  /// Marks a scanner as unavailable in a country while preserving sort order and price display
  static func unavailable(_ price: Price) -> Price {
    Price(displayValue: price.displayValue, sortValue: price.sortValue, isUnavailable: true)
  }

  static func usd(_ value: Double) -> Price {
    Price(displayValue: "$\(formatNumber(value, decimalPlaces: 2))", sortValue: value)
  }

  static func eur(_ value: Double) -> Price {
    Price(displayValue: "€\(formatNumber(value, decimalPlaces: 2))", sortValue: value)
  }

  static func brl(_ value: Double) -> Price {
    // Brazilian format uses comma as decimal separator
    Price(displayValue: "R$\(formatBrazilianNumber(value))", sortValue: value)
  }

  static func cad(_ value: Double) -> Price {
    Price(displayValue: "$\(formatNumber(value, decimalPlaces: 2))", sortValue: value)
  }

  static func inr(_ value: Double) -> Price {
    Price(displayValue: "₹\(formatIndianNumber(value))", sortValue: value)
  }

  static func gbp(_ value: Double) -> Price {
    Price(displayValue: "£\(formatNumber(value, decimalPlaces: 2))", sortValue: value)
  }

  private static func formatNumber(_ value: Double, decimalPlaces: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = decimalPlaces
    formatter.maximumFractionDigits = decimalPlaces
    formatter.locale = Locale(identifier: "en_US")
    return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.\(decimalPlaces)f", value)
  }

  private static func formatBrazilianNumber(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: "pt_BR")
    return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
  }

  private static func formatIndianNumber(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: "en_IN")
    return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
  }
}

// MARK: - Scanner

struct Scanner {
  let name: String
  let asin: String?
  let isSupported: Bool
  let connectionType: ConnectionType
  let pidsPerSecond: String?
  let isFastScanner: Bool
  let prices: [Country: Price]
  let alternateVendorURL: URL?
  let alternateVendorName: String?

  init(
    name: String,
    asin: String? = nil,
    isSupported: Bool,
    connectionType: ConnectionType,
    pidsPerSecond: String? = nil,
    isFastScanner: Bool = false,
    prices: [Country: Price],
    alternateVendorURL: URL? = nil,
    alternateVendorName: String? = nil
  ) {
    self.name = name
    self.asin = asin
    self.isSupported = isSupported
    self.connectionType = connectionType
    self.pidsPerSecond = pidsPerSecond
    self.isFastScanner = isFastScanner
    self.prices = prices
    self.alternateVendorURL = alternateVendorURL
    self.alternateVendorName = alternateVendorName
  }

  func amazonURL(for country: Country) -> URL? {
    guard let asin,
          prices[country] != nil else {
      return nil
    }
    return URL(string: "https://www.\(country.amazonDomain)/dp/\(asin)?&_encoding=UTF8&tag=electricsidecar-20&linkCode=ur2&linkId=website-scanning&camp=1789&creative=9325")
  }
}

// MARK: - Scanner Data

let testedScanners: [Scanner] = [
  Scanner(name: "ELM327 Bluetooth OBD2 Scanner", asin: "B0BVLZ27TL", isSupported: false, connectionType: .btle, pidsPerSecond: "up to 4.7/s", prices: [
    .us: .unavailable(.usd(17.99)), .br: .brl(153.48),
  ]),
  Scanner(name: "Micro Mechanic", asin: "B07FKDFYZ3", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 11/s", prices: [
    .us: .unavailable(.usd(18.99)), .ca: .cad(39.54), .in: .inr(7530.78),
  ]),
  Scanner(name: "Veepeak Mini WiFi", asin: "B00WPW6BAE", isSupported: true, connectionType: .wifi, pidsPerSecond: "up to 28/s", prices: [
    .us: .unavailable(.usd(20.99)), .ca: .cad(29.99), .in: .inr(5275.20), .uk: .gbp(19.99),
  ]),
  Scanner(name: "Vgate iCar Pro Bluetooth 3.0", asin: "B06XGBKG8X", isSupported: false, connectionType: .btle, prices: [
    .us: .usd(25.99), .be: .eur(20.99), .ca: .cad(27.90), .de: .eur(20.00), .in: .inr(8792.47), .uk: .gbp(17.78),
  ]),
  Scanner(name: "LELink^2", asin: "B0755N61PW", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .usd(35.00), .be: .eur(90.54), .br: .brl(365.30), .de: .eur(58.48), .uk: .gbp(29.00),
  ]),
  Scanner(name: "Vgate iCar Pro Wi-Fi", asin: "B06XGB4QL7", isSupported: true, connectionType: .wifi, pidsPerSecond: "up to 29/s", prices: [
    .us: .usd(29.99), .be: .eur(25.49), .ca: .cad(37.99), .de: .eur(29.99), .in: .inr(13699), .uk: .gbp(22.99),
  ]),
  Scanner(name: "OBD2 Scanner Reader", asin: "B0D44C1F7Y", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 13/s", prices: [
    .us: .usd(29.99), .br: .brl(207.48), .ca: .cad(22.94),
  ]),
  Scanner(name: "Vgate iCar Pro Bluetooth 4.0", asin: "B06XGB4873", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 34/s", isFastScanner: true, prices: [
    .us: .usd(31.99), .be: .eur(30.79), .ca: .cad(39.99), .in: .inr(15999), .uk: .gbp(22.06),
  ]),
  Scanner(name: "Vgate iCar Pro 2S", asin: "B0CYZRMCK9", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 34/s", isFastScanner: true, prices: [
    .us: .usd(33.99), .be: .eur(83.39), .ca: .cad(45.99), .in: .inr(9715),
  ]),
  Scanner(name: "Veepeak OBDCheck BLE", asin: "B073XKQQQW", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .usd(34.99), .br: .brl(527.54), .ca: .cad(44.99), .de: .eur(39.99), .in: .inr(16999), .uk: .gbp(39.99),
  ]),
  Scanner(name: "Infocar", asin: "B089NFZ81P", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .unavailable(.usd(39.00)),
  ]),
  Scanner(name: "AUTOPHIX", asin: "B07WT82MT4", isSupported: false, connectionType: .btle, prices: [
    .us: .usd(42.99), .be: .eur(71.52), .ca: .cad(69.00), .de: .eur(49.99), .uk: .gbp(25.99),
  ]),
  Scanner(name: "BLCKTEC 410 Telematics Lite", asin: "B0BTZRXX2G", isSupported: false, connectionType: .btle, prices: [
    .us: .usd(39.99),
  ]),
  Scanner(name: "Vgate vLinker BM+", asin: "B08BR4KY1G", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 34/s", isFastScanner: true, prices: [
    .us: .usd(43.99), .ca: .cad(53.99),
  ]),
  Scanner(name: "Carista", asin: "B0BBS73F6J", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .usd(29.99), .be: .eur(33.99), .ca: .cad(54.99), .de: .eur(42.99), .in: .inr(4999), .uk: .gbp(44.99),
  ]),
  Scanner(name: "Veepeak OBDCheck BLE+", asin: "B076XVQMVS", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .usd(44.99), .be: .eur(47.99), .ca: .cad(51.99), .de: .eur(49.99), .in: .inr(29699), .uk: .gbp(44.99),
  ]),
  Scanner(name: "Konnwei", asin: "B0C53GMRXL", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .unavailable(.usd(49.99)), .ca: .cad(136.59), .in: .inr(10999),
  ]),
  Scanner(name: "FIXD", asin: "B013RIQMEO", isSupported: false, connectionType: .btle, prices: [
    .us: .usd(39.99), .be: .eur(87.22), .br: .brl(400.95), .ca: .cad(66.99),
  ]),
  Scanner(name: "nonda", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 6.7/s", prices: [.us: .usd(59.99)],
    alternateVendorURL: URL(string: "https://www.nonda.co/products/smart-vehicle-health-monitor-mini"), alternateVendorName: "nonda.co"),
  Scanner(name: "vLinker FS", asin: "B0BZTXV6MZ", isSupported: true, connectionType: .classicBluetooth, pidsPerSecond: "up to 58/s", isFastScanner: true, prices: [
    .us: .usd(59.99), .be: .eur(164.62), .ca: .cad(85.99), .in: .inr(15992),
  ]),
  Scanner(name: "Vgate vLinker MC+", asin: "B088LW211V", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 34/s", isFastScanner: true, prices: [
    .us: .usd(59.89), .be: .eur(54.99), .ca: .cad(75.99), .de: .eur(59.99), .in: .inr(25599), .uk: .gbp(54.89),
  ]),
  Scanner(name: "vLinker MS", asin: "B0D6YQX4R8", isSupported: true, connectionType: .classicBluetooth, pidsPerSecond: "up to 62/s", isFastScanner: true, prices: [
    .us: .usd(69.99), .be: .eur(148.07), .ca: .cad(95.99),
  ]),
  Scanner(name: "OBDLink CX", asin: "B08NFLL3NT", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .usd(79.95), .ca: .cad(114.95), .de: .eur(99.99), .uk: .gbp(84.95),
  ]),
  Scanner(name: "TopScan", asin: "B0C3QQYQ1B", isSupported: false, connectionType: .classicBluetooth, prices: [
    .us: .usd(79.99), .be: .eur(79.99), .ca: .cad(99.99), .de: .eur(79.99), .uk: .gbp(69.99),
  ]),
  Scanner(name: "UniCarScan", asin: "B09WVJPF2F", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .usd(85.99), .be: .eur(79.99), .de: .eur(79.99), .uk: .gbp(67.99),
  ]),
  Scanner(name: "OBDLink LX", asin: "B00H9S71LW", isSupported: false, connectionType: .btle, prices: [
    .us: .usd(89.95), .be: .eur(109.99), .br: .brl(1689.00), .ca: .cad(129.95), .uk: .gbp(95.50),
  ]),
  Scanner(name: "BLCKTEC 430", asin: "B0C2JQH5NY", isSupported: false, connectionType: .btle, prices: [.us: .usd(89.99)]),
  Scanner(name: "Bouncie", asin: "B07H8NS5MS", isSupported: false, connectionType: .classicBluetooth, prices: [
    .us: .usd(89.99), .be: .eur(184.04), .ca: .cad(119.99),
  ]),
  Scanner(name: "MeatPi WICAN Pro", isSupported: true, connectionType: .wifi, pidsPerSecond: "Up to 153/s", prices: [.us: .usd(97.00)],
    alternateVendorURL: URL(string: "https://www.meatpi.com/products/wican-pro"), alternateVendorName: "MeatPi"),
  Scanner(name: "MeatPi WICAN Pro", isSupported: true, connectionType: .btle, pidsPerSecond: "Up to 17/s", prices: [.us: .usd(97.00)],
    alternateVendorURL: URL(string: "https://www.meatpi.com/products/wican-pro"), alternateVendorName: "MeatPi"),
  Scanner(name: "OBDeleven", asin: "B08K94L4JS", isSupported: false, connectionType: .btle, prices: [
    .us: .usd(87.89), .be: .eur(76.42), .ca: .cad(122.26), .de: .eur(95.66), .uk: .gbp(84.39),
  ]),
  Scanner(name: "BlueDriver", asin: "B00652G4TS", isSupported: false, connectionType: .btle, prices: [
    .us: .usd(119.95), .be: .eur(142.48), .br: .brl(962.27), .in: .inr(20700), .uk: .gbp(114.00),
  ]),
  Scanner(name: "DND ECHO", asin: "B0CZ8X334R", isSupported: false, connectionType: .classicBluetooth, prices: [
      .us: .usd(99.99), .be: .eur(238.15), .uk: .gbp(191.11),
    ],
    alternateVendorURL: URL(string: "https://obd.ai/products/dnd-echo-professional-obdil-diagnostic-tool"), alternateVendorName: "obd.ai"),
  Scanner(name: "SPARQ OBD2", asin: "B0FTNLTRWS", isSupported: true, connectionType: .btle, pidsPerSecond: "up to 17/s", prices: [
    .us: .usd(199.00), .uk: .gbp(119.60),
  ]),
  Scanner(name: "OBDLink MX+", asin: "B07JFRFJG6", isSupported: true, connectionType: .classicBluetooth, pidsPerSecond: "up to 27/s", isFastScanner: true, prices: [
    .us: .usd(139.95), .ca: .cad(209.95), .de: .eur(169.99), .in: .inr(32999), .uk: .gbp(147.50),
  ]),
]

// MARK: - Helper Functions

func scannersForCountry(_ country: Country) -> [Scanner] {
  testedScanners
    .filter { $0.prices[country] != nil }
    .sorted { ($0.prices[country]?.sortValue ?? 0) < ($1.prices[country]?.sortValue ?? 0) }
}
