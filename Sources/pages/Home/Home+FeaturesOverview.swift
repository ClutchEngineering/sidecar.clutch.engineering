import Foundation

import Slipstream

extension Home {
  struct FeaturesOverview: View {
    var body: some View {
      Comment("Features at a glance")
      ContentContainer {
        H2("Features at a glance")
          .fontSize(.fourXLarge)
          .bold()
          .fontDesign("rounded")
          .margin(.bottom, 48)
          .textAlignment(.center)

        Div {
          FeatureCard {
            HStack {
              Image(URL(string: "/gfx/symbols/obdii.plug.filled.png")!)
                .accessibilityLabel("OBD plug required")
                .colorInvert(condition: .dark)
                .frame(width: 40)
                .frame(width: 48, condition: .desktop)
              VStack {
                FeatureCardTitle("Easy to understand OBD diagnostics")
                FeatureCardBody("Unlock your car's data.")
              }
            }
            .justifyContent(.between)
            .padding(16)
            .padding([.horizontal, .top], 24, condition: .desktop)
            .padding(.bottom, 20, condition: .desktop)
            Image(URL(string: "/gfx/dtcs.png")!)
              .accessibilityLabel("Read diagnostic information from your car")
              .frame(maxWidth: 384, condition: .desktop)
              .margin(.horizontal, .auto)
              .colorInvert(condition: .dark)
          }
          .gridCellColumns(2)
          .gridCellRows(2)

          FeatureCard {
            HStack {
              VStack {
                FeatureCardTitle("Thoughtfully accessible")
                FeatureCardBody("Optimized for your needs.")
              }
              Image(URL(string: "/gfx/symbols/circle.righthalf.filled.png")!)
                .accessibilityLabel("Dark Mode")
                .frame(width: 28)
                .colorInvert(condition: .dark)
              Image(URL(string: "/gfx/symbols/textformat.size.png")!)
                .accessibilityLabel("Dynamic Type")
                .frame(width: 28)
                .colorInvert(condition: .dark)
              Image(URL(string: "/gfx/symbols/accessibility.png")!)
                .accessibilityLabel("Accessible by design")
                .frame(width: 28)
                .colorInvert(condition: .dark)
            }
            .justifyContent(.between)
            .padding(16)
            .padding(24, condition: .desktop)
          }
          .gridCellColumns(2)

          FeatureCard {
            HStack {
              FeatureCardTitle("iCloud sync")
              Image(URL(string: "/gfx/symbols/icloud.png")!)
                .accessibilityLabel("Sync your private data securely via iCloud")
                .frame(width: 28)
                .colorInvert(condition: .dark)
            }
            .justifyContent(.between)
            Div {
              Image(URL(string: "/gfx/devices.png")!)
                .accessibilityLabel("Sync across iPhone, iPad, and Apple Watch")
                .colorInvert(condition: .dark)
            }
            .padding(.top, 16)
          }
          .padding(16)
          .padding(24, condition: .desktop)

          Div {
            HStack {
              Image(URL(string: "/gfx/symbols/map.fill.png")!)
                .accessibilityLabel("Trip logging")
                .frame(width: 28)
                .colorInvert(condition: .dark)
              FeatureCardTitle("All day trip logs")
            }
            .justifyContent(.between)
            .padding(.horizontal, 8)
            .padding(.horizontal, 12, condition: .desktop)
            .padding(.top, 16)
            .padding(.top, 24, condition: .desktop)
            .padding(.bottom, 12)
            Div {
              Image(URL(string: "/gfx/map.png")!)
                .accessibilityLabel("Sync across iPhone, iPad, and Apple Watch")
            }
          }

          FeatureCard {
            VStack(alignment: .stretch) {
              HStack {
                FeatureCardTitle("Detailed trip statistics and widgets")
                Image(URL(string: "/gfx/symbols/chart.bar.xaxis.png")!)
                  .accessibilityLabel("Charts and graphs")
                  .frame(width: 28)
                  .colorInvert(condition: .dark)
              }
              .justifyContent(.between)
              FeatureCardBody("Personalize your driving experience with customizable widgets.")
            }
            .padding(16)
            .padding(24, condition: .desktop)
          }
          .gridCellColumns(2)

          FeatureCard {
            Image(URL(string: "/gfx/tripwidget.png")!)
              .accessibilityLabel("Intuitive trip statistics created automatically")
          }
          .gridCellColumns(2)
          .gridCellRows(2)

          FeatureCard {
            Image(URL(string: "/gfx/lockscreen.png")!)
              .accessibilityLabel("wi")
          }
          .gridCellColumns(2)

          FeatureCard {
            Div {
              HStack {
                FeatureCardTitle("Recalls")
                Image(URL(string: "/gfx/symbols/exclamationmark.triangle.fill.png")!)
                  .accessibilityLabel("Recall notices")
                  .frame(width: 24)
                  .colorInvert(condition: .dark)
              }
              .justifyContent(.between)
              FeatureCardBody("Stay aware of vehicle safety issues.")
            }
            .padding(12)
            .padding(24, condition: .desktop)
          }

          FeatureCard {
            Div {
              HStack {
                FeatureCardTitle("Documents")
                Image(URL(string: "/gfx/symbols/text.stamp.on.text.rectangle.angled.fill.badge.plus.png")!)
                  .accessibilityLabel("Document storage")
                  .frame(width: 40)
                  .colorInvert(condition: .dark)
              }
              .justifyContent(.between)
              FeatureCardBody("Digitize your glovebox with on-device intelligence.")
            }
            .padding(16)
            .padding(24, condition: .desktop)
          }

          FeatureCard {
            HStack {
              VStack {
                FeatureCardTitle("Powerful OBD terminal")
                FeatureCardBody("Inline results and details help you navigate your car's diagnostics.")
              }
              Image(URL(string: "/gfx/symbols/obdii.plug.filled.png")!)
                .accessibilityLabel("OBD plug required")
                .frame(width: 48)
                .colorInvert(condition: .dark)
            }
            .justifyContent(.between)
            .padding(16)
            .padding([.horizontal, .top], 24, condition: .desktop)
            .padding(.bottom, 20, condition: .desktop)
            Image(URL(string: "/gfx/terminal.png")!)
              .accessibilityLabel("Run OBD commands on the terminal")
              .frame(maxWidth: 384, condition: .desktop)
              .margin(.horizontal, .auto)
          }
          .gridCellColumns(2)
          .gridCellRows(2)

          Div {
            HStack {
              Image(URL(string: "/gfx/symbols/carplay.png")!)
                .accessibilityLabel("Apple CarPlay")
                .frame(width: 28)
                .colorInvert(condition: .dark)
              FeatureCardTitle("OBD + CarPlay = 🎉")
                .padding(.left, 12)
            }
            .justifyContent(.start)
            .padding(.horizontal, 8)
            .padding(.horizontal, 12, condition: .desktop)
            .padding(.top, 12)
            .padding(.top, 20, condition: .desktop)
            .padding(.bottom, 12)
            Image(URL(string: "/gfx/carplay-card.png")!)
              .accessibilityLabel("Navigate with CarPlay")
              .margin(.bottom, 12)
              .margin(.horizontal, .auto)
              .frame(maxWidth: 384, condition: .desktop)
            Image(URL(string: "/gfx/carplay-obd.png")!)
              .accessibilityLabel("Read diagnostic information from CarPlay")
              .margin(.horizontal, .auto)
              .frame(maxWidth: 384, condition: .desktop)
          }
          .gridCellColumns(2)
          .gridCellRows(2)
        }
        .classNames(["grid", "gap-4", "md:grid-cols-4"])
        .alignItems(.start)
        .padding(.horizontal, 16, condition: .desktop)
      }
      .padding(.vertical, 48)
    }
  }
}
