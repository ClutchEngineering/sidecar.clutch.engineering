import Foundation

import Slipstream

extension Home {
  struct Tiers: View {
    var body: some View {
      Comment("Tiers")
      Container {
        VStack(alignment: .center, spacing: 24) {
          H2("Available plans")
            .fontSize(.extraExtraExtraLarge)
            .textAlignment(.center)
            .bold()
            .fontDesign("rounded")
          AppStoreLink()
            .margin(.horizontal, .auto)

          ResponsiveStack(spacing: 32) {
            Div {
              Div {
                H3("Free")
                  .bold()
                  .fontSize(.extraLarge)
                Paragraph("Basic features")
              }
              .textAlignment(.center)
              .margin(.bottom, 16)

              List {
                ListItem {
                  Text("Simulated vehicles")
                }
                ListItem {
                  Text("Offline vehicles")
                }
                ListItem {
                  Text("Vehicle issues")
                }
                ListItem {
                  Text("Vehicle recalls")
                }
                ListItem {
                  Text("Test Connected Accounts")
                }
                ListItem {
                  Text("30 seconds free OBD scanning")
                }
              }
              .padding(.left, 16)
              .listStyle(.disc)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)

            Puck {
              Div {
                Div {
                  H3("ScanPass")
                    .bold()
                    .fontSize(.extraLarge)
                  Paragraph("On demand OBD")
                }
                .textAlignment(.center)
                .margin(.bottom, 16)

                List {
                  ListItem {
                    Text("Great for quick diagnostics")
                  }
                  ListItem {
                    Text("Pay as you need it")
                  }
                  ListItem {
                    Text("70+ standard PIDs")
                  }
                  ListItem {
                    Text("Growing community of ")
                    Link("Extended PIDs", destination: URL(string: "/scanning/extended-pids")!)
                      .textColor(.blue, darkness: 500)
                      .underline(condition: .hover)
                  }
                }
                .padding(.left, 16)
                .listStyle(.disc)
                .margin(.bottom, 16)

                Div {
                  Paragraph("24 hours: $0.99 USD")
                  Paragraph("1 week: $4.99 USD")
                }
                .bold()
                .textAlignment(.center)
              }
              .background(.white)
              .background(.zinc, darkness: 800, condition: .dark)
              .clipsToBounds()
              .cornerRadius(.large)
              .padding(.vertical, 16)
              .padding(.horizontal, 24)
              .frame(width: 350)
            }

            Puck {
              Div {
                Div {
                  H3("Subscription")
                    .bold()
                    .fontSize(.extraLarge)
                  Paragraph("Unlock all features")
                }
                .textAlignment(.center)
                .margin(.bottom, 16)

                HStack(alignment: .top, spacing: 8) {
                  List {
                    ListItem {
                      Text("Trip logger")
                    }
                    ListItem {
                      Text("Recall notices")
                    }
                    ListItem {
                      Text("Document scanner")
                    }
                    ListItem {
                      Text("Historical statistics")
                    }
                    ListItem {
                      Text("OBD scanning")
                    }
                  }
                  .padding(.left, 16)
                  .listStyle(.disc)

                  List {
                    ListItem {
                      Text("Storage mode")
                    }
                    ListItem {
                      Text("Widgets")
                    }
                    ListItem {
                      Text("Live Activities")
                    }
                    ListItem {
                      Text("Siri Shortcuts")
                    }
                    ListItem {
                      Text("Connected Accounts (Beta)")
                    }
                  }
                  .padding(.left, 16)
                  .listStyle(.disc)
                }
                .margin(.bottom, 16)

                Div {
                  Paragraph("$6.99 USD/month")
                  Paragraph("2-week free trial")
                }
                .bold()
                .textAlignment(.center)
              }
              .classNames(["bg-gradient-to-tl", "from-cyan-500", "to-blue-500"])
              .textColor(.white)
              .clipsToBounds()
              .cornerRadius(.large)
              .padding(.vertical, 16)
              .padding(.horizontal, 24)
            }
          }
          .alignItems(.center)
          .alignItems(.start, condition: .desktop)
        }
      }
    }
  }
}
