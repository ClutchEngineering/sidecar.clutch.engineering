import Foundation

import Slipstream

struct NavigationBar: View {
  var body: some View {
    Comment("Navigation bar")
    ContentContainer {
      ResponsiveStack(.y) {
        Link(URL(string: "/")!) {
          HStack {
            Image(URL(string: "/gfx/site-logo.png")!)
              .colorInvert(condition: .dark)
              .accessibilityLabel("Sidecar logo")
              .frame(height: 24)
              .frame(height: 32, condition: .desktop)
              .margin(.right, 4)
              .margin(.right, 8, condition: .desktop)
            Text("Sidecar")
              .fontDesign("rounded")
              .fontSize(.small)
              .fontSize(.base, condition: .desktop)
              .bold()
              .fontLeading(.none)
              .fontLeading(.tight, condition: .desktop)
          }
          .alignItems(.center, condition: .desktop)
          .justifyContent(.center)
        }
        .opacity(0.70)
        .opacity(1.0, condition: .hover)
        .transition(.opacity)

        Navigation {
          HStack {
            NavigationLink(URL(string: "/shortcuts"), text: "Shortcuts")
            NavigationLink(URL(string: "/scanning"), text: "Scanning")
            NavigationLink(URL(string: "/help"), text: "Help")
            NavigationLink(URL(string: "/privacy-policy"), text: "Privacy")
            NavigationLink(URL(string: "/supported-cars"), text: "Supported Cars")
            AppStoreLink()
              .hidden()
              .display(.block, condition: .desktop)
          }
          .alignItems(.center)
          .justifyContent(.between)
          .flexGap(.x, width: 16, condition: .desktop)
        }
      }
      .padding(.vertical, 8)
      .border(.init(.gray, darkness: 300), edges: .bottom)
      .border(.init(.gray, darkness: 500), edges: .bottom, condition: .dark)
      .alignItems(.stretch)
      .alignItems(.center, condition: .desktop)
      .flexGap(.y, width: 4, condition: .mobileOnly)
      .justifyContent(.between)
      .textColor("sidecar-gray")
      .textColor(.white, condition: .dark)
    }
  }
}
