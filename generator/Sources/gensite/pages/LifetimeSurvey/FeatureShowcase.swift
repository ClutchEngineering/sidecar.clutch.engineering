import Foundation
import Slipstream

struct FeatureShowcase: View {
  var body: some View {
    ResponsiveStack(spacing: 16) {
      HStack(alignment: .top, spacing: 16) {
        VStack(alignment: .leading, spacing: 8) {
          Image(URL(string: "/gfx/survey/connectables.png"))
            .accessibilityLabel("Real-time connectables")
          Text("Connectables")
            .bold()
            .fontSize(.extraLarge)
          Text("Monitor your vehicle's vitals with easy to use Connectables.")
            .fontSize(.small)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
        .frame(width: 0.5)

        VStack(alignment: .leading, spacing: 8) {
          Image(URL(string: "/gfx/survey/scan-sessions.png"))
            .accessibilityLabel("Scan sessions")
          Text("Scan Sessions")
            .bold()
            .fontSize(.extraLarge)
          Text("Record and review your OBD scanning sessions with complete data history and analysis tools.")
            .fontSize(.small)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
        .frame(width: 0.5)
      }
      .frame(width: .full)
      .frame(width: 0.5, condition: .desktop)

      HStack(alignment: .top, spacing: 16) {
        VStack(alignment: .leading, spacing: 8) {
          Image(URL(string: "/gfx/survey/terminal.png"))
            .accessibilityLabel("OBD terminal")
          Text("OBD Terminal")
            .bold()
            .fontSize(.extraLarge)
          Text("Record and review your OBD scanning sessions with complete data history and analysis tools.")
            .fontSize(.small)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
        .frame(width: 0.5)

        VStack(alignment: .leading, spacing: 8) {
          Image(URL(string: "/gfx/survey/pid-detector.png"))
            .accessibilityLabel("PID Detector")
          Text("PID Detector")
            .bold()
            .fontSize(.extraLarge)
          Text("Discover potential new parameters with the PID Detector and join the open source hunt for more parameters.")
            .fontSize(.small)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
        .frame(width: 0.5)
      }
      .frame(width: .full)
      .frame(width: 0.5, condition: .desktop)
    }
    .margin(.vertical, 16)
  }
}
