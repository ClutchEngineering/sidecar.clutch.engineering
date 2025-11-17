import Foundation
import Slipstream
import SwiftSoup

struct VehicleSearchBar: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    // Main container
    let mainDiv = try container.appendElement("div")
    try mainDiv.addClass("relative w-full max-w-2xl mx-auto")

    // Search input container
    let inputContainer = try mainDiv.appendElement("div")
    try inputContainer.addClass("relative")

    // Search icon container
    let iconDiv = try inputContainer.appendElement("div")
    try iconDiv.addClass("absolute left-4 top-1/2 -translate-y-1/2 text-zinc-400 pointer-events-none")

    // Search icon (SVG)
    let svg = try iconDiv.appendElement("svg")
    try svg.attr("xmlns", "http://www.w3.org/2000/svg")
    try svg.attr("fill", "none")
    try svg.attr("viewBox", "0 0 24 24")
    try svg.attr("stroke-width", "1.5")
    try svg.attr("stroke", "currentColor")
    try svg.addClass("w-5 h-5")

    let path = try svg.appendslement("path")
    try path.attr("stroke-linecap", "round")
    try path.attr("stroke-linejoin", "round")
    try path.attr("d", "m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z")

    // Search input field
    let input = try inputContainer.appendElement("input")
    try input.attr("type", "text")
    try input.attr("id", "vehicle-search-input")
    try input.attr("placeholder", "Search makes and models...")
    try input.attr("autocomplete", "off")
    try input.addClass("w-full pl-12 pr-4 py-3 text-base md:text-lg rounded-2xl border-2 border-zinc-200 dark:border-zinc-700 bg-white dark:bg-zinc-900 text-zinc-900 dark:text-zinc-100 placeholder-zinc-400 focus:outline-none focus:ring-2 focus:ring-zinc-400 dark:focus:ring-zinc-600 focus:border-transparent transition-all")

    // Dropdown results container (hidden by default)
    let resultsDiv = try mainDiv.appendElement("div")
    try resultsDiv.attr("id", "vehicle-search-results")
    try resultsDiv.addClass("absolute z-50 w-full mt-2 max-h-96 overflow-y-auto bg-white dark:bg-zinc-800 border-2 border-zinc-200 dark:border-zinc-700 rounded-2xl shadow-lg hidden")
  }
}
