import Foundation
import Slipstream
import VehicleSupport

struct SupportedSeal: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/checkmark.seal.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 18)
      .frame(width: 24, condition: .desktop)
  }
}

struct OBDStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/obdii.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 18)
      .frame(width: 24, condition: .desktop)
  }
}

struct OTAStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/ota.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 18)
      .frame(width: 24, condition: .desktop)
  }
}

struct NotApplicableStamp: View {
  var body: some View {
    Image(URL(string: "/gfx/symbols/slash.circle.png"))
      .colorInvert(condition: .dark)
      .display(.inlineBlock)
      .frame(width: 18)
  }
}

struct NotApplicableCell: View {
  let isLast: Bool
  var body: some View {
    Bordered(showTrailingBorder: !isLast) {
      TableCell {
        NotApplicableStamp()
          .opacity(0.3)
      }
    }
    .padding(.horizontal, 8)
  }
}

struct ParameterHeader: View {
  let icon: String
  let name: String
  let secondary: Bool

  var body: some View {
    VStack(alignment: .center) {
      Image(URL(string: "/gfx/parameters/\(icon).png"))
        .colorInvert(condition: .dark)
        .display(.inlineBlock)
        .frame(width: 18)
        .frame(width: 24, condition: .desktop)
      Text(name)
    }
    .justifyContent(.center)
    .opacity(secondary ? 0.25 : 1)
  }
}