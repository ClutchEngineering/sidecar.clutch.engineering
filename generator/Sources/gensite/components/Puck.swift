import Slipstream

struct Puck<Content: View>: View {
  @ViewBuilder
  let content: @Sendable () -> Content

  var body: some View {
    content()
      .shadow("puck")
  }
}
