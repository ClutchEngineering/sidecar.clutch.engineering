import Foundation
import Slipstream

struct VehicleSearchBar: View {
  var body: some View {
    Div {
      // Search input container
      Div {
        // Search icon
        Div {
          DOMString(
            """
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
              <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
            </svg>
            """
          )
        }
        .classNames(["absolute", "left-4", "top-1/2", "-translate-y-1/2", "text-zinc-400", "pointer-events-none"])

        // Search input field
        DOMString(
          """
          <input
            type="text"
            id="vehicle-search-input"
            placeholder="Search makes and models..."
            autocomplete="off"
            class="w-full pl-12 pr-4 py-3 text-base md:text-lg rounded-2xl border-2 border-zinc-200 dark:border-zinc-700 bg-white dark:bg-zinc-900 text-zinc-900 dark:text-zinc-100 placeholder-zinc-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
          />
          """
        )
      }
      .position(.relative)

      // Dropdown results container (hidden by default)
      Div {
        // Results will be populated by JavaScript
      }
      .id("vehicle-search-results")
      .classNames([
        "absolute", "z-50", "w-full", "mt-2", "max-h-96", "overflow-y-auto",
        "bg-white", "dark:bg-zinc-800",
        "border-2", "border-zinc-200", "dark:border-zinc-700",
        "rounded-2xl", "shadow-lg",
        "hidden"  // Hidden by default, shown by JavaScript when there are results
      ])
    }
    .position(.relative)
    .classNames(["w-full", "max-w-2xl", "mx-auto"])
  }
}
