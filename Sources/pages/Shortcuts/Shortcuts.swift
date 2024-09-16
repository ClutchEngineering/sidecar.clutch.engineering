import Foundation

import Slipstream

import SwiftSoup

private struct Entity: View {
  let name: String
  init(_ name: String) {
    self.name = name
  }

  var body: some View {
    Span(name)
      .fontWeight(.semibold)
      .background(.blue, darkness: 100)
      .background(.blue, darkness: 950, condition: .dark)
      .textColor(.blue, darkness: 600)
      .textColor(.blue, darkness: 400, condition: .dark)
      .cornerRadius(.base)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .margin(.vertical, 2)
      .display(.inlineBlock)
  }
}

private struct Parameter: View {
  let name: String
  let icon: String
  let type: String?
  init(_ name: String, icon: String, type: String? = nil) {
    self.name = name
    self.icon = icon
    self.type = type
  }

  var body: some View {
    Span {
      Image(URL(string: "/gfx/parameters/\(icon).png"))
        .colorInvert(condition: .dark)
        .display(.inlineBlock)
        .frame(width: 20)
        .margin(.right, 8)
        .offset(y: -1)
      DOMString(name)
      if let type {
        Span(" | \(type)")
          .fontWeight(.light)
          .opacity(0.75)
      }
    }
    .fontWeight(.semibold)
    .background(.blue, darkness: 100)
    .background(.blue, darkness: 950, condition: .dark)
    .cornerRadius(.base)
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .margin(.vertical, 2)
    .display(.inlineBlock)
  }
}

