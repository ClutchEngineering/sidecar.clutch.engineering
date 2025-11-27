import Foundation
import Slipstream

private struct BlogPostCard: View {
  let post: BlogPost

  var body: some View {
    Link(post.url) {
      Div {
        if let thumbnail = post.thumbnail {
          Div {
            Image(thumbnail)
              .accessibilityLabel(post.title ?? post.slug)
              .className("object-cover")
              .className("w-full")
              .className("h-40")
              .className("rounded-t-lg")
          }
          .className("overflow-hidden")
          .margin(.horizontal, -24)
          .margin(.top, -24)
          .margin(.bottom, 16)
        }

        if post.draft {
          Div {
            Span("DRAFT")
              .fontSize(.extraSmall)
              .fontWeight(600)
              .textColor(.white)
          }
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(.palette(.red, darkness: 500))
          .cornerRadius(4)
          .margin(.bottom, 12)
          .display(.inlineBlock)
        }

        H3 {
          if post.draft {
            Text("Draft: " + (post.title ?? post.slug))
          } else {
            Text(post.title ?? post.slug)
          }
        }
        .fontSize(.extraLarge)
        .fontWeight(700)
        .textColor(.text, darkness: 900)
        .textColor(.text, darkness: 100, condition: .dark)
        .margin(.bottom, 8)

        if let summary = post.summary {
          Slipstream.Paragraph(summary)
            .fontSize(.small)
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 300, condition: .dark)
            .margin(.bottom, 12)
        }

        Div {
          Text(formatDate(post.date))
        }
        .fontSize(.small)
        .textColor(.text, darkness: 500)
        .textColor(.text, darkness: 400, condition: .dark)
      }
      .padding(24)
      .border(.palette(.gray, darkness: 200), width: 1)
      .border(.palette(.gray, darkness: 700), width: 1, condition: .dark)
      .cornerRadius(8)
      .background(.white)
      .background(.palette(.gray, darkness: 800), condition: .dark)
      .classNames(["hover:shadow-lg", "hover:-translate-y-1", "hover:border-blue-400", "dark:hover:border-blue-600", "transition-all", "duration-200"])
    }
    .padding(8)
    .classNames(["no-underline", "block"])
  }

  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"
    return formatter.string(from: date)
  }
}

struct BlogList: View {
  let posts: [BlogPost]

  init(posts: [BlogPost]) {
    self.posts = posts.sorted(by: { $0.date > $1.date })
  }

  var body: some View {
    Page(
      "News",
      path: "/news/",
      description: "The latest in Sidecar.",
      keywords: [
        "OBD-II",
        "beta testing",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      ContentContainer {
        VStack(alignment: .center) {
          HeroIconPuck(url: URL(string: "/gfx/help.png")!)

          Div {
            H1("News")
              .fontSize(.fourXLarge)
              .bold()
              .fontDesign("rounded")
            Text("Stay up to date with the latest Sidecar news and updates.")
              .fontSize(.large)
          }
          .textAlignment(.center)
        }
        .padding(.vertical, 16)
      }
      .margin(.bottom, 16)

      ContentContainer {
        Div {
          for post in posts {
            BlogPostCard(post: post)
          }
        }
        .classNames(["grid", "gap-6", "grid-cols-1", "md:grid-cols-2", "lg:grid-cols-3"])
      }
    }
  }
}
