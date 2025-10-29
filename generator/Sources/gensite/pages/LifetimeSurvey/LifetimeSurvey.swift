import Foundation
import Slipstream
import SwiftSoup

struct LifetimeSurvey: View {
  var body: some View {
    Page(
      "Lifetime Survey",
      path: "/lifetime-survey/",
      description: "Gathering feedback about a potential lifetime purchase for Sidecar.",
      keywords: [
        "OBD-II",
        "pricing",
        "survey",
        "lifetime unlock",
        "CarPlay",
      ],
      scripts: [URL(string: "/scripts/lifetime-survey.js")]
    ) {
      Container {
        Section {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/lifetime.png"))

            Div {
              H1("Sidecar lifetime")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Exploring a new one-time purchase option.")
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
      }

      VStack(alignment: .leading, spacing: 32) {
        NarrowContainer {
          Article("""
          > I've heard the feedback loud and clear: many of you love Sidecar but want to avoid adding
          > yet another subscription to your life. Totally fair, and to make Sidecar more approachable
          > for everyone I'm exploring offering a lifetime unlock of Sidecar's core features.
          >
          > — Jeff
          """)
        }

        NarrowContainer {
          Article("""
          ## Product comparison

          Sidecar is most comparable to an OBD scanner app at its heart, so it's perhaps helpful to compare the features Sidecar provides to some other products in the App Store.
          """)
        }

        NarrowContainer {
          Picture {
            Source(URL(string: "/gfx/survey/comparison-dark.png"), colorScheme: .dark)
            Image(URL(string: "/gfx/survey/comparison-light.png"))
              .accessibilityLabel("Feature comparison between OBD apps")
          }
        }

        // Comparison Table
        NarrowContainer {
          VStack(alignment: .leading, spacing: 16) {
            H3("OBD app feature comparison")
              .fontSize(.large)
              .bold()

            ComparisonTable(
              headers: ["Feature", "OBD Fusion", "Car Scanner", "Sidecar"],
              rows: [
                ["Unlimited OBD Scanning", "✓", "✓", "✓"],
                ["Standard PIDs (70+)", "✓", "✓", "✓"],
                ["Extended PIDs", "✓ (+$15/model)", "✓", "✓"],
                ["OBD Terminal", "✗", "✓", "✓"],
                ["CarPlay Widgets", "✗", "✗", "✓"],
                ["PID Detector", "✗", "✗", "✓"],
                ["Integrated trip logger", "✗", "✗", "✓"],
                ["Powerful navigation app", "✗", "✗", "✓"],
                ["Export scan sessions in SQLite", "✗", "✗", "✓"],
                ["iCloud Sync", "✗", "✗", "✓"],
                ["Scan session analysis", "✗", "✗", "✓"],
                ["<a href=\"https://github.com/obdb/\" class=\"text-blue-600 dark:text-blue-400 hover:underline\" target=\"_blank\" rel=\"noopener noreferrer\">Open source PIDs</a>", "✗", "✗", "✓"],
                ["Apple Watch app", "✗", "✗", "✓"],
                ["Apple Watch complications", "✗", "✗", "✓"],
                ["Widgets", "✗", "✗", "✓"],
                ["<a href=\"/shortcuts/\" class=\"text-blue-600 dark:text-blue-400 hover:underline\">Shortcuts</a>", "✗", "✗", "✓"],
                ["", "", "", ""],
                ["Pricing*", "$9.99 lifetime<br/><span class=\"text-xs text-gray-600 dark:text-gray-400 font-normal\">+$15/model</span>", "$7.99 lifetime", "TBD<br/><span class=\"text-xs text-gray-600 dark:text-gray-400 font-normal\">** $6.99/month</span>"]
              ]
            )

            VStack(alignment: .leading, spacing: 4) {
              Text("* All prices in USD")
              Text("** Current subscription price")
            }
            .fontSize(.extraSmall)
            .textColor(.text, darkness: 500)
            .textColor(.text, darkness: 400, condition: .dark)
          }
          .padding(.vertical, 16)
          .padding(.horizontal, 24)
          .background(.white)
          .background(.palette(.gray, darkness: 800), condition: .dark)
          .border(.palette(.gray, darkness: 200), width: 1)
          .border(.palette(.gray, darkness: 700), width: 1, condition: .dark)
          .cornerRadius(8)
        }
      }
      .margin(.bottom, 32)

        // Context section
      Container {
        VStack(alignment: .leading, spacing: 16) {
          H3("What lifetime would unlock")
            .fontSize(.large)
            .bold()
            .margin(.top, 8)

          List {
            ListItem {
              Text("One-time payment. All features below would be yours forever.")
            }
            ListItem {
              Text("Unlimited OBD-II scanning (no time limits)")
            }
            ListItem {
              Text("Unlimited trip logging")
            }
            ListItem {
              Text("Navigation widgets")
            }
            ListItem {
              Text("PID Detector")
            }
            ListItem {
              Text("PID Terminal")
            }
            ListItem {
              Text("Scan session analysis")
            }
            ListItem {
              Text("Real-time CarPlay widgets")
            }
          }
          .listStyle(.disc)
          .margin(.left, 16)

          FeatureShowcase()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(.white)
        .background(.palette(.gray, darkness: 800), condition: .dark)
        .border(.palette(.gray, darkness: 200), width: 1)
        .border(.palette(.gray, darkness: 700), width: 1, condition: .dark)
        .cornerRadius(8)
      }
      .margin(.bottom, 32)

      VStack(alignment: .leading, spacing: 32) {
        // What's NOT included section
        NarrowContainer {
          VStack(alignment: .leading, spacing: 16) {
            Article("""
            ## What lifetime would not unlock

            Sidecar is increasingly relying on compute-intensive backend services to power the Sidecar experience, and some of these features would still require an ongoing subscription (but at a lower price).
            """)

            List {
              ListItem {
                Text("Range isochrones")
              }
              ListItem {
                Text("Connected accounts")
              }
              ListItem {
                Text("Clutch, the in-car assistant")
              }
              ListItem {
                Text("Future cloud-based features")
              }
            }
            .listStyle(.disc)
            .margin(.left, 16)
          }
          .padding(.vertical, 16)
          .padding(.horizontal, 24)
          .background(.white)
          .background(.palette(.gray, darkness: 800), condition: .dark)
          .border(.palette(.gray, darkness: 200), width: 1)
          .border(.palette(.gray, darkness: 700), width: 1, condition: .dark)
          .cornerRadius(8)
        }

        NarrowContainer {
          Form {
            Div {
              VStack(spacing: 24) {
                Article("""
                ## Pricing survey

                For each question, enter the price that best represents your view.
                """)

                // Hidden token field
                TokenField()

                // Currency selector
                VStack(alignment: .leading, spacing: 8) {
                  RequiredLabel("Select your currency")

                  CurrencySelector()
                }

                // Question 1: Too cheap (quality concern)
                FormField(
                  id: "too-cheap",
                  label: "At what price would a lifetime unlock be so inexpensive that you'd question the quality?",
                  placeholder: ""
                )

                // Question 2: Cheap/Bargain (great value)
                FormField(
                  id: "bargain",
                  label: "At what price would a lifetime unlock be a bargain — a great buy for the money?",
                  placeholder: ""
                )

                // Question 3: Getting expensive (still consider)
                FormField(
                  id: "expensive-but-ok",
                  label: "At what price would a lifetime unlock start to get expensive, but you'd still consider buying?",
                  placeholder: ""
                )

                // Question 4: Too expensive (won't buy)
                FormField(
                  id: "too-expensive",
                  label: "At what price would a lifetime unlock be too expensive — you would not consider buying?",
                  placeholder: ""
                )

                // Question 5: OBD features usage frequency
                VStack(alignment: .leading, spacing: 8) {
                  RequiredLabel("How often do you use Sidecar's OBD features?")

                  VStack(alignment: .leading, spacing: 8) {
                    RadioOption(id: "obd-daily", name: "obd-frequency", value: "Daily", label: "Daily")
                    RadioOption(id: "obd-weekly", name: "obd-frequency", value: "Weekly", label: "Weekly")
                    RadioOption(id: "obd-monthly", name: "obd-frequency", value: "Monthly", label: "Monthly")
                    RadioOption(id: "obd-rarely", name: "obd-frequency", value: "Rarely", label: "Rarely")
                    RadioOption(id: "obd-trial-expired", name: "obd-frequency", value: "Trial Expired", label: "My subscription expired")
                    RadioOption(id: "obd-never", name: "obd-frequency", value: "Never", label: "Never used")
                  }
                }

                // Question 6: Trip logger usage frequency
                VStack(alignment: .leading, spacing: 8) {
                  RequiredLabel("How often do you use Sidecar's trip logger?")

                  VStack(alignment: .leading, spacing: 8) {
                    RadioOption(id: "trip-daily", name: "trip-frequency", value: "Daily", label: "Daily")
                    RadioOption(id: "trip-weekly", name: "trip-frequency", value: "Weekly", label: "Weekly")
                    RadioOption(id: "trip-monthly", name: "trip-frequency", value: "Monthly", label: "Monthly")
                    RadioOption(id: "trip-rarely", name: "trip-frequency", value: "Rarely", label: "Rarely")
                    RadioOption(id: "trip-never", name: "trip-frequency", value: "Never", label: "Never used")
                  }
                }

                // Question 7: CarPlay widgets usage frequency
                VStack(alignment: .leading, spacing: 8) {
                  RequiredLabel("How often do you use Sidecar's CarPlay widgets?")

                  VStack(alignment: .leading, spacing: 8) {
                    RadioOption(id: "carplay-daily", name: "carplay-frequency", value: "Daily", label: "Daily")
                    RadioOption(id: "carplay-weekly", name: "carplay-frequency", value: "Weekly", label: "Weekly")
                    RadioOption(id: "carplay-monthly", name: "carplay-frequency", value: "Monthly", label: "Monthly")
                    RadioOption(id: "carplay-rarely", name: "carplay-frequency", value: "Rarely", label: "Rarely")
                    RadioOption(id: "carplay-no-access", name: "carplay-frequency", value: "No CarPlay", label: "Don't have CarPlay")
                    RadioOption(id: "carplay-never", name: "carplay-frequency", value: "Never", label: "Never used")
                  }
                }

                // Question 8: Current subscription plan
                VStack(alignment: .leading, spacing: 8) {
                  RequiredLabel("What's your current subscription status?")

                  VStack(alignment: .leading, spacing: 8) {
                    RadioOption(id: "plan-sidecar-plus", name: "subscription-plan", value: "Sidecar+", label: "Sidecar+ (active)")
                    RadioOption(id: "plan-scanplan", name: "subscription-plan", value: "ScanPlan", label: "ScanPlan (active)")
                    RadioOption(id: "plan-cancelled", name: "subscription-plan", value: "Cancelled", label: "Cancelled subscription")
                    RadioOption(id: "plan-none", name: "subscription-plan", value: "None", label: "Never subscribed")
                  }
                }

                // Conditional question for cancelled subscriptions
                CancellationReasonField()

                // Conditional question for never subscribed users
                NeverSubscribedReasonField()

                // Required fields note
                Div {
                  Text("* Required fields")
                }
                .textColor(.text, darkness: 600)
                .textColor(.text, darkness: 400, condition: .dark)
                .fontSize(.small)

                // Submit button
                SubmitButton()

                // Error message container
                Div {
                  Text("")
                }
                .id("error-message")
                .classNames(["bg-red-50", "dark:bg-red-900/20", "border", "border-red-300", "dark:border-red-700", "text-red-700", "dark:text-red-400", "text-sm", "p-3", "rounded-md", "hidden"])
              }
            }
            .id("survey-form")
            .padding(.vertical, 24)
            .padding(.horizontal, 24)
            .background(.white)
            .background(.palette(.gray, darkness: 800), condition: .dark)
            .border(.palette(.gray, darkness: 200), width: 1)
            .border(.palette(.gray, darkness: 700), width: 1, condition: .dark)
            .cornerRadius(8)
          }
        }

        NarrowContainer {
          // Success message container
          VStack(alignment: .leading, spacing: 16) {
            Text("Thank you for your feedback! Your input will help me determine whether to offer a Lifetime option and for how much.")
              .fontSize(.large)
              .fontWeight(.medium)

            VStack(alignment: .center, spacing: 8) {
              Image(URL(string: "/gfx/buddha.jpg"))
                .accessibilityLabel("Buddha")
                .cornerRadius(8)
                .modifier(ClassModifier(add: "max-w-xs"))

              Text("Buddha also says thank you!")
                .fontSize(.extraLarge)
                .italic()
            }
            .margin(.horizontal, .auto)
          }
          .padding(.vertical, 24)
          .padding(.horizontal, 24)
          .background(.palette(.green, darkness: 50))
          .background(.palette(.green, darkness: 900).opacity(0.2), condition: .dark)
          .border(.palette(.green, darkness: 200), width: 1)
          .border(.palette(.green, darkness: 700), width: 1, condition: .dark)
          .cornerRadius(8)
          .textColor(.text, darkness: 900)
          .textColor(.text, darkness: 100, condition: .dark)
        }
        .id("success-message")
        .classNames(["hidden"])
      }
      .margin(.bottom, 32)
    }
  }
}

private struct FormField: View {
  let id: String
  let label: String
  let placeholder: String

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let fieldWrapper = try container.appendElement("div")
    try fieldWrapper.addClass("space-y-2")

    let labelElement = try fieldWrapper.appendElement("label")
    try labelElement.attr("for", id)
    try labelElement.addClass("block font-bold text-lg")

    let labelText = try labelElement.appendElement("span")
    try labelText.text(label)

    let asterisk = try labelElement.appendElement("span")
    try asterisk.text(" *")
    try asterisk.addClass("text-red-600 dark:text-red-400")

    let inputWrapper = try fieldWrapper.appendElement("div")
    try inputWrapper.addClass("relative")

    let dollarSign = try inputWrapper.appendElement("span")
    try dollarSign.text("$")
    try dollarSign.addClass("absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 dark:text-gray-400 text-lg currency-symbol")

    let input = try inputWrapper.appendElement("input")
    try input.attr("type", "number")
    try input.attr("id", id)
    try input.attr("name", id)
    try input.attr("placeholder", placeholder)
    try input.attr("min", "0")
    try input.attr("max", "100")
    try input.attr("step", "1")
    try input.attr("required", "required")
    try input.addClass("w-full py-3 pl-8 pr-3 border border-gray-300 dark:border-gray-600 rounded-md text-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white")

    // Add error message container
    let errorContainer = try fieldWrapper.appendElement("div")
    try errorContainer.attr("id", "\(id)-error")
    try errorContainer.addClass("bg-red-50 dark:bg-red-900/20 border border-red-300 dark:border-red-700 text-red-700 dark:text-red-400 text-sm mt-2 p-3 rounded-md hidden")
  }
}

private struct RequiredLabel: View {
  let text: String

  init(_ text: String) {
    self.text = text
  }

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let label = try container.appendElement("div")
    try label.addClass("block font-bold text-lg")

    let labelText = try label.appendElement("span")
    try labelText.text(text)

    let asterisk = try label.appendElement("span")
    try asterisk.text(" *")
    try asterisk.addClass("text-red-600 dark:text-red-400")
  }
}

private struct RadioOption: View {
  let id: String
  let name: String
  let value: String
  let label: String

