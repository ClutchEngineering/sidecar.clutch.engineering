import Foundation
import Slipstream
import SwiftSoup

struct WidgetStudio: View {
  var body: some View {
    Page(
      "Widget Studio",
      path: "/widgetstudio/",
      description: "Design your own custom widget interface with our drag and drop editor. Create personalized widget layouts for your dashboard.",
      keywords: ["widget", "editor", "drag and drop", "design", "interface", "dashboard"],
      scripts: [
        URL(string: "https://cdn.jsdelivr.net/npm/lz-string@1.5.0/libs/lz-string.min.js"),
        URL(string: "/scripts/widget-studio.js")
      ],
      additionalStylesheets: [URL(string: "/css/widget-studio.css")]
    ) {
      // Main container wrapper
      Div {
        // Left sidebar - Widget palette and controls
        Div {
            // Device Dimensions Section
            Div {
              H2("Device Dimensions")
                .fontSize(.large)
                .fontWeight(.bold)
                .margin(.bottom, 12)

              // Preset buttons
              Div {
                DimensionButton(label: "iPhone SE", width: 375, height: 667)
                DimensionButton(label: "iPhone 14", width: 390, height: 844)
                DimensionButton(label: "iPhone 14 Plus", width: 428, height: 926)
                DimensionButton(label: "Landscape", width: 844, height: 390)
              }
              .classNames(["flex", "flex-wrap", "gap-2"])
              .margin(.bottom, 12)

              // Custom inputs
              Div {
                DimensionInput(label: "Width", inputId: "width-input", defaultValue: "844")
                DimensionInput(label: "Height", inputId: "height-input", defaultValue: "390")
              }
              .classNames(["grid", "grid-cols-2", "gap-4"])
            }
            .margin(.bottom, 32)

            // Divider
            Div {}
              .classNames(["border-t", "border-gray-300"])
              .margin(.bottom, 32)

            // Widget Palette Section
            H2("Widget Palette")
              .fontSize(.large)
              .fontWeight(.bold)
              .margin(.bottom, 12)

            Paragraph("Drag widgets to the canvas")
              .fontSize(.small)
              .textColor(.text, darkness: 600)
              .margin(.bottom, 16)

            // Widget items
            VStack(spacing: 12) {
              WidgetPaletteItem(
                id: "tire-pressure",
                title: "Tire Pressure",
                icon: "🛞"
              )

              WidgetPaletteItem(
                id: "now-playing",
                title: "Now Playing",
                icon: "🎵"
              )

              WidgetPaletteItem(
                id: "battery",
                title: "Battery",
                icon: "🔋"
              )

              WidgetPaletteItem(
                id: "speed",
                title: "Speed",
                icon: "🏎️"
              )

              WidgetPaletteItem(
                id: "temperature",
                title: "Temperature",
                icon: "🌡️"
              )

              WidgetPaletteItem(
                id: "fuel",
                title: "Fuel",
                icon: "⛽"
              )
            }
            .id("widget-palette")
          }
        .id("sidebar")
        .classNames(["bg-white", "p-6", "border-r", "border-gray-200", "overflow-y-auto"])

        // Main canvas area
        Div {
          // Phone preview container
          Div {
            // Phone frame
            PhoneFrame()
          }
          .classNames(["flex", "items-center", "justify-center"])
        }
        .id("editor-area")
        .classNames(["flex-1", "bg-gray-50"])
        }
        .classNames(["flex", "flex-row", "min-h-screen"])
    }
  }
}

// Helper component for widget palette items
private struct WidgetPaletteItem: View {
  let id: String
  let title: String
  let icon: String

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let div = try container.appendElement("div")
    try div.addClass("widget-item cursor-grab active:cursor-grabbing p-4 bg-white border border-gray-300 rounded-lg hover:shadow-md transition-shadow text-center")
    try div.attr("data-widget-type", id)
    try div.attr("draggable", "true")

    let iconDiv = try div.appendElement("div")
    try iconDiv.addClass("text-4xl mb-2")
    try iconDiv.text(icon)

    let titleDiv = try div.appendElement("div")
    try titleDiv.addClass("text-sm font-medium")
    try titleDiv.text(title)
  }
}

// Helper component for dimension preset buttons
private struct DimensionButton: View {
  let label: String
  let width: Int
  let height: Int

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let button = try container.appendElement("button")
    try button.addClass("dimension-preset px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors text-sm")
    try button.attr("data-width", String(width))
    try button.attr("data-height", String(height))
    try button.attr("type", "button")
    try button.text(label)
  }
}

// Helper component for dimension inputs
private struct DimensionInput: View {
  let label: String
  let inputId: String
  let defaultValue: String

  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let div = try container.appendElement("div")

    let labelElement = try div.appendElement("label")
    try labelElement.attr("for", inputId)
    try labelElement.addClass("block text-sm font-medium mb-1")
    try labelElement.text(label)

    let input = try div.appendElement("input")
    try input.attr("type", "number")
    try input.attr("id", inputId)
    try input.attr("value", defaultValue)
    try input.addClass("w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500")
  }
}

// Helper component for phone frame with drop zones
private struct PhoneFrame: View {
  func render(_ container: SwiftSoup.Element, environment: EnvironmentValues) throws {
    let phoneFrame = try container.appendElement("div")
    try phoneFrame.attr("id", "phone-frame")
    try phoneFrame.attr("style", "width: 844px; height: 390px;")
    try phoneFrame.addClass("relative bg-white border-8 border-gray-800 rounded-3xl overflow-hidden shadow-2xl")

    // Drop zones container - will be populated by JavaScript
    let dropZonesContainer = try phoneFrame.appendElement("div")
    try dropZonesContainer.attr("id", "drop-zones")
    try dropZonesContainer.attr("style", "position: absolute; top: 0; left: 0; right: 0; bottom: 0; pointer-events: none; z-index: 10;")

    // Map background
    let mapContainer = try phoneFrame.appendElement("div")
    try mapContainer.attr("id", "map-container")
    try mapContainer.addClass("w-full h-full bg-gray-200 relative")
  }
}
