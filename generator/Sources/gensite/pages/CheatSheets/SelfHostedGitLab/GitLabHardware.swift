import Foundation

import Slipstream

// MARK: - Parts

/// The day every price on this page was read off its Amazon listing.
let priceVerifiedOn = "August 6, 2026"

/// A purchasable component, linked through the same Amazon affiliate tag the
/// scanner table uses.
///
/// Prices are the buybox price read live from the listing on
/// ``priceVerifiedOn``, never estimated. Memory and NAND in particular have
/// roughly doubled over the past year, so a remembered price is a wrong price.
struct Part: Sendable {
  let name: String
  let detail: String
  /// Buybox price in USD, verified on ``priceVerifiedOn``.
  let price: Double
  let asin: String
  /// Set when the part is bought somewhere other than Amazon.
  let vendorURL: String?

  init(name: String, detail: String, price: Double, asin: String = "", vendorURL: String? = nil) {
    self.name = name
    self.detail = detail
    self.price = price
    self.asin = asin
    self.vendorURL = vendorURL
  }

  var url: URL? {
    if let vendorURL {
      return URL(string: vendorURL)
    }
    return URL(string: "https://www.amazon.com/dp/\(asin)?&_encoding=UTF8&tag=electricsidecar-20&linkCode=ur2&linkId=website-gitlab&camp=1789&creative=9325")
  }

  /// Always shows cents. This is a buy list, not an estimate.
  var priceLabel: String {
    let cents = Int((price * 100).rounded()) % 100
    return usdLabel(price.rounded(.down)) + String(format: ".%02d", cents)
  }
}

/// Whole dollars with a thousands separator: 1312 -> "$1,312".
func usdLabel(_ value: Double) -> String {
  let whole = Int(value.rounded())
  let digits = Array(String(abs(whole)))
  var grouped: [String] = []
  for (offset, digit) in digits.reversed().enumerated() {
    if offset > 0, offset % 3 == 0 {
      grouped.append(",")
    }
    grouped.append(String(digit))
  }
  return "$" + grouped.reversed().joined()
}

/// What a machine is for, which decides where GitLab and the runners land.
enum RigKind: String, Sendable {
  case linux
  case macos
}

/// One complete way to buy the box.
struct Rig: Sendable {
  /// Ties the card to the calculator profile that recommends it.
  let slug: String
  /// Short enough that a basket of four still fits on one line.
  let shortName: String
  let badge: String
  let name: String
  let pitch: String
  let accentClass: String
  let kind: RigKind
  /// Physical cores, used to compare turnaround against a hosted runner.
  let cores: Int
  /// Gigabytes of RAM, which is what the gitlab.rb tuning keys scale from.
  let ram: Int
  /// Everything you have to buy for this option to work.
  let parts: [Part]
  let specs: [(String, String)]
  /// Watts drawn at idle and during a busy pipeline.
  let idleWatts: Int
  let loadWatts: Int
  let tradeoffs: [String]

  /// Apple sells Macs on 12 interest-free instalments, which moves break-even.
  var financeable: Bool { kind == .macos }

  var total: Double {
    parts.reduce(0) { $0 + $1.price }
  }

  var totalLabel: String {
    usdLabel(total)
  }

  /// Idling most of the time, building some of it.
  var averageWatts: Int {
    (idleWatts * 2 + loadWatts) / 3
  }
}

// MARK: - The three rigs