  var body: some View {
    Div {
      RadioButton(name: name, value: value, id: id, required: true)
        .classNames(["mr-2", "cursor-pointer"])

      Label(label, for: id)
        .classNames(["cursor-pointer"])
    }
    .classNames(["flex", "items-center"])
  }
}

private struct CurrencySelector: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let select = try container.appendElement("select")
    try select.attr("id", "currency")
    try select.attr("name", "currency")
    try select.addClass("w-full py-3 px-3 border border-gray-300 dark:border-gray-600 rounded-md text-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white")

    let currencies = [
      ("USD", "USD - US Dollar"),
      ("EUR", "EUR - Euro"),
      ("GBP", "GBP - British Pound"),
      ("JPY", "JPY - Japanese Yen"),
      ("AUD", "AUD - Australian Dollar"),
      ("CAD", "CAD - Canadian Dollar"),
      ("CHF", "CHF - Swiss Franc"),
      ("CNY", "CNY - Chinese Yuan"),
      ("SEK", "SEK - Swedish Krona"),
      ("NZD", "NZD - New Zealand Dollar"),
      ("MXN", "MXN - Mexican Peso"),
      ("SGD", "SGD - Singapore Dollar"),
      ("HKD", "HKD - Hong Kong Dollar"),
      ("NOK", "NOK - Norwegian Krone"),
      ("KRW", "KRW - South Korean Won"),
      ("TRY", "TRY - Turkish Lira"),
      ("RUB", "RUB - Russian Ruble"),
      ("INR", "INR - Indian Rupee"),
      ("BRL", "BRL - Brazilian Real"),
      ("ZAR", "ZAR - South African Rand"),
      ("DKK", "DKK - Danish Krone"),
      ("PLN", "PLN - Polish Złoty"),
      ("TWD", "TWD - Taiwan Dollar"),
      ("THB", "THB - Thai Baht"),
      ("IDR", "IDR - Indonesian Rupiah"),
      ("MYR", "MYR - Malaysian Ringgit"),
      ("PHP", "PHP - Philippine Peso"),
      ("CZK", "CZK - Czech Koruna"),
      ("ILS", "ILS - Israeli Shekel"),
      ("CLP", "CLP - Chilean Peso"),
      ("PKR", "PKR - Pakistani Rupee"),
      ("VND", "VND - Vietnamese Dong"),
      ("AED", "AED - UAE Dirham"),
      ("SAR", "SAR - Saudi Riyal"),
      ("QAR", "QAR - Qatari Riyal"),
      ("KWD", "KWD - Kuwaiti Dinar"),
      ("BHD", "BHD - Bahraini Dinar"),
      ("OMR", "OMR - Omani Rial"),
      ("JOD", "JOD - Jordanian Dinar"),
      ("EGP", "EGP - Egyptian Pound"),
      ("LBP", "LBP - Lebanese Pound"),
      ("MAD", "MAD - Moroccan Dirham"),
      ("TND", "TND - Tunisian Dinar"),
      ("DZD", "DZD - Algerian Dinar"),
      ("IQD", "IQD - Iraqi Dinar"),
      ("LYD", "LYD - Libyan Dinar"),
      ("NGN", "NGN - Nigerian Naira"),
      ("KES", "KES - Kenyan Shilling"),
      ("GHS", "GHS - Ghanaian Cedi"),
      ("ARS", "ARS - Argentine Peso"),
      ("COP", "COP - Colombian Peso"),
      ("PEN", "PEN - Peruvian Sol"),
      ("UYU", "UYU - Uruguayan Peso"),
      ("VES", "VES - Venezuelan Bolívar"),
      ("HUF", "HUF - Hungarian Forint"),
      ("RON", "RON - Romanian Leu"),
      ("BGN", "BGN - Bulgarian Lev"),
      ("HRK", "HRK - Croatian Kuna"),
      ("ISK", "ISK - Icelandic Króna"),
      ("UAH", "UAH - Ukrainian Hryvnia"),
      ("BDT", "BDT - Bangladeshi Taka"),
      ("LKR", "LKR - Sri Lankan Rupee"),
      ("NPR", "NPR - Nepalese Rupee"),
      ("AFN", "AFN - Afghan Afghani"),
      ("IRR", "IRR - Iranian Rial"),
      ("AMD", "AMD - Armenian Dram"),
      ("AZN", "AZN - Azerbaijani Manat"),
      ("GEL", "GEL - Georgian Lari"),
      ("KZT", "KZT - Kazakhstani Tenge"),
      ("UZS", "UZS - Uzbekistani Som"),
      ("MMK", "MMK - Myanmar Kyat"),
      ("LAK", "LAK - Lao Kip"),
      ("KHR", "KHR - Cambodian Riel"),
      ("BND", "BND - Brunei Dollar"),
      ("MOP", "MOP - Macanese Pataca"),
      ("XOF", "XOF - West African CFA Franc"),
      ("XAF", "XAF - Central African CFA Franc"),
      ("ETB", "ETB - Ethiopian Birr"),
      ("UGX", "UGX - Ugandan Shilling"),
      ("TZS", "TZS - Tanzanian Shilling"),
      ("RWF", "RWF - Rwandan Franc"),
      ("MUR", "MUR - Mauritian Rupee"),
      ("MWK", "MWK - Malawian Kwacha"),
      ("ZMW", "ZMW - Zambian Kwacha"),
      ("BWP", "BWP - Botswana Pula"),
      ("NAD", "NAD - Namibian Dollar"),
      ("SZL", "SZL - Swazi Lilangeni"),
      ("LSL", "LSL - Lesotho Loti"),
      ("ANG", "ANG - Netherlands Antillean Guilder"),
      ("AWG", "AWG - Aruban Florin"),
      ("BBD", "BBD - Barbadian Dollar"),
      ("BMD", "BMD - Bermudian Dollar"),
      ("BSD", "BSD - Bahamian Dollar"),
      ("BZD", "BZD - Belize Dollar"),
      ("FJD", "FJD - Fijian Dollar"),
      ("GYD", "GYD - Guyanese Dollar"),
      ("HTG", "HTG - Haitian Gourde"),
      ("JMD", "JMD - Jamaican Dollar"),
      ("KYD", "KYD - Cayman Islands Dollar"),
      ("PGK", "PGK - Papua New Guinean Kina"),
      ("SBD", "SBD - Solomon Islands Dollar"),
      ("SRD", "SRD - Surinamese Dollar"),
      ("TOP", "TOP - Tongan Paʻanga"),
      ("TTD", "TTD - Trinidad and Tobago Dollar"),
      ("WST", "WST - Samoan Tala"),
      ("YER", "YER - Yemeni Rial"),
      ("SYP", "SYP - Syrian Pound"),
      ("SDG", "SDG - Sudanese Pound"),
      ("SOS", "SOS - Somali Shilling"),
      ("DOP", "DOP - Dominican Peso"),
      ("GTQ", "GTQ - Guatemalan Quetzal"),
      ("HNL", "HNL - Honduran Lempira"),
      ("NIO", "NIO - Nicaraguan Córdoba"),
      ("PAB", "PAB - Panamanian Balboa"),
      ("CRC", "CRC - Costa Rican Colón"),
      ("BOB", "BOB - Bolivian Boliviano"),
      ("PYG", "PYG - Paraguayan Guaraní"),
      ("ALL", "ALL - Albanian Lek"),
      ("BAM", "BAM - Bosnia-Herzegovina Convertible Mark"),
      ("MKD", "MKD - Macedonian Denar"),
      ("RSD", "RSD - Serbian Dinar"),
      ("MDL", "MDL - Moldovan Leu"),
      ("BYN", "BYN - Belarusian Ruble"),
      ("TMT", "TMT - Turkmenistani Manat"),
      ("TJS", "TJS - Tajikistani Somoni"),
      ("KGS", "KGS - Kyrgyzstani Som"),
      ("MNT", "MNT - Mongolian Tögrög"),
      ("BTN", "BTN - Bhutanese Ngultrum"),
      ("MVR", "MVR - Maldivian Rufiyaa"),
      ("AOA", "AOA - Angolan Kwanza"),
      ("MZN", "MZN - Mozambican Metical"),
      ("CVE", "CVE - Cape Verdean Escudo"),
      ("GMD", "GMD - Gambian Dalasi"),
      ("GNF", "GNF - Guinean Franc"),
      ("LRD", "LRD - Liberian Dollar"),
      ("SLL", "SLL - Sierra Leonean Leone"),
      ("STN", "STN - São Tomé and Príncipe Dobra"),
      ("SCR", "SCR - Seychellois Rupee"),
      ("MRU", "MRU - Mauritian Ouguiya"),
      ("CDF", "CDF - Congolese Franc"),
      ("BIF", "BIF - Burundian Franc"),
      ("DJF", "DJF - Djiboutian Franc"),
      ("ERN", "ERN - Eritrean Nakfa"),
      ("KMF", "KMF - Comorian Franc"),
      ("MGA", "MGA - Malagasy Ariary"),
      ("SSP", "SSP - South Sudanese Pound"),
      ("VUV", "VUV - Vanuatu Vatu"),
      ("XPF", "XPF - CFP Franc")
    ]

