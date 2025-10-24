import Slipstream

struct NarrowContainer<Content: View>: View {
  @ViewBuilder let content: @Sendable () -> Content

  var body: some View {
    Container {
      content()
    }
    .padding(.horizontal, 104, condition: .desktop)
  }
}
