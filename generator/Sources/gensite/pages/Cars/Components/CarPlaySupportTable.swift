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
            Div {
                H3 {
                    "Apple CarPlay Support"
                }
                .fontSize(.largeTitle)
                .fontWeight(.semibold)
                .margin(.top, 32)
                .margin(.bottom, 16)

                Table {
                    TableHead {
                        TableRow {
                            TableHeaderCell {
                                "Model Years"
                            }
                            .padding(.all, 12)
                            .border(.all, width: 1, color: .gray200)
                            .background(.gray50)

                            TableHeaderCell {
                                "CarPlay Support"
                            }
                            .padding(.all, 12)
                            .border(.all, width: 1, color: .gray200)
                            .background(.gray50)

                            TableHeaderCell {
                                "Type"
                            }
                            .padding(.all, 12)
                            .border(.all, width: 1, color: .gray200)
                            .background(.gray50)
                        }
                    }

                    TableBody {
                        TableRow {
                            TableCell {
                                support.yearRangeString
                            }
                            .padding(.all, 12)
                            .border(.all, width: 1, color: .gray200)

                            TableCell {
                                Div {
                                    "✓ Supported"
                                }
                                .fontWeight(.medium)
                                .textColor(.green600)
                            }
                            .padding(.all, 12)
                            .border(.all, width: 1, color: .gray200)

                            TableCell {
                                connectionTypeText(support: support)
                            }
                            .padding(.all, 12)
                            .border(.all, width: 1, color: .gray200)
                        }

                        if support.supportsCarkey == true {
                            TableRow {
                                TableCell {
                                    "Digital Car Key"
                                }
                                .padding(.all, 12)
                                .border(.all, width: 1, color: .gray200)
                                .columnSpan(3)
                                .background(.blue50)

                                Div {
                                    "🔑 Supports digital car keys"
                                }
                                .fontWeight(.medium)
                                .textColor(.blue600)
                            }
                        }
                    }
                }
                .width(.full)
                .border(.all, width: 1, color: .gray300, rounded: true)
                .overflow(.hidden)

                Paragraph {
                    "Note: CarPlay support information is based on Apple's official compatibility list. Actual availability may vary by trim level and region."
                }
                .fontSize(.small)
                .textColor(.gray600)
                .margin(.top, 12)
                .italic()
            }
            .margin(.bottom, 32)
        } else {
            // No CarPlay data available
            EmptyView()
        }
    }

    @ViewBuilder
    private func connectionTypeText(support: CarPlayModelSupport) -> some View {
        if let wireless = support.wireless, wireless {
            Text("Wireless")
                .fontWeight(.medium)
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
                "CarPlay ✓"
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.green100)
            .textColor(.green700)
            .fontSize(.small)
            .fontWeight(.medium)
            .border(.all, width: 1, color: .green300, rounded: true)
        }
    }
}
