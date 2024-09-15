import Foundation

import Slipstream

struct NavigationBar: View {
  var body: some View {
    Comment("Navigation bar")
    ContentContainer {
      HStack {
        Link(URL(string: "/")!) {
          HStack(alignment: .center) {
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
              .frame(width: 96)
              .fontLeading(.none)
              .fontLeading(.tight, condition: .desktop)
          }
        }
        .opacity(0.70)
        .opacity(1.0, condition: .hover)
        .transition(.opacity)

        Navigation {
          HStack(alignment: .center, spacing: 16) {
            NavigationLink(URL(string: "/shortcuts"), text: "Shortcuts")
            NavigationLink(URL(string: "/scanning"), text: "Scanning")
            NavigationLink(URL(string: "/privacy-policy/"), text: "Privacy")
            NavigationLink(URL(string: "https://electricsidecar.substack.com/"), text: "News")
            AppStoreLink()
              .hidden()
              .display(.block, condition: .desktop)
          }
        }
      }
      .padding(.vertical, 8)
      .border(.init(.gray, darkness: 300), edges: .bottom)
      .border(.init(.gray, darkness: 500), edges: .bottom, condition: .dark)
      .justifyContent(.between)
      .textColor("sidecar-gray")
      .textColor(.white, condition: .dark)
    }
  }
}
