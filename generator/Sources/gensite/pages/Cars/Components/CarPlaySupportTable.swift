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
                H3("Apple CarPlay support")
                    .fontSize(.large)
                    .fontSize(.extraExtraLarge, condition: .desktop)
                    .bold()
                    .fontDesign("rounded")
                    .margin(.top, 32)

                Table {
                    TableHeader {
                        HeaderCell {
                            Text("Model years")
                        }
                        HeaderCell(isLast: true) {
                            Text("CarPlay support")
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

                            Bordered(showTrailingBorder: false) {
                                TableCell {
                                    Text("✓ Supported")
                                        .bold()
                                        .textColor(.green, darkness: 600)
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
                    Text("* From Apple's CarPlay support site: CarPlay support is either standard or available as an option on many new 2016 cars and later, with some manufacturers offering software updates for earlier models. Some models may support CarPlay or car keys only in certain configurations, and not all models are available in all areas. CarPlay support is subject to change. See your dealer for details.")
                      .italic()
                }
                .fontSize(.extraSmall)
                .textColor(.zinc, darkness: 700)
                .textColor(.zinc, darkness: 300, condition: .dark)
                .italic()
            }
            .margin(.bottom, 32)
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
