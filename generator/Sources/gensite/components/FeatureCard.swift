import Slipstream

struct FeatureCard<Content: View>: View {
  @ViewBuilder
  let content: @Sendable () -> Content

  var body: some View {
    Puck {
      Div {
        content()
      }
    }
    .clipsToBounds()
    .cornerRadius(.extraLarge)
    .background(.white)
    .background(.zinc, darkness: 800, condition: .dark)
  }
}

struct FeatureCardTitle<Content: View>: View {
  let content: @Sendable () -> Content
  public init(@ViewBuilder content: @escaping @Sendable () -> Content) {
    self.content = content
  }

  public init(_ string: String) where Content == DOMString {
    self.content = {
      DOMString(string)
    }
  }

  var body: some View {
    H3(content: content)
      .fontSize(.large, condition: .desktop)
      .fontWeight(.semibold)
  }
}

struct FeatureCardBody<Content: View>: View {
  let content: @Sendable () -> Content
  public init(@ViewBuilder content: @escaping @Sendable () -> Content) {
    self.content = content
  }

  public init(_ string: String) where Content == DOMString {
    self.content = {
      DOMString(string)
    }
  }

  var body: some View {
    Text(content: content)
      .textColor(.gray, darkness: 600)
      .textColor(.gray, darkness: 200, condition: .dark)
  }
}
