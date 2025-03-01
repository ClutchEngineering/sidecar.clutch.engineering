import Foundation

import Slipstream

struct ExtendedParameters: View {
  var body: some View {
    Page(
      "Extended OBD-II Parameters",
      path: "/scanning/extended-pids",
      description: "Extending Sidecar with custom parameters.",
      keywords: [
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      ScanningNavigation()

      Container {
        Section {
          VStack(alignment: .center) {
            HeroIconPuck(url: URL(string: "/gfx/addpid.png")!)

            Div {
              H1("Extended Parameters")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("How to extend Sidecar's functionality with custom parameters")
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
      }

      PostView("""
What are Extended Parameters?
-----------------------------

Extended Parameter IDs, or **PIDs**, are special codes used in the OBD-II (On-Board Diagnostics) system of vehicles to request data from a vehicle's electronic control unit (ECU). While standard PIDs provide basic data like vehicle speed and engine RPM, extended PIDs can offer more specific and detailed information, which can be crucial for advanced diagnostics.

For newer vehicles, especially electric vehicles, extended PIDs are often the only way to get information about the vehicle over OBD-II.

### Extended PIDs in Sidecar

In addition to supporting many of the industry standard OBD-II PIDs specified in [SAE J1979](https://www.sae.org/standards/content/j1979da_202404/), Sidecar pulls extended PIDs from the OBDb, [github.com/OBDb](https://github.com/OBDb).

Every vehicle make and model has its own GitHub repository in the OBDb GitHub organization. If a make and model you're interested in is not yet available, send an email with your requested make and model to [support@clutch.engineering](mailto:support@clutch.engineering) or [open an issue](https://github.com/ClutchEngineering/Sidecar/issues/new).

When you connect a scanner to your car, Sidecar will ask for the car's VIN in order to determine its make and model. The make and model will then be used to enable the relevant extended PIDs within the app.

All extended PIDs are licensed under a [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.

---

Contributing extended PIDs
--------------------------

Contributions from the automotive community help expand the library of extended PIDs available in Sidecar. By sharing extended PIDs, we all contribute to the ability for car owners to access more of their vehicle data.

To contribute an extended PID you must first fork the GitHub repository for the relevant make and model on [github.com/OBDb](https://github.com/OBDb).

Extended PIDs are stored at the following path in each repository:

```
signalsets/v3/default.json
```    

### Examples

*   [Ford Mustang](https://github.com/OBDb/Ford-Mustang/blob/main/signalsets/v3/default.json)
*   [MG MG4](https://github.com/OBDb/MG-MG4/blob/main/signalsets/v3/default.json)
*   [Porsche Taycan](https://github.com/OBDb/Porsche-Taycan/blob/main/signalsets/v3/default.json)

---

Extended PID file format
------------------------

Extended PIDs are stored in a [JSON file format](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON) using the following top level specification:

```
{
  "diagnosticLevel": String?,
  "commands": [Command]
  "signalGroups": [SignalGroup]?
}
```

### Complete example

```
{
  "commands": [{
    "hdr": "713",
    "rax": "77D",
    "cmd": {"22": "2B1B"},
    "freq": 0.25,
    "signals": [{
      "id": "TAYCAN_TIRE_FL_SPD",
      "path": "Movement",
      "fmt": {
        "len": 16,
        "max": 1000,
        "mul": 0.05625,
        "unit": "kilometersPerHour"
      },
      "name": "Front left wheel speed"
    }]
  }]
}
```

### Properties

\(inlineHTML { Parameter("commands", type: "[Command] | Required") }) Array of OBD-II commands that can be sent to this vehicle.    
\(inlineHTML { Parameter("diagnosticLevel", type: "String | Optional") }) The one-byte diagnostic level to use for this vehicle. Written in hex.    
\(inlineHTML { Parameter("signalGroups", type: "[SignalGroup] | Optional") }) Array of signal groups that can aggregate various signals together.

### Command

Commands represent a single OBD-II message that can be sent to the vehicle. The vehicle will typically respond to a Command with one or more Signals. Commands define the format of the Signals they expect to receive.

#### Example

```
{
  "commands": [{
    "hdr": "713",
    "rax": "77D",
    "cmd": {"22": "2B1B"},
    "freq": 0.25,
    "signals": [{
      "id": "TAYCAN_TIRE_FL_SPD",
      "path": "Movement",
      "fmt": {
        "len": 16,
        "max": 1000,
        "mul": 0.05625,
        "unit": "kilometersPerHour"
      },
      "name": "Front left wheel speed"
    }]
  }]
}
```

#### Required properties

\(inlineHTML { Parameter("hdr", type: "String | ATSHhhh") }) The command's 11-bit header, expressed as 3 hexadecimal characters.    
\(inlineHTML { Parameter("cmd", type: "ServicePID") }) The service and PID that should be sent.    
\(inlineHTML { Parameter("freq", type: "Number") }) The maximum frequency at which this command should be sent, in seconds.    
\(inlineHTML { Parameter("signals", type: "[Signal]") }) The collection of signals that this command returns.

#### Optional properties

\(inlineHTML { Parameter("rax", type: "String | ATCRAhhh") }) The command's 11-bit receive address, expressed as 3 hexadecimal characters. If not provided, then the command will attempt to guess the receive address based on the response.        
\(inlineHTML { Parameter("eax", type: "String | ATCEAhh") }) An extended address byte to be prefixed to the command's CAN messages, expressed as 2 hexadecimal characters. Some vehicle protocols (e.g. BMW) require this.        
\(inlineHTML { Parameter("tst", type: "String | ATTAhh") }) The tester (ie. scan tool) address that is used in the headers, periodic messages, filters, etc. If not provided, then the default tester address of `F1` will be used.        
\(inlineHTML { Parameter("tmo", type: "String | ATSThh") }) The timeout, expressed as a hexadecimal value in increments of 4 msec. The ELM327 waits a preset time for a response before it can declare that there was `NO DATA` received from the vehicle. The same timer setting is also used after a response has been received, while waiting to see if any more are coming. This property allows this timeout period to be adjusted. If no timeout value is provided, then the default of `32` (~200ms) will be used.        
\(inlineHTML { Parameter("fcm1", type: "Boolean") }) Some parameters only respond with the first frame when using the default flow control mode, 0. Setting this property to true enables flow control mode 1, requesting that all frames be returned together. If not provided, false is assumed and flow control mode 0 will be used. When enabled, the following configuration will be set prior to invoking the command:
```
ATFCSH7E0
ATFCSD300000
ATFCSM1
```

---

### Connectable

Connectables are elements of the Sidecar user interface that can be powered by values returned from an OBD-II scanner. Connectables expect their values to be provided in a certain [Unit](#unit).

#### Example

```
{
  "commands": [{
    "hdr": "7E0",
    "rax": "7E8",
    "cmd": {"22": "1156"},
    "freq": 1,
    "signals": [{
      "id": "TAYCAN_HVBAT_SOC",
      "path": "Battery",
      "fmt": {
        "len": 8,
        "max": 100,
        "mul": 0.5,
        "unit": "percent"
      },
      "name": "HV battery charge",
      "suggestedMetric": "stateOfCharge"
    }]
  }]
}
```

#### Available Connectables

\(inlineHTML { Parameter("fuelTankLevel", icon: "fuel", type: "Normal") }) How full the vehicle's gas tank is, as a percentage.    
\(inlineHTML { Parameter("isCharging", icon: "bolt", type: "Enum") }) Is the vehicle charging? Must either be an enumeration mapped to a value with a prefix of "CHARGING", or a scalar unit where a non-zero value means the vehicle is charging.    
\(inlineHTML { Parameter("odometer", icon: "length", type: "Length") }) The total distance the vehicle has traveled.    
\(inlineHTML { Parameter("electricRange", icon: "length", type: "Length") }) The distance the vehicle can travel on electricity alone.    
\(inlineHTML { Parameter("fuelRange", icon: "length", type: "Length") }) The distance the vehicle can travel on fuel.    
\(inlineHTML { Parameter("pluggedIn", icon: "plug", type: "Enum") }) Is the vehicle plugged in? Must either be an enumeration mapped to a value with a prefix of "PLUGGED",  or a scalar unit where a non-zero value means the vehicle is plugged in.
\(inlineHTML { Parameter("speed", icon: "speed", type: "Speed") }) How fast the vehicle is moving.    
\(inlineHTML { Parameter("stateOfCharge", icon: "battery", type: "Normal") }) How full the vehicle's battery is.    
\(inlineHTML { Parameter("stateOfHealth", icon: "health", type: "Normal") }) The health of the vehicle's high voltage battery pack.    
\(inlineHTML { Parameter("frontLeftTirePressure", icon: "tirepressure", type: "Pressure") }) The front left tire pressure.    
\(inlineHTML { Parameter("frontRightTirePressure", icon: "tirepressure", type: "Pressure") }) The front right tire pressure.    
\(inlineHTML { Parameter("rearLeftTirePressure", icon: "tirepressure", type: "Pressure") }) The rear left tire pressure.    
\(inlineHTML { Parameter("rearRightTirePressure", icon: "tirepressure", type: "Pressure") }) The rear right tire pressure.

---

### Format

Formats define how to decode a signal as a human-readable value from a command's response.

#### Example

```
{
  "commands": [{
    "hdr": "713",
    "rax": "77D",
    "cmd": {"22": "2B1B"},
    "freq": 0.25,
    "signals": [{
      "id": "TAYCAN_TIRE_FL_SPD",
      "path": "Movement",
      "fmt": {
        "len": 16,
        "max": 1000,
        "mul": 0.05625,
        "unit": "kilometersPerHour"
      },
      "name": "Front left wheel speed"
    }]
  }]
}
```

#### How the value is calculated

```
var value: Double
if sign {
  value = SignedBitReader(response, bix, len)
} else {
  value = UnsignedBitReader(response, bix, len)
}
value = (value * mul / div + add).clamped(to: min...max)
return Measurement(value: value, unit: unit)
```

#### Required properties

\(inlineHTML { Parameter("len", type: "Int") }) The number of bits to decode from the response, starting from the bit offset (bix).    
\(inlineHTML { Parameter("max", type: "Double") }) The maximum value this signal can have.    
\(inlineHTML { Parameter("unit", type: "Unit") }) The unit this value should be interpreted as.

#### Optional properties

\(inlineHTML { Parameter("bix", type: "Int") }) The bit offset to start reading the value from. Defaults to 0.    
\(inlineHTML { Parameter("blsb", type: "Boolean") }) Whether to swap the byte order prior to reading bits. E.g. a 16 bit value read from offset 8 of `0x012345` in blsb format would be passed to the bit decoder as `0x4523`.  Defaults to false.    
\(inlineHTML { Parameter("sign", type: "Boolean") }) Whether to treat the bit values as a signed, twos-complement integer. Defaults to false.    
\(inlineHTML { Parameter("min", type: "Double") }) The minimum value this signal can have. Defaults to 0.    
\(inlineHTML { Parameter("add", type: "Double") }) Added to the extracted numerical value. Defaults to 0.    
\(inlineHTML { Parameter("mul", type: "Double") }) The extracted numerical value is multiplied by this value. Defaults to 1.    
\(inlineHTML { Parameter("div", type: "Double") }) The extracted numerical value is divided by this value. Defaults to 1.    
\(inlineHTML { Parameter("nullmin", type: "Double") }) An optional null value. Any response equal to or less than this value will be treated as a null value.    
\(inlineHTML { Parameter("nullmax", type: "Double") }) An optional null value. Any response equal to or greater than this value will be treated as a null value.    
\(inlineHTML { Parameter("omin", type: "Double") }) The optimal minimum value, expressed in the same unit as the value. If not provided, no optimal minimum value will be shown.    
\(inlineHTML { Parameter("omax", type: "Double") }) The optimal maximum value, expressed in the same unit as the value. If not provided, no optimal maximum value will be shown.    
\(inlineHTML { Parameter("oval", type: "Double") }) The optimal value, expressed in the same unit as the value. If not provided, no optimal value will be shown.

### ServicePID

A service PID represents a parameter ID for a specific service.

#### Examples

```
{"22": "2B1B"}
{"01": "02"}
```    

Two services are currently supported: 01 and 22.

<table class="table-auto border-collapse border border-gray-800">
<thead>
 <tr class="bg-gray-800 text-white">
  <th class="px-2 md:px-4 py-2">Service</th>
  <th class="px-2 md:px-4 py-2">Format</th>
  <th class="px-2 md:px-4 py-2">Example</th>
 </tr>
</thead>
<tbody>
 <tr>
  <td class="px-2 md:px-4 py-2">01<br /></td>
  <td class="px-4 py-2 text-center"><span>hh</span></td>
  <td class="px-4 py-2 text-center"><span>01</span></td>
 </tr>
 <tr>
  <td class="px-2 md:px-4 py-2">22<br /></td>
  <td class="px-4 py-2 text-center"><span>hhhh</span></td>
  <td class="px-4 py-2 text-center"><span>2B1B</span></td>
 </tr>
</tbody>
</table>

### Signal

Signals are individual values contained within the response of a [Command](#command) sent to a vehicle. Most Commands only have one Signal, but Commands can pack any number of signals into a single response.

#### Example

```
{
  "commands": [{
    "hdr": "713",
    "rax": "77D",
    "cmd": {"22": "2B1B"},
    "freq": 0.25,
    "signals": [{
      "id": "TAYCAN_TIRE_FL_SPD",
      "path": "Movement",
      "fmt": {
        "len": 16,
        "max": 1000,
        "mul": 0.05625,
        "unit": "kilometersPerHour"
      },
      "name": "Front left wheel speed"
    }]
  }]
}
```

#### Required properties

\(inlineHTML { Parameter("id", type: "String") }) The signal's globally unique identifier.    
\(inlineHTML { Parameter("name", type: "String") }) The signal's human-readable name. Should be short and descriptive.    
\(inlineHTML { Parameter("fmt", type: "Format") }) How to interpret the signal's value from the command response.

#### Optional properties

\(inlineHTML { Parameter("path", type: "String") }) The navigation path for the signal in Sidecar's parameters page. If not provided, the signal's id property will be used as the navigation path instead.    
\(inlineHTML { Parameter("description", type: "String") }) A long form description of the signal's purpose and how it should be interpreted.    
\(inlineHTML { Parameter("hidden", type: "Boolean") }) If true, hides the signal from the user interface. Default value is false if not provided.    
\(inlineHTML { Parameter("suggestedMetric", type: "Connectable") }) The user interface value that this signal should update.

### Unit

Units define how a signal's value should be interpreted and represented to the user. Units are categorized, and values of the same unit category can be translated to one another. For example, miles and kilometers both belong to the same unit type Length.

If a unit includes a version (e.g. **v1.13+**), that means the unit was introduced in that version of the Sidecar application. Older app versions will fall back to treating unknown units as a scalar.

#### Accleration units

\(inlineHTML { Parameter("gravity", icon: "acceleration") }) Acceleration as a g-force.

#### Angle units

\(inlineHTML { Parameter("degrees", icon: "angle") }) Angle in degrees.    
\(inlineHTML { Parameter("radians", icon: "angle") }) Angle in radians.

#### Electric current units

\(inlineHTML { Parameter("kiloamps", icon: "current") }) Current in kiloamps.    
\(inlineHTML { Parameter("amps", icon: "current") }) Current in amperes.    
\(inlineHTML { Parameter("milliamps", icon: "current") }) Current in milliamps.

#### Electric potential difference units

\(inlineHTML { Parameter("kilovolts", icon: "volts") }) Voltage measured in kilovolts.    
\(inlineHTML { Parameter("volts", icon: "volts") }) Voltage measured in volts.    
\(inlineHTML { Parameter("millivolts", icon: "volts") }) Voltage measured in millivolts.

#### Energy units

\(inlineHTML { Parameter("kilowattHours", icon: "volts") }) Kilowatt-hours.    
\(inlineHTML { Parameter("kiljoules", icon: "volts") }) Kilojoules.    
\(inlineHTML { Parameter("joules", icon: "volts") }) Joules.

#### Length units

\(inlineHTML { Parameter("centimeters", icon: "length") }) Distance in centimeters.    
\(inlineHTML { Parameter("meters", icon: "length") }) Distance in meters.    
\(inlineHTML { Parameter("kilometers", icon: "length") }) Distance in kilometers.    
\(inlineHTML { Parameter("miles", icon: "length") }) Distance in miles.    
\(inlineHTML { Parameter("feet", icon: "length") }) Distance in feet.    
\(inlineHTML { Parameter("inches", icon: "length") }) Distance in inches.

#### Mass flow rate units

\(inlineHTML { Parameter("gramsPerSecond", icon: "airflow") }) Mass flow rate in grams per second.    
\(inlineHTML { Parameter("kilogramsPerHour", icon: "airflow") }) Mass flow rate in kilograms per hour.

#### Normal units

\(inlineHTML { Parameter("percent", icon: "percent") }) A percentage, typically between 0-100%.    
\(inlineHTML { Parameter("normal", icon: "percent") }) A normal, typically between 0.0-1.0.

#### Power units

\(inlineHTML { Parameter("kilowatts", icon: "volts") }) Kilowatts.    
\(inlineHTML { Parameter("watts", icon: "volts") }) Kilowatts.    
\(inlineHTML { Parameter("milliwatts", icon: "volts") }) Milliwatts.

#### Pressure units

\(inlineHTML { Parameter("bars", icon: "tirepressure") }) Pressure in bar.    
\(inlineHTML { Parameter("psi", icon: "tirepressure") }) Pound-force per square inch.    
\(inlineHTML { Parameter("kilopascal", icon: "tirepressure") }) Pressure in kilopascal.

#### Revolutions units

\(inlineHTML { Parameter("rpm", icon: "revolutions") }) Revolutions per minute.

#### Scalar units

\(inlineHTML { Parameter("scalar", icon: "scalar") }) An as-is numerical value.    
\(inlineHTML { Parameter("ascii", icon: "scalar") }) The extracted bytes will be formatted as an ASCII string. Scaling values will be ignored.    
\(inlineHTML { Parameter("hex", icon: "scalar") }) An as-is numerical value, formatted in hexadecimal. Scaling values will be ignored.    
\(inlineHTML { Parameter("offon", icon: "scalar") }) 0 = "off", 1 = "on"    
\(inlineHTML { Parameter("noyes", icon: "scalar") }) 0 = "no", 1 = "yes"    
\(inlineHTML { Parameter("yesno", icon: "scalar") }) 0 = "yes", 1 = "no".    
\(inlineHTML { Parameter("unknown", icon: "scalar") }) Treated as an as-is numerical value.

#### Speed units

\(inlineHTML { Parameter("metersPerSecond", icon: "speed") }) Speed in meters per second.    
\(inlineHTML { Parameter("kilometersPerHour", icon: "speed") }) Speed in kilometers per hour.    
\(inlineHTML { Parameter("milesPerHour", icon: "speed") }) Speed in miles per hour.

#### Temperature units

\(inlineHTML { Parameter("celsius", icon: "thermometer") }) Temperature in degrees celsius.    
\(inlineHTML { Parameter("fahrenheit", icon: "thermometer") }) Temperature in degrees fahrenheit.    
\(inlineHTML { Parameter("kelvin", icon: "thermometer") }) Temperature in degrees kelvin.

#### Time units

\(inlineHTML { Parameter("seconds", icon: "time") }) Time, measured in seconds.    
\(inlineHTML { Parameter("minutes", icon: "time") }) Time, measured in minutes.    
\(inlineHTML { Parameter("hours", icon: "time") }) Time, measured in hours.    
\(inlineHTML { Parameter("days", icon: "time") }) Time, measured in days.    
\(inlineHTML { Parameter("months", icon: "time") }) Time, measured in months.    
\(inlineHTML { Parameter("years", icon: "time") }) Time, measured in years.    

#### Torque units

\(inlineHTML { Parameter("newtonMeters", icon: "wrench") }) Newton-meters.    
\(inlineHTML { Parameter("poundFoot", icon: "wrench") }) Pound-foot.    
\(inlineHTML { Parameter("inchPound", icon: "wrench") }) Inch-pound.

#### Volume units

\(inlineHTML { Parameter("liters", icon: "volume") }) Volume in liters.    
\(inlineHTML { Parameter("gallons", icon: "volume") }) Volume in gallons.
""")
    }
  }
}

