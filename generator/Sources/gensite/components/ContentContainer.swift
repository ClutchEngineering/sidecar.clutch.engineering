import Slipstream

struct ContentContainer<Content: View>: View {
  @ViewBuilder let content: () -> Content

  var body: some View {
    Container {
      content()
    }
    .padding(.horizontal, 8)
    .padding(.horizontal, 0, condition: .desktop)
  }
}
