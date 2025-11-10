import Foundation
import Slipstream

struct WidgetStudio: View {
  var body: some View {
    Page(
      "Widget Studio",
      path: "/widgetstudio/",
      description: "Design your own custom widget interface with our drag and drop editor. Create personalized widget layouts for your dashboard.",
      keywords: ["widget", "editor", "drag and drop", "design", "interface", "dashboard"]
    ) {
      Div {
        // Main container
        Div {
          // Left sidebar - Widget palette
          Div {
            H2 {
              "Widget Palette"
            }
            .fontSize(.extraExtraLarge)
            .fontWeight(.bold)
            .margin(.bottom, 16)

            Paragraph {
              "Drag widgets to the phone screen"
            }
            .fontSize(.small)
            .textColor(.gray, darkness: 600)
            .margin(.bottom, 24)

            // Widget items
            Div {
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
            .display(.flex)
            .flexDirection(.column)
            .gap(12)
          }
          .id("sidebar")
          .width(.full)
          .backgroundColor(.white)
          .padding(24)
          .border(.gray, width: 1, darkness: 200)
          .classModifier("md:w-80 md:h-screen md:overflow-y-auto md:sticky md:top-0")

          // Main editor area
          Div {
            // Controls section
            Div {
              H2 {
                "Device Dimensions"
              }
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
                .display(.flex)
                .flexWrap(.wrap)
                .gap(8)
                .margin(.bottom, 16)

                // Custom inputs
                Div {
                  Div {
                    Label("Width") {
                      Input(type: .number)
                        .id("width-input")
                        .value("390")
                        .classModifier("w-full px-3 py-2 border border-gray-300 rounded-md")
                    }
                    .fontSize(.small)
                    .fontWeight(.medium)
                  }

                  Div {
                    Label("Height") {
                      Input(type: .number)
                        .id("height-input")
                        .value("844")
                        .classModifier("w-full px-3 py-2 border border-gray-300 rounded-md")
                    }
                    .fontSize(.small)
                    .fontWeight(.medium)
                  }
                }
                .display(.grid)
                .classModifier("grid-cols-2 gap-4")
              }
              .padding(16)
              .backgroundColor(.white)
              .border(.gray, width: 1, darkness: 200)
              .classModifier("rounded-lg")
            }
            .margin(.bottom, 32)

            // Phone preview container
            Div {
              // Phone frame
              Div {
                // Drop zones container
                Div {
                  // Top left
                  DropZone(position: "top-left")
                  // Top center
                  DropZone(position: "top-center")
                  // Top right
                  DropZone(position: "top-right")
                  // Left center
                  DropZone(position: "left-center")
                  // Right center
                  DropZone(position: "right-center")
                  // Bottom left
                  DropZone(position: "bottom-left")
                  // Bottom center
                  DropZone(position: "bottom-center")
                  // Bottom right
                  DropZone(position: "bottom-right")
                }
                .id("drop-zones")
                .position(.absolute)
                .classModifier("inset-0 pointer-events-none z-10")

                // Map background
                Div {
                  // This will be replaced with Apple Maps via JavaScript
                }
                .id("map-container")
                .width(.full)
                .height(.full)
                .backgroundColor(.gray, darkness: 200)
                .position(.relative)
              }
              .id("phone-frame")
              .position(.relative)
              .backgroundColor(.white)
              .border(.gray, width: 8, darkness: 800)
              .classModifier("rounded-3xl overflow-hidden shadow-2xl resize mx-auto")
              .inlineStyle("width: 390px; height: 844px;")
            }
            .display(.flex)
            .justifyContent(.center)
            .padding(.vertical, 48)
          }
          .id("editor-area")
          .classModifier("flex-1 p-6 bg-gray-50")
        }
        .display(.flex)
        .flexDirection(.column)
        .classModifier("md:flex-row")
      }
      .classModifier("min-h-screen")

      // Link to CSS
      Link(url: "/css/widget-studio.css")
        .relationship(.stylesheet)

      // Link to JavaScript
      Script(url: "/scripts/widget-studio.js")
        .attribute("defer", nil)
    }
  }
}

// Helper component for widget palette items
struct WidgetPaletteItem: View {
  let id: String
  let title: String
  let icon: String

  var body: some View {
    Div {
      Div {
        Text(icon)
      }
      .fontSize(.extraExtraLarge)
      .margin(.bottom, 8)

      Div {
        Text(title)
      }
      .fontSize(.small)
      .fontWeight(.medium)
    }
    .classModifier("widget-item cursor-grab active:cursor-grabbing")
    .attribute("data-widget-type", id)
    .attribute("draggable", "true")
    .padding(16)
    .backgroundColor(.white)
    .border(.gray, width: 1, darkness: 300)
    .classModifier("rounded-lg hover:shadow-md transition-shadow")
    .textAlignment(.center)
  }
}

// Helper component for dimension preset buttons
struct DimensionButton: View {
  let label: String
  let width: Int
  let height: Int

  var body: some View {
    Button {
      Text(label)
    }
    .classModifier("dimension-preset px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors text-sm")
    .attribute("data-width", String(width))
    .attribute("data-height", String(height))
  }
}

// Helper component for drop zones
struct DropZone: View {
  let position: String

  var body: some View {
    Div {
      // Visual indicator (hidden by default, shown on drag)
    }
    .classModifier("drop-zone absolute pointer-events-auto")
    .attribute("data-position", position)
    .classModifier(positionClasses)
  }

  private var positionClasses: String {
    switch position {
    case "top-left":
      return "top-4 left-4 w-20 h-20"
    case "top-center":
      return "top-4 left-1/2 -translate-x-1/2 w-20 h-20"
    case "top-right":
      return "top-4 right-4 w-20 h-20"
    case "left-center":
      return "top-1/2 left-4 -translate-y-1/2 w-20 h-20"
    case "right-center":
      return "top-1/2 right-4 -translate-y-1/2 w-20 h-20"
    case "bottom-left":
      return "bottom-4 left-4 w-20 h-20"
    case "bottom-center":
      return "bottom-4 left-1/2 -translate-x-1/2 w-20 h-20"
    case "bottom-right":
      return "bottom-4 right-4 w-20 h-20"
    default:
      return ""
    }
  }
}
