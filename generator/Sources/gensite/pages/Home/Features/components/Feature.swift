import Slipstream

struct Feature<Content: View>: View {
  @ViewBuilder
  let content: @Sendable () -> Content

  var body: some View {
    VStack(alignment: .center, spacing: 32) {
      content()
    }
    .justifyContent(.center)
    .padding(.horizontal, 16, condition: .desktop)
    .frame(width: 0.5, condition: .desktop)
  }
}