let gitLabRigs: [Rig] = [
  Rig(
    slug: "budget",
    shortName: "Mini PC",
    badge: "Cheapest way in",
    name: "Mini PC",
    pitch: "Eight cores, 24 GB and a terabyte for under $600, which is the whole argument on this page for the price of a few months of seats. Nothing to assemble and quiet enough for a shelf.",
    accentClass: "cs-s1",
    kind: .linux,
    cores: 8,
    ram: 24,
    parts: [
      Part(
        name: "Beelink SER5 Max",
        detail: "Ryzen 7 7735U · 8C/16T · 24 GB LPDDR5 · 1 TB NVMe Gen4",
        price: 579.00,
        asin: "B0CBTDGCFB"
      ),
    ],
    specs: [
      ("CPU", "8 cores / 16 threads"),
      ("RAM", "24 GB LPDDR5"),
      ("Disk", "1 TB NVMe"),
      ("Net", "Gigabit"),
      ("Size", "5 × 5 × 1.6 in"),
    ],
    idleWatts: 11,
    loadWatts: 55,
    tradeoffs: [
      "The memory is soldered, so 24 GB is what you have forever. It clears GitLab's 16 GB baseline with room for the graphics share these chips carve out of system RAM.",
      "Gigabit rather than 2.5 GbE, which only matters if you move large artifacts around.",
    ]
  ),
  Rig(
    slug: "mini",
    shortName: "Bigger mini",
    badge: "Room to grow",
    name: "The same, but bigger",
    pitch: "The same box one size up: eight cores instead of six, 32 GB instead of 16, DDR5 instead of DDR4. Still nothing to assemble, still quiet enough for a shelf.",
    accentClass: "cs-s1",
    kind: .linux,
    cores: 8,
    ram: 32,
    parts: [
      Part(
        name: "Beelink SER8",
        detail: "Ryzen 7 8745HS · 8C/16T · 32 GB DDR5 · 1 TB NVMe · 2.5 GbE",
        price: 859.00,
        asin: "B0D4T68GFB"
      ),
    ],
    specs: [
      ("CPU", "8 cores / 16 threads"),
      ("RAM", "32 GB DDR5"),
      ("Disk", "1 TB NVMe"),
      ("Net", "2.5 GbE"),
      ("Size", "5 × 5 × 1.6 in"),
    ],
    idleWatts: 12,
    loadWatts: 65,
    tradeoffs: [
    ]
  ),
  Rig(
    slug: "tower",
    shortName: "Tower",
    badge: "Best value · real build",
    name: "Rackmount tower",
    pitch: "Fourteen cores for the price of eight, because it is <b>DDR4 on LGA 1700</b> instead of DDR5. This is an actual parts list from an actual build, not a spec sheet. 3U, so it slides into a rack next to the switch.",
    accentClass: "cs-s2",
    kind: .linux,
    cores: 14,
    ram: 32,
    parts: [
      Part(name: "Intel Core i5-13500", detail: "14 cores (6P + 8E), 24 MB cache, 65 W. Tray, so add a cooler", price: 279.99, asin: "B0FKC3P6PS"),
      Part(name: "MSI PRO B760M-P DDR4", detail: "LGA 1700 micro-ATX, 2× M.2 Gen4", price: 94.51, asin: "B0BZ9T4KF6"),
      Part(name: "Corsair Vengeance LPX 32 GB DDR4-3200", detail: "2 × 16 GB, half the price of the same capacity in DDR5", price: 249.99, asin: "B07RW6Z692"),
      Part(name: "WD_BLACK SN850X 1 TB", detail: "NVMe Gen4 with heatsink, plenty for a repo host", price: 249.99, asin: "B0B7CPSN2K"),
      Part(name: "Rosewill RSV-Z3200U", detail: "3U rackmount chassis, 6 × 3.5\" bays, E-ATX", price: 129.99, asin: "B0B84VH17N"),
      Part(name: "ASRock PRO-650G", detail: "650 W, 80+ Gold, ATX 3.1", price: 49.99, asin: "B0FSTL4VDZ"),
      Part(name: "VEVOR 1U PDU", detail: "8 outlets, switched, fits a 19\" rack", price: 37.90, asin: "B0DH27XMJ3"),
    ],
    specs: [
      ("CPU", "14 cores / 20 threads"),
      ("RAM", "32 GB DDR4 (128 GB max)"),
      ("Disk", "1 TB NVMe"),
      ("Form", "3U rackmount"),
      ("Build", "About 90 minutes"),
    ],
    idleWatts: 35,
    loadWatts: 130,
    tradeoffs: [
      "The tray CPU ships without a cooler. Boxed retail runs about <b>$295</b> at Newegg, cheaper than Amazon's boxed listing.",
    ]
  ),
  Rig(
    slug: "mac",
    shortName: "Mac mini",
    badge: "macOS CI only",
    name: "Mac mini M4",
    pitch: "Hosted macOS minutes bill at ten times the Linux rate, so App Store builds are where a GitHub invoice grows fastest. Buy the base config and give it one job: running the macOS runner.",
    accentClass: "cs-s4",
    kind: .macos,
    cores: 10,
    ram: 16,
    parts: [
      Part(
        name: "Mac mini (M4, 2024)",
        detail: "10C CPU / 10C GPU · 16 GB unified · 256 GB SSD",
        price: 799.00,
        vendorURL: "https://www.apple.com/shop/buy-mac/mac-mini"
      ),
    ],
    specs: [
      ("CPU", "10 cores"),
      ("RAM", "16 GB unified"),
      ("Disk", "256 GB"),
      ("Net", "Gigabit (10 GbE option)"),
      ("Size", "5 × 5 × 2 in"),
    ],
    idleWatts: 4,
    loadWatts: 65,
    tradeoffs: [
      "GitLab Omnibus has no macOS package. The server lives on the Linux box; this one only runs the runner.",
    ]
  ),
]

/// Things every option needs, counted the same way the machines are.
struct Accessory: Sendable {
  let slug: String
  /// Short enough that a basket of four still fits on one line.
  let shortName: String
  let part: Part
  /// Draw added to the running total when one is in the basket.
  let watts: Int
  /// What it can actually carry, so the page can size it against the load.
  let capacityWatts: Int
}

