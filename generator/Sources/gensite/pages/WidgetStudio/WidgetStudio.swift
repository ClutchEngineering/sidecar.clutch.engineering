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
      scripts: [URL(string: "/scripts/widget-studio.js")],
      additionalStylesheets: [URL(string: "/css/widget-studio.css")]
    ) {
      // Main container wrapper
      Div {
        // Left sidebar - Widget palette
        Div {
            H2("Widget Palette")
              .fontSize(.extraExtraLarge)
              .fontWeight(.bold)
              .margin(.bottom, 16)

            Paragraph("Drag widgets to the phone screen")
              .fontSize(.small)
              .textColor(.text, darkness: 600)
              .margin(.bottom, 24)

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
          .classNames(["w-full", "bg-white", "p-6", "border", "border-gray-200", "md:w-80", "md:h-screen", "md:overflow-y-auto", "md:sticky", "md:top-0"])

          // Main editor area
          Div {
            // Controls section
            Div {
              H2("Device Dimensions")
                .fontSize(.extraExtraLarge)
                .fontWeight(.bold)
                .margin(.bottom, 16)

              // Dimension controls
              Div {
                // Preset buttons
                Div {
                  DimensionButton(label: "iPhone SE", width: 375, height: 667)
                  DimensionButton(label: "iPhone 14", width: 390, height: 844)
                  DimensionButton(label: "iPhone 14 Plus", width: 428, height: 926)
                  DimensionButton(label: "iPhone Landscape", width: 844, height: 390)
                }
                .classNames(["flex", "flex-wrap", "gap-2"])
                .margin(.bottom, 16)

                // Custom inputs
                Div {
                  DimensionInput(label: "Width", inputId: "width-input", defaultValue: "390")
                  DimensionInput(label: "Height", inputId: "height-input", defaultValue: "844")
                }
                .classNames(["grid", "grid-cols-2", "gap-4"])
              }
              .padding(16)
              .background(.white)
              .border(.palette(.gray, darkness: 200), width: 1)
              .cornerRadius(8)
            }
            .margin(.bottom, 32)

            // Phone preview container
            Div {
              // Phone frame
              PhoneFrame()
            }
            .classNames(["flex", "justify-center"])
            .padding(.vertical, 48)
          }
          .id("editor-area")
          .classNames(["flex-1", "p-6", "bg-gray-50"])
        }
        .classNames(["flex", "flex-col", "md:flex-row", "min-h-screen"])
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
    try phoneFrame.attr("style", "width: 390px; height: 844px;")
    try phoneFrame.addClass("relative bg-white border-8 border-gray-800 rounded-3xl overflow-hidden shadow-2xl mx-auto")

    // Drop zones container
    let dropZonesContainer = try phoneFrame.appendElement("div")
    try dropZonesContainer.attr("id", "drop-zones")
    try dropZonesContainer.addClass("absolute inset-0 pointer-events-none z-10")

    // Create all 8 drop zones - made larger for better hit detection
    let positions = [
      ("top-left", "top-0 left-0"),
      ("top-center", "top-0 left-1/2 -translate-x-1/2"),
      ("top-right", "top-0 right-0"),
      ("left-center", "top-1/2 left-0 -translate-y-1/2"),
      ("right-center", "top-1/2 right-0 -translate-y-1/2"),
      ("bottom-left", "bottom-0 left-0"),
      ("bottom-center", "bottom-0 left-1/2 -translate-x-1/2"),
      ("bottom-right", "bottom-0 right-0")
    ]

    for (position, classes) in positions {
      let dropZone = try dropZonesContainer.appendElement("div")
      try dropZone.addClass("drop-zone absolute w-32 h-32 pointer-events-auto \(classes)")
      try dropZone.attr("data-position", position)
      try dropZone.attr("style", "pointer-events: auto;") // Ensure pointer events work
    }

    // Map background
    let mapContainer = try phoneFrame.appendElement("div")
    try mapContainer.attr("id", "map-container")
    try mapContainer.addClass("w-full h-full bg-gray-200 relative")
  }
}
