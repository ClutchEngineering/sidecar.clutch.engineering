import Foundation

import Slipstream

extension Home {
  struct CommunityKnowledgebase: View {
    var body: some View {
      Comment("Community knowledge base")
      FeatureRow(imageOnLeft: false) {
        FeatureScreenshot(
          URL(string: "/gfx/community.png")!,
          accessibilityLabel: "Sidecar's community is open to the public"
        )
      } explanation: {
        Div {
          FeatureCardHeader("Community Knowledge Base")
          FeatureCardSubheadline("Discuss common issues and share OBD parameters")
        }
        .textAlignment(.center)

        SubfeatureRow {
          Subfeature(
            "Creative commons licensed",
            image: URL(string: "/gfx/symbols/cc.png")!,
            accessibilityLabel: "Creative commons"
          )
          Subfeature(
            "Join discussions in the forums",
            image: URL(string: "/gfx/symbols/person.3.fill.png")!,
            accessibilityLabel: "Forums"
          )
        }

        SubfeatureRow {
          Subfeature(
            "Participate in the community",
            image: URL(string: "/gfx/symbols/books.vertical.fill.png")!,
            accessibilityLabel: "Participate"
          )
        }

        Div {
          Text("Community features require a GitHub account")
          Link(URL(string: "https://github.com/OBDb")!, openInNewTab: true) {
            Text("github.com/OBDb")
          }
        }
        .fontSize(.extraSmall)
        .textAlignment(.center)
      }
    }
  }
}