    for (code, label) in currencies {
      let option = try select.appendElement("option")
      try option.attr("value", code)
      try option.text(label)
      if code == "USD" {
        try option.attr("selected", "selected")
      }
    }
  }
}

private struct TokenField: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let input = try container.appendElement("input")
    try input.attr("type", "hidden")
    try input.attr("id", "survey-token")
    try input.attr("name", "token")
    try input.attr("value", "")
  }
}

private struct CancellationReasonField: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let fieldWrapper = try container.appendElement("div")
    try fieldWrapper.attr("id", "cancellation-reason-container")
    try fieldWrapper.addClass("space-y-2 hidden")

    let labelElement = try fieldWrapper.appendElement("label")
    try labelElement.attr("for", "cancellation-reason")
    try labelElement.text("Why did you cancel your subscription? (Optional)")
    try labelElement.addClass("block font-bold text-lg")

    let textarea = try fieldWrapper.appendElement("textarea")
    try textarea.attr("id", "cancellation-reason")
    try textarea.attr("name", "cancellation-reason")
    try textarea.attr("rows", "4")
    try textarea.attr("placeholder", "Please share your reason for cancelling...")
    try textarea.addClass("w-full py-3 px-3 border border-gray-300 dark:border-gray-600 rounded-md text-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white resize-vertical")
  }
}

