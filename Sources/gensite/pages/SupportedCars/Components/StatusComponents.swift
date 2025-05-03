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
          .opacity(0.5)
      }
    }
    .padding(.horizontal, 8)
  }
}

struct SupportStatus: View {
  let supported: VehicleSupportStatus.SupportState?
  let isLast: Bool

  init(supported: VehicleSupportStatus.SupportState?, isLast: Bool = false) {
    self.supported = supported
    self.isLast = isLast
  }

  var body: some View {
    switch supported {
    case .all:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          HStack {
            OTAStamp()
            OBDStamp()
          }
          .justifyContent(.center)
        }
      }
      .padding(.horizontal, 8)
    case .obd:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          OBDStamp()
        }
      }
      .padding(.horizontal, 8)
    case .ota:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          OTAStamp()
        }
      }
      .padding(.horizontal, 8)
    case .none:
      Bordered(showTrailingBorder: !isLast) {
        TableCell {
          Text("PID?")
            .textColor(.text, darkness: 600)
            .textColor(.text, darkness: 400, condition: .dark)
        }
      }
      .padding(.horizontal, 8)
    case .na:
      NotApplicableCell(isLast: isLast)
    }
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
    .opacity(secondary ? 0.3 : 1)
  }
}