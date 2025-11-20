import Foundation
import Slipstream
import VehicleSupport

/// Component to display CarPlay support information for a vehicle
struct CarPlaySupportTable: View {
    let make: String
    let modelName: String
    let carPlaySupport: CarPlayModelSupport?

    var body: some View {
        if let support = carPlaySupport {
            VStack(alignment: .leading, spacing: 16) {
                H3("Apple CarPlay Support")
                    .fontSize(.large)
                    .fontSize(.extraExtraLarge, condition: .desktop)
                    .bold()
                    .fontDesign("rounded")
                    .margin(.top, 32)

                Table {
                    TableHeader {
                        HeaderCell {
                            Text("Model Years")
                        }
                        HeaderCell {
                            Text("CarPlay Support")
                        }
                        HeaderCell(isLast: true) {
                            Text("Connection Type")
                        }
                    }
                    .background(.gray, darkness: 100)
                    .background(.zinc, darkness: 950, condition: .dark)

                    TableBody {
                        EnvironmentAwareRow(isLastRow: true) {
                            Bordered {
                                TableCell {
                                    Text(support.yearRangeString)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)

                            Bordered {
                                TableCell {
                                    VStack(alignment: .center, spacing: 4) {
                                        Text("✓ Supported")
                                            .bold()
                                            .textColor(.green, darkness: 600)
                                        if support.supportsCarkey == true {
                                            Text("🔑 Car Key")
                                                .fontSize(.extraSmall)
                                                .textColor(.blue, darkness: 600)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)

                            Bordered(showTrailingBorder: false) {
                                TableCell {
                                    connectionTypeText(support: support)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                        }
                    }
                }
                .border(.init(.zinc, darkness: 400), width: 1)
                .border(.init(.zinc, darkness: 600), width: 1, condition: .dark)
                .cornerRadius(.large)

                Paragraph {
                    Text("Note: CarPlay support information is based on Apple's official compatibility list. Actual availability may vary by trim level and region.")
                }
                .fontSize(.small)
                .textColor(.zinc, darkness: 600)
                .textColor(.zinc, darkness: 400, condition: .dark)
                .italic()
            }
            .margin(.bottom, 32)
        }
    }

    @ViewBuilder
    private func connectionTypeText(support: CarPlayModelSupport) -> some View {
        if let wireless = support.wireless, wireless {
            Text("Wireless")
        } else if let wired = support.wired, wired {
            Text("Wired (USB)")
        } else {
            // Default assumption based on year
            if support.startYear >= 2020 {
                Text("Wired/Wireless (varies by trim)")
            } else {
                Text("Wired (USB)")
            }
        }
    }
}

/// Compact inline CarPlay badge for use in summaries
struct CarPlayBadge: View {
    let supported: Bool

    var body: some View {
        if supported {
            Span {
                Text("CarPlay ✓")
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.green, darkness: 100)
            .textColor(.green, darkness: 700)
            .fontSize(.small)
            .bold()
            .border(.init(.green, darkness: 300), width: 1)
            .cornerRadius(.small)
        }
    }
}
