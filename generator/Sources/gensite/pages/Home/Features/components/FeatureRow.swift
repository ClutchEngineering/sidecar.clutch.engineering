import Slipstream

struct FeatureRow<ImageContent: View, ExplanationContent: View>: View {
  let imageOnLeft: Bool

  @ViewBuilder
  let image: @Sendable () -> ImageContent

  @ViewBuilder
  let explanation: @Sendable () -> ExplanationContent

  var body: some View {
    Container {
      ResponsiveStack {
        if imageOnLeft {
          image()
          Feature {
            explanation()
          }
        } else {
          Feature {
            explanation()
          }
          image()
        }
      }
    }
    .textColor("sidecar-gray")
    .textColor(.white, condition: .dark)
    .padding(.vertical, 48)
  }
}
