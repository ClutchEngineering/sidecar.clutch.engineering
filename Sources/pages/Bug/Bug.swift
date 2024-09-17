import Foundation

import Slipstream

struct Bug: View {
  var body: some View {
    Redirect(URL(string: "https://github.com/ElectricSidecar/ElectricSidecar/issues/new"))
  }
}
