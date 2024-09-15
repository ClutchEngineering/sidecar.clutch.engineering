import Foundation

import Slipstream

struct Home: View {
  var body: some View {
    Page(
      "Your personal automotive assistant",
      path: "/",
      description: "OBD scanner and trip logger for iOS. Stay in tune with your car both on and off the road.",
      keywords: [
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      Hero()
      FocusOnTheJourney()
      FeaturesOverview()

      // Features
      TripLogger()
      MaintenanceMinder()
      Tiers()
      DeeplyIntegrated()
      CommunityKnowledgebase()
      ThoughtfullyAccessible()
      IntelligentGlovebox()

      TakeItForASpin()
    }
  }
}
