import Foundation
import Slipstream

struct News_2025_10_23_FeatureTable: View {

  struct Feature: Hashable {
    let title: String
    let anchor: String
  }

  let column1Features: [Feature] = [
    Feature(title: "Navigation instructions on the phone", anchor: "#navigation-instructions-on-the-phone"),
    Feature(title: "Volvo Connected Accounts", anchor: "#volvo-connected-accounts"),
    Feature(title: "Pinnable locations", anchor: "#pinnable-locations"),
    Feature(title: "Custom place labels (Home/Work)", anchor: "#custom-place-labels"),
    Feature(title: "Intelligent Quick Destinations", anchor: "#intelligent-quick-destinations"),
    Feature(title: "Personalized search engine", anchor: "#personalized-search-engine"),
  ]
  let column2Features: [Feature] = [
    Feature(title: "iCloud backup status", anchor: "#icloud-backup-status"),
    Feature(title: "Improved onboarding notifications", anchor: "#improved-onboarding-notifications"),
    Feature(title: "Photos in the place sheet", anchor: "#photos-in-the-place-sheet"),
    Feature(title: "PID Detector can now scan 11-bit CAN networks", anchor: "#pid-detector-can-now-scan-11-bit-can-networks"),
    Feature(title: "Spooky holiday decorations", anchor: "#spooky-holiday-decorations"),
  ]
  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      List {
        ForEach(column1Features, id: \.self) { feature in
          ListItem {
            Link(feature.title, destination: URL(string: feature.anchor))
              .textColor(.link, darkness: 700)
              .textColor(.link, darkness: 400, condition: .dark)
              .fontWeight(600)
              .underline(condition: .hover)
          }
        }
      }
      .padding(.left, 16)
      .listStyle(.disc)
      List {
        ForEach(column2Features, id: \.self) { feature in
          ListItem {
            Link(feature.title, destination: URL(string: feature.anchor))
              .textColor(.link, darkness: 700)
              .textColor(.link, darkness: 400, condition: .dark)
              .fontWeight(600)
              .underline(condition: .hover)
          }
        }
      }
      .padding(.left, 16)
      .listStyle(.disc)
    }
    .padding(.bottom, 16)
  }
}