struct Shortcuts: View {
  var body: some View {
    Page(
      "Shortcuts",
      path: "/shortcuts",
      description: "A technical guide to using Shortcuts with Sidecar.",
      keywords: [
        "Apple Shortcuts",
        "automation",
        "iOS",
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      Container {
        Section {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/automation.png")!)

            Div {
              H1("Sidecar Shortcuts")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text {
                DOMString("A technical guide to building workflows with Apple's ")
                Link("Shortcuts", destination: URL(string: "https://support.apple.com/en-ca/guide/shortcuts/apdf22b0444c/ios"))
                  .textColor(.link, darkness: 500)
                  .bold()
                  .className("shortcuts-icon")
                DOMString(" app")
              }
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
      }

      PostView("""
## Overview

Sidecar makes it possible to build workflows that react to, and in some cases change, the state of your vehicle. If you're new to Shortcuts, [Apple's introductory article for iPhone and iPad](https://support.apple.com/en-ca/guide/shortcuts/welcome/ios) is a good place to learn the basics.

---

Vehicles
--------

Every action provided by Sidecar requires a Vehicle. This custom type represents one of the vehicles in your garage.

\(inlineHTML {
  Picture {
    Source(URL(string: "/gfx/vehicle-type-intent.dark.png"), colorScheme: .dark)
    Source(URL(string: "/gfx/vehicle-type-intent.png"), colorScheme: .light)
    Image(URL(string: "/gfx/vehicle-type-intent.png"))
      .margin(.horizontal, .auto)
      .frame(width: 0.8)
      .frame(width: 0.4, condition: .desktop)
  }
})

Tip: it's common to need to refer to the same Vehicle several times in a workflow. The [Get Vehicle](#get-vehicle-parameter) action lets you do this once and then reuse the same vehicle variable throughout your workflow.

---

Actions
-------

Sidecar's actions come in two flavors: Commands and Parameters. **Commands** require a Connected Account (Beta) and tell your vehicle to perform some kind of action. **Parameters** allow you to read information from your vehicle. Parameters are typically read by Sidecar from a Connected Account (Beta) or from an OBD-II scanner.

### Commands

#### Climate Control

*   [Turn Climatization Off](#turn-climatization-off-command)
*   [Turn Climatization On](#turn-climatization-on-command)

#### Navigation

*   [Send Destination](#send-destination-command)

#### Vehicle Control

*   [Lock](#lock-command)

### Parameters

#### Vehicles

*   [Get Vehicle](#get-vehicle-parameter)
*   [Get Vehicle Bool](#get-vehicle-bool-parameter)
*   [Get Vehicle Date](#get-vehicle-date-parameter)
*   [Get Vehicle Measure](#get-vehicle-measure-parameter)
*   [Get Vehicle Position](#get-vehicle-position-parameter)

---

Turn Climatization Off — Command
--------------------------------

Requires a Connected Account (Beta). Requires vehicle support for auto-climatization.

### Supported accounts

Porsche, Tesla, Toyota.

### Description

Running this command will disable climatization if it is currently active.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle this command should be performed on.

---

Turn Climatization On — Command
-------------------------------

Requires a Connected Account (Beta). Requires vehicle support for auto-climatization.

### Supported accounts

Porsche, Tesla, Toyota.

### Description

Running this command will enable climatization if it is not currently active.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle this command should be performed on.

---

Send Destination — Command
--------------------------

Requires a Connected Account (Beta). Requires vehicle support for sending remote destinations.

### Supported accounts

Porsche.

### Description

Running this command will send the given destination to your vehicle's primary navigation system. You'll then be able to initiate navigation to the destination from your vehicle's console.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle this command should be performed on.    
\(inlineHTML { Entity("Destination") }) An address that is already saved on the given vehicle.

---

Lock — Command
--------------

Requires a Connected Account (Beta). Requires vehicle support for remote locking.

### Supported accounts

Porsche, Tesla, Toyota.

### Description

Running this command will lock your vehicle if it is not currently locked. This may cause the vehicle to make an audible chirp once complete.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle this command should be performed on.

---

## Get Vehicle — Parameter

Works with all vehicles.

\(inlineHTML {
  Picture {
    Source(URL(string: "/gfx/vehicle-action.dark.png"), colorScheme: .dark)
    Source(URL(string: "/gfx/vehicle-action.png"), colorScheme: .light)
    Image(URL(string: "/gfx/vehicle-action.png"))
      .margin(.horizontal, .auto)
      .frame(width: 0.8)
      .frame(width: 0.4, condition: .desktop)
  }
})

### Description

Running this action will return a Vehicle instance that can be used as a variable in subsequent actions.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle to return.

---

Get Vehicle Bool — Parameter
----------------------------

Some parameters require a Connected Account (Beta) or OBD-II scanner. Parameter support varies by vehicle.

\(inlineHTML {
  Picture {
    Source(URL(string: "/gfx/bool-action.dark.png"), colorScheme: .dark)
    Source(URL(string: "/gfx/bool-action.png"), colorScheme: .light)
    Image(URL(string: "/gfx/bool-action.png"))
      .margin(.horizontal, .auto)
      .frame(width: 0.8)
      .frame(width: 0.4, condition: .desktop)
  }
})

### Description

Running this action will return the value of true or false for a given vehicle's parameter.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Entity("Bool") }) ](#available-boolean-parameters) The boolean parameter to be retrieved from the vehicle.

### Available Boolean Parameters

#### Charging

\(inlineHTML { Parameter("Charging", icon: "bolt") }) Is the vehicle currently charging?    
\(inlineHTML { Parameter("Plugged in", icon: "plug") }) Is the vehicle currently charging?

#### Climate Control

\(inlineHTML { Parameter("Climatization on", icon: "climatization") }) Is climatization currently running in the vehicle?    
\(inlineHTML { Parameter("Climatization possible", icon: "climatization") }) Is the vehicle able to turn climatization on?

#### Locked

\(inlineHTML { Parameter("Front trunk locked", icon: "lock") }) Is the vehicle's rear trunk locked?    
\(inlineHTML { Parameter("Locked", icon: "lock") }) Is the vehicle locked?    
\(inlineHTML { Parameter("Rear trunk locked", icon: "lock") }) Is the vehicle's rear trunk locked?

#### Open

\(inlineHTML { Parameter("Front left door open", icon: "front.left.open") }) Is the vehicle's front left door open?    
\(inlineHTML { Parameter("Front right door open", icon: "front.right.open") }) Is the vehicle's front right door open?    
\(inlineHTML { Parameter("Front trunk open", icon: "front.trunk.open") }) Is the vehicle's front trunk open?    
\(inlineHTML { Parameter("Rear left door open", icon: "rear.left.open") }) Is the vehicle's rear left door open?    
\(inlineHTML { Parameter("Rear right door open", icon: "rear.right.open") }) Is the vehicle's rear right door open?    
\(inlineHTML { Parameter("Rear trunk open", icon: "rear.trunk.open") }) Is the vehicle's rear trunk open?    
\(inlineHTML { Parameter("Sunroof open", icon: "sunroof") }) Is the vehicle's sun roof open?    
\(inlineHTML { Parameter("Front left window open", icon: "window.left") }) Is the vehicle's front left window open?    
\(inlineHTML { Parameter("Front right window open", icon: "window.right") }) Is the vehicle's front right window open?    
\(inlineHTML { Parameter("Rear left window open", icon: "window.left") }) Is the vehicle's rear left window open?    
\(inlineHTML { Parameter("Rear right window open", icon: "window.right") }) Is the vehicle's rear right window open?

#### Parking

\(inlineHTML { Parameter("Parking brake enabled", icon: "parking.brake") }) Is the vehicle's parking brake enabled?

#### State

\(inlineHTML { Parameter("In service", icon: "inservice") }) Is the vehicle currently in service?    
\(inlineHTML { Parameter("Sleeping", icon: "sleeping") }) Is the vehicle currently sleeping or in a low power state?

---

Get Vehicle Date — Parameter
----------------------------

Some parameters require a Connected Account (Beta) or OBD-II scanner. Parameter support varies by vehicle.

\(inlineHTML {
  Picture {
    Source(URL(string: "/gfx/date-action.dark.png"), colorScheme: .dark)
    Source(URL(string: "/gfx/date-action.png"), colorScheme: .light)
    Image(URL(string: "/gfx/date-action.png"))
      .margin(.horizontal, .auto)
      .frame(width: 0.8)
      .frame(width: 0.4, condition: .desktop)
  }
})

### Description

Running this action will return a date value for a given vehicle's parameter.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Entity("Date") }) ](#available-date-parameters) The date parameter to be retrieved from the vehicle.
    
### Available Date Parameters

#### Climate Control

\(inlineHTML { Parameter("Climatization end", icon: "climatization") }) If climatization is active, when will it end?

#### Parking

\(inlineHTML { Parameter("Park", icon: "parking.brake") }) When was the vehicle last parked?

---

Get Vehicle Measure — Parameter
-------------------------------

Some parameters require a Connected Account (Beta) or OBD-II scanner. Parameter support varies by vehicle.

\(inlineHTML {
  Picture {
    Source(URL(string: "/gfx/measure-action.dark.png"), colorScheme: .dark)
    Source(URL(string: "/gfx/measure-action.png"), colorScheme: .light)
    Image(URL(string: "/gfx/measure-action.png"))
      .margin(.horizontal, .auto)
      .frame(width: 0.8)
      .frame(width: 0.4, condition: .desktop)
  }
})

### Description

Running this action will return a measured value for a given vehicle's parameter in the specified units.

Measures must be converted to the same unit type. For example, Vehicle speed can only be converted to units of type Speed.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Entity("Measure") }) ](#available-measure-parameters) The measured parameter to be retrieved from the vehicle.

### Available Measure Parameters

#### Charging

\(inlineHTML { Parameter("Charging rate, as distance", icon: "length", type: "Length") }) How much range is being added per minute.    
\(inlineHTML { Parameter("Charging rate, as power", icon: "bolt", type: "Power") }) How much energy is being added per minute.    
\(inlineHTML { Parameter("Charging target", icon: "target", type: "Normal") }) The target charge percent.
    
#### Health

\(inlineHTML { Parameter("Battery health", icon: "health", type: "Normal") }) The health of the vehicle's high voltage battery pack.

#### Navigation

\(inlineHTML { Parameter("Vehicle heading", icon: "heading", type: "Angle") }) The direction the vehicle is facing.        
\(inlineHTML { Parameter("Vehicle speed", icon: "speed", type: "Speed") }) How fast the vehicle is moving.

#### Range

\(inlineHTML { Parameter("Battery level", icon: "battery", type: "Normal") }) How full the vehicle's battery is.    
\(inlineHTML { Parameter("Battery range", icon: "length", type: "Length") }) The distance the vehicle can travel using electric power alone.    
\(inlineHTML { Parameter("Fuel level", icon: "fuel", type: "Normal") }) How full the vehicle's gas tank is.    
\(inlineHTML { Parameter("Fuel range", icon: "length", type: "Length") }) The distance the vehicle can travel using fuel alone.

#### Tire Pressure

\(inlineHTML { Parameter("Front left tire pressure", icon: "tirepressure", type: "Pressure") }) The front left tire pressure.    
\(inlineHTML { Parameter("Front right tire pressure", icon: "tirepressure", type: "Pressure") }) The front right tire pressure.    
\(inlineHTML { Parameter("Rear left tire pressure", icon: "tirepressure", type: "Pressure") }) The rear left tire pressure.    
\(inlineHTML { Parameter("Rear right tire pressure", icon: "tirepressure", type: "Pressure") }) The rear right tire pressure.    
\(inlineHTML { Parameter("Spare tire pressure", icon: "tirepressure", type: "Pressure") }) The spare tire pressure.

#### Trips

\(inlineHTML { Parameter("Odometer", icon: "length", type: "Length") }) The total distance the vehicle has traveled.

---

Get Vehicle Position — Parameter
--------------------------------

Some parameters require a Connected Account (Beta) or OBD-II scanner. Parameter support varies by vehicle.

\(inlineHTML {
  Picture {
    Source(URL(string: "/gfx/position-action.dark.png"), colorScheme: .dark)
    Source(URL(string: "/gfx/position-action.png"), colorScheme: .light)
    Image(URL(string: "/gfx/position-action.png"))
      .margin(.horizontal, .auto)
      .frame(width: 0.8)
      .frame(width: 0.4, condition: .desktop)
  }
})

### Description

Running this action will return a position value for a given vehicle's parameter.

### Parameters

\(inlineHTML { Entity("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Entity("Position") }) ](#available-position-parameters) The position parameter to be retrieved from the vehicle.

### Available Position Parameters

#### Navigation

\(inlineHTML { Parameter("Location", icon: "pin") }) The last known location of the vehicle.
""")
    }
  }
}

