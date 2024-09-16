import Foundation

import Slipstream

import SwiftSoup

private struct Parameter: View {
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

\(inlineHTML { Parameter("Vehicle") }) The vehicle this command should be performed on.

---

Turn Climatization On — Command
-------------------------------

Requires a Connected Account (Beta). Requires vehicle support for auto-climatization.

### Supported accounts

Porsche, Tesla, Toyota.

### Description

Running this command will enable climatization if it is not currently active.

### Parameters

\(inlineHTML { Parameter("Vehicle") }) The vehicle this command should be performed on.

---

Send Destination — Command
--------------------------

Requires a Connected Account (Beta). Requires vehicle support for sending remote destinations.

### Supported accounts

Porsche.

### Description

Running this command will send the given destination to your vehicle's primary navigation system. You'll then be able to initiate navigation to the destination from your vehicle's console.

### Parameters

\(inlineHTML { Parameter("Vehicle") }) The vehicle this command should be performed on.    
\(inlineHTML { Parameter("Destination") }) An address that is already saved on the given vehicle.

---

Lock — Command
--------------

Requires a Connected Account (Beta). Requires vehicle support for remote locking.

### Supported accounts

Porsche, Tesla, Toyota.

### Description

Running this command will lock your vehicle if it is not currently locked. This may cause the vehicle to make an audible chirp once complete.

### Parameters

\(inlineHTML { Parameter("Vehicle") }) The vehicle this command should be performed on.

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

\(inlineHTML { Parameter("Vehicle") }) The vehicle to return.

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

\(inlineHTML { Parameter("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Parameter("Bool") }) ](#available-boolean-parameters) The boolean parameter to be retrieved from the vehicle.

### Available Boolean Parameters

#### Charging

**icon:bolt/Charging** Is the vehicle currently charging?    
**icon:plug/Plugged in** Is the vehicle currently charging?

#### Climate Control

**icon:climatization/Climatization on** Is climatization currently running in the vehicle?    
**icon:climatization/Climatization possible** Is the vehicle able to turn climatization on?

#### Locked

**icon:lock/Front trunk locked** Is the vehicle's rear trunk locked?    
**icon:lock/Locked** Is the vehicle locked?    
**icon:lock/Rear trunk locked** Is the vehicle's rear trunk locked?

#### Open

**icon:front.left.open/Front left door open** Is the vehicle's front left door open?    
**icon:front.right.open/Front right door open** Is the vehicle's front right door open?    
**icon:front.trunk.open/Front trunk open** Is the vehicle's front trunk open?    
**icon:rear.left.open/Rear left door open** Is the vehicle's rear left door open?    
**icon:rear.right.open/Rear right door open** Is the vehicle's rear right door open?    
**icon:rear.trunk.open/Rear trunk open** Is the vehicle's rear trunk open?    
**icon:sunroof/Sunroof open** Is the vehicle's sun roof open?    
**icon:window.left/Front left window open** Is the vehicle's front left window open?    
**icon:window.right/Front right window open** Is the vehicle's front right window open?    
**icon:window.left/Rear left window open** Is the vehicle's rear left window open?    
**icon:window.right/Rear right window open** Is the vehicle's rear right window open?

#### Parking

**icon:parking.brake/Parking brake enabled** Is the vehicle's parking brake enabled?

#### State

**icon:inservice/In service** Is the vehicle currently in service?    
**icon:sleeping/Sleeping** Is the vehicle currently sleeping or in a low power state?

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

\(inlineHTML { Parameter("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Parameter("Date") }) ](#available-date-parameters) The date parameter to be retrieved from the vehicle.
    
### Available Date Parameters

#### Climate Control

**icon:climatization/Climatization end** If climatization is active, when will it end?

#### Parking

**icon:parking.brake/Park** When was the vehicle last parked?

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

\(inlineHTML { Parameter("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Parameter("Measure") }) ](#available-measure-parameters) The measured parameter to be retrieved from the vehicle.

### Available Measure Parameters

#### Charging

**icon:length/Charging rate, as distance | Length** How much range is being added per minute.    
**icon:bolt/Charging rate, as power | Power** How much energy is being added per minute.    
**icon:target/Charging target | Normal** The target charge percent.
    
#### Health

**icon:health/Battery health | Normal** The health of the vehicle's high voltage battery pack.

#### Navigation

**icon:heading/Vehicle heading | Angle** The direction the vehicle is facing.        
**icon:speed/Vehicle speed | Speed** How fast the vehicle is moving.

#### Range

**icon:battery/Battery level | Normal** How full the vehicle's battery is.    
**icon:length/Battery range | Length** The distance the vehicle can travel using electric power alone.    
**icon:fuel/Fuel level | Normal** How full the vehicle's gas tank is.    
**icon:length/Fuel range | Length** The distance the vehicle can travel using fuel alone.

#### Tire Pressure

**icon:tirepressure/Front left tire pressure | Pressure** The front left tire pressure.    
**icon:tirepressure/Front right tire pressure | Pressure** The front right tire pressure.    
**icon:tirepressure/Rear left tire pressure | Pressure** The rear left tire pressure.    
**icon:tirepressure/Rear right tire pressure | Pressure** The rear right tire pressure.    
**icon:tirepressure/Spare tire pressure | Pressure** The spare tire pressure.

#### Trips

**icon:length/Odometer | Length** The total distance the vehicle has traveled.

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

\(inlineHTML { Parameter("Vehicle") }) The vehicle from which the parameter should be retrieved.    
[\(inlineHTML { Parameter("Position") }) ](#available-position-parameters) The position parameter to be retrieved from the vehicle.

### Available Position Parameters

#### Navigation

**icon:pin/Location** The last known location of the vehicle.
""")
    }
  }
}