private struct NeverSubscribedReasonField: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let fieldWrapper = try container.appendElement("div")
    try fieldWrapper.attr("id", "never-subscribed-reason-container")
    try fieldWrapper.addClass("space-y-2 hidden")

    let labelElement = try fieldWrapper.appendElement("label")
    try labelElement.attr("for", "never-subscribed-reason")
    try labelElement.text("What has kept you from subscribing to Sidecar? (Optional)")
    try labelElement.addClass("block font-bold text-lg")

    let textarea = try fieldWrapper.appendElement("textarea")
    try textarea.attr("id", "never-subscribed-reason")
    try textarea.attr("name", "never-subscribed-reason")
    try textarea.attr("rows", "4")
    try textarea.attr("placeholder", "Please share what has kept you from subscribing...")
    try textarea.addClass("w-full py-3 px-3 border border-gray-300 dark:border-gray-600 rounded-md text-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white resize-vertical")
  }
}

private struct SubmitButton: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let button = try container.appendElement("button")
    try button.attr("type", "button")
    try button.attr("id", "submit-button")
    try button.text("Submit Responses")
    try button.addClass("w-full py-3 px-6 bg-blue-600 text-white text-lg font-bold rounded-lg hover:bg-blue-700 transition-colors cursor-pointer")
  }
}