let gitLabAccessories: [Accessory] = [
  Accessory(
    slug: "ups",
    shortName: "UPS",
    part: Part(
      name: "APC BX850M",
      detail: "850 VA / 510 W, enough for every build on this page. Has a USB data port, so the machine can shut itself down cleanly before the battery runs out. Drive it with apcupsd or NUT.",
      price: 161.99,
      asin: "B06WP9Q8ZN"
    ),
    watts: 6,
    capacityWatts: 510
  ),
  Accessory(
    slug: "ups-big",
    shortName: "Big UPS",
    part: Part(
      name: "CyberPower CP1500PFCLCD",
      detail: "1500 VA / 1000 W pure sine, also over USB. Only worth it once you are running several machines off one battery.",
      price: 239.95,
      asin: "B00429N19W"
    ),
    watts: 9,
    capacityWatts: 1000
  ),
  Accessory(
    slug: "pdu",
    shortName: "PDU",
    part: Part(
      name: "VEVOR 1U PDU",
      detail: "Switched rack PDU, if you are not already getting one with the tower.",
      price: 37.90,
      asin: "B0DH27XMJ3"
    ),
    watts: 0,
    capacityWatts: 1800
  ),
]

// MARK: - Views

/// A price list with an affiliate link per line.
///
/// Inside a rig the spec table above already says what each part is, so the
/// per-part detail line is suppressed there.
struct PartsTable: View {
  let parts: [Part]

  var body: some View {
    Div {
      Table {
        TableBody {
          for part in parts {
            PartRow(part: part)
          }
        }
      }
      .className("cs-table cs-parts")
    }
    .className("cs-scroll")
  }
}

private struct PartRow: View {
  let part: Part

  var body: some View {
    TableRow {
      TableCell {
        Link(part.name, destination: part.url, openInNewTab: true)
      }
      TableCell { DOMString(part.priceLabel) }
        .className("num")
    }
  }
}

/// One accessory line, with the same stepper the rig cards use.
struct AccessoryRow: View {
  let accessory: Accessory

  var body: some View {
    Div {
      Div {
        Link(accessory.part.name, destination: accessory.part.url, openInNewTab: true)
        Span { DOMString(accessory.part.priceLabel) }
          .className("cs-accessory-price")
      }
      .className("cs-accessory-head")

      Div { DOMString(accessory.part.detail) }
        .className("cs-sub")

      RawHTML("""
<div class="cs-qty" data-rig="\(accessory.slug)" data-name="\(accessory.shortName)" data-capex="\(Int(accessory.part.price.rounded()))" data-watts="\(accessory.watts)" data-capacity="\(accessory.capacityWatts)">
  <span>How many</span>
  <button type="button" data-step="-1" aria-label="One fewer \(accessory.part.name)">&minus;</button>
  <b data-qty>0</b>
  <button type="button" data-step="1" aria-label="One more \(accessory.part.name)">+</button>
</div>
""")
    }
    .className("cs-accessory")
  }
}

struct RigTile: View {
  let rig: Rig

  var body: some View {
    Div {
      H3 { DOMString(rig.name) }

      Div {
        Span { DOMString(rig.badge) }
          .className("cs-rig-badge")

        Div {
          DOMString(rig.totalLabel)
          Small { DOMString(rig.parts.count == 1 ? "buybox price" : "for \(rig.parts.count) parts") }
        }
        .className("cs-price")

        Text { RawHTML(rig.pitch) }

        DescriptionList {
          for (term, value) in rig.specs {
            DescriptionTerm { DOMString(term) }
            DefinitionDescription { DOMString(value) }
          }
          DescriptionTerm { DOMString("Power") }
          DefinitionDescription { DOMString("\(rig.idleWatts) W idle · \(rig.loadWatts) W building") }
        }
        .className("cs-spec")

        PartsTable(parts: rig.parts)

        RawHTML("""
<div class="cs-qty" data-rig="\(rig.slug)" data-name="\(rig.shortName)" data-capex="\(Int(rig.total.rounded()))" data-watts="\(rig.averageWatts)" data-finance="\(rig.financeable)" data-cores="\(rig.cores)" data-ram="\(rig.ram)" data-kind="\(rig.kind.rawValue)">
  <span>How many</span>
  <button type="button" data-step="-1" aria-label="One fewer \(rig.name)">&minus;</button>
  <b data-qty>0</b>
  <button type="button" data-step="1" aria-label="One more \(rig.name)">+</button>
</div>
\(rig.financeable ? """
<label class="cs-finance">
  <input type="checkbox" id="f-finance">
  <span>Apple Card, 12 months at 0%<em>Spreads the cost instead of paying day one</em></span>
</label>
""" : "")
""")

        Div {
          for item in rig.tradeoffs {
            Note(item)
          }
        }
      }
      .className("cs-rig")
    }
    .className("cs-tile \(rig.accentClass)")
  }
}
