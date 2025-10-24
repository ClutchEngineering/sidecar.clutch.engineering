import Foundation
import Slipstream

func groupBlogPostsByYearAndMonth(posts: [BlogPost]) -> [Int: [Int: [BlogPost]]] {
  var groupedPosts: [Int: [Int: [BlogPost]]] = [:]

  let calendar = Calendar.current

  for post in posts {
    let year = calendar.component(.year, from: post.date)
    let month = calendar.component(.month, from: post.date)

    if groupedPosts[year] == nil {
      groupedPosts[year] = [:]
    }

    if groupedPosts[year]?[month] == nil {
      groupedPosts[year]?[month] = []
    }

    groupedPosts[year]?[month]?.append(post)
  }

  return groupedPosts
}

private struct YearHeading: View {
  let year: Int
  var body: some View {
    H2("\(year)")
      .fontSize(.extraExtraLarge)
      .bold()
      .fontDesign("rounded")
  }
}

private struct YearGroup<Content: View>: View {
  let isLastYear: Bool
  @ViewBuilder let content: @Sendable () -> Content

  var body: some View {
    VStack {
      content()
    }
    .margin(.bottom, 16)
    if !isLastYear {
      HorizontalRule()
    }
  }
}

private struct MonthHeading: View {
  let month: String
  var body: some View {
    H3(month)
      .fontSize(.large)
      .bold()
      .fontDesign("rounded")
  }
}

private struct MonthGroup<Content: View>: View {
  let isLastMonth: Bool
  @ViewBuilder let content: @Sendable () -> Content

  var body: some View {
    if isLastMonth {
      List {
        content()
      }
    } else {
      List {
        content()
      }
      .margin(.bottom, 16)
    }
  }
}

private struct PostLink: View {
  let post: BlogPost

  var body: some View {
    ListItem {
      Link(post.url) {
        if post.draft {
          Text("Draft: " + (post.title ?? post.slug))
            .textColor(.palette(.red, darkness: 500))
        } else {
          Text(post.title ?? post.slug)
        }
      }
      .textColor(.link, darkness: 700)
      .textColor(.link, darkness: 400, condition: .dark)
      .fontWeight(600)
      .underline(condition: .hover)
    }
    .listStyle(.disc)
    .margin(.left, 22)
  }
}

struct BlogList: View {
  let posts: [BlogPost]
  let groupedPosts: [Int: [Int: [BlogPost]]]

  init(posts: [BlogPost]) {
    self.posts = posts
    self.groupedPosts = groupBlogPostsByYearAndMonth(posts: posts.reversed())
  }

  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    return dateFormatter
  }()

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
        Div {
          let sortedYears = groupedPosts.sorted(by: { $0.key > $1.key })
          for (year, months) in sortedYears {
            YearHeading(year: year)
            YearGroup(isLastYear: sortedYears.last?.key == year) {
              let sortedMonths = months.sorted(by: { $0.key > $1.key })
              for (month, posts) in sortedMonths {
                let monthName = dateFormatter.monthSymbols[month - 1]
                MonthHeading(month: monthName)
                MonthGroup(isLastMonth: sortedMonths.last?.key == month) {
                  for post in posts {
                    PostLink(post: post)
                  }
                }
              }
            }
          }
        }
        .textColor(.text, darkness: 950)
        .textColor(.text, darkness: 200, condition: .dark)
      }
      .padding(.bottom, 16)
    }
  }
}
