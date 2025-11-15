# Parameter Support Table Feature

## Overview

This feature extends the `MergedSupportMatrix` to include **all parameters** from OBDb (not just Connectables), and provides an API for the `ModelPage` to display a comprehensive parameter support table.

## Architecture

### Data Model

#### New Types

1. **`Parameter`** (`VehicleSupportMatrix/SupportingTypes/Parameter.swift`)
   - Represents a vehicle parameter/signal with full metadata
   - Properties:
     - `id`: Unique signal identifier (e.g., "TLX_GENERATOR")
     - `path`: Category/subsystem (e.g., "Engine", "Battery")
     - `name`: Human-readable name
     - `description`: Optional description
     - `unit`: Unit of measurement (e.g., "percent", "celsius")
     - `connectable`: Optional mapping to standard Connectable enum

2. **`ParameterSupportLevel`** (`VehicleSupportMatrix/SupportingTypes/Parameter.swift`)
   - Enum indicating support status for a parameter
   - Values:
     - `.unsupported`: Confirmed not supported
     - `.unknown`: Unknown support status
     - `.shouldBeSupported`: Expected to be supported (from OBDb definition)
     - `.confirmed`: Confirmed supported (from real vehicle data)

3. **`RawParameterDefinition`** (`VehicleSupportMatrix/SupportingTypes/RawParameterDefinition.swift`)
   - Raw parameter data as loaded from `parameters.json`
   - Converts to `Parameter` with `toParameter(id:)` method

4. **`ParameterMap`** (`VehicleSupportMatrix/SupportingTypes/ParameterMap.swift`)
   - Manages parameters with year range filtering
   - Similar to `FilterableSignalMap` but for all parameters
   - Methods:
     - `parameters(modelYear:)`: Get parameters for specific year
     - `allParameters`: Get all unique parameters
     - `allParameterIDs`: Get all unique parameter IDs

### MergedSupportMatrix Extensions

#### New Properties

- `allParameters: [OBDbID: ParameterMap]`: Stores all parameters per vehicle
- `rawParameters: ParameterDefinitionMap`: Raw parameter data from JSON

#### New Methods

- `loadParameters(projectRoot:)`: Load parameters from `.cache/parameters.json`
- `processParameters()`: Process raw parameters into structured format
- `parameters(for:)`: Get ParameterMap for a specific vehicle

### ModelSupport Extensions

#### New Types

- `ParameterTableRow`: Represents a row in the parameter table
  - `parameter`: The Parameter instance
  - `supportByYear`: Dictionary mapping years to support levels

- `ParameterTableSection`: Groups parameters by path
  - `path`: The category/subsystem path
  - `rows`: Array of ParameterTableRow instances

#### New Methods

- `buildParameterSupportTable(parameterMap:)`: Builds the table data structure
  - Organizes parameters by path
  - Determines support level per year
  - Returns array of sections ready for display

### View Components

#### ParameterSupportTable

Location: `generator/Sources/gensite/pages/SupportedCars/Components/ParameterSupportTable.swift`

Displays the full parameter support table with:
- Sections organized by parameter path
- Columns for each model year
- Support level indicators:
  - ✓ (green) = Confirmed
  - ○ (blue) = Should be supported
  - (empty) = Unknown
  - ✗ (red) = Unsupported

## Data Generation

### Python Script

**`scripts/dump_parameters.py`**

Extracts all parameter metadata from the OBDb workspace:

```bash
python3 scripts/dump_parameters.py workspace --output=.cache/parameters.json
```

Features:
- Reads all `signalsets/v3/*.json` files
- Extracts parameter metadata (path, name, description, unit)
- Preserves year-based filtering (dbgfilter)
- Outputs in same format as `connectables.json`

### Setup Script Integration

The `scripts/setup_workspace.sh` script now:
1. Creates the workspace
2. Extracts connectables (`dump_connectables.py`)
3. **Extracts all parameters (`dump_parameters.py`)**

### Output Format

`parameters.json` structure:
```json
{
  "Make-Model/signalsets/v3/default.json": {
    "ALL": {
      "SIGNAL_ID": {
        "path": "Engine",
        "name": "Generator",
        "description": "Optional description",
        "unit": "percent",
        "suggestedMetric": "stateOfCharge"
      }
    },
    "2021<=": {
      "SIGNAL_ID_2021": {
        "path": "Battery",
        "name": "State of Charge"
      }
    }
  }
}
```

## Usage

### In ModelPage

The parameter table is automatically displayed on each model page:

```swift
// Parameter Support Table
Section {
  ContentContainer {
    VStack(alignment: .leading, spacing: 16) {
      let parameterMap = supportMatrix.parameters(for: obdbID)
      let sections = modelSupport.buildParameterSupportTable(parameterMap: parameterMap)

      if !sections.isEmpty {
        ParameterSupportTable(
          sections: sections,
          modelYears: modelSupport.allModelYears
        )
      }
    }
    .padding(.vertical, 16)
  }
}
.margin(.bottom, 32)
```

### Accessing Parameter Data

```swift
// Get all parameters for a vehicle
let parameterMap = supportMatrix.parameters(for: "Acura-TLX")

// Get parameters for a specific year
if let yearParams = parameterMap.parameters(modelYear: 2021) {
  for (signalID, parameter) in yearParams {
    print("\(parameter.name) (\(parameter.path))")
  }
}

// Build table for display
let sections = modelSupport.buildParameterSupportTable(parameterMap: parameterMap)
```

## Benefits

1. **Comprehensive Coverage**: Shows ALL vehicle parameters, not just core Connectables
2. **Year-Specific**: Displays which parameters are supported for which model years
3. **Organized**: Groups parameters by category (path) for easy browsing
4. **Detailed Metadata**: Shows units, descriptions, and other parameter details
5. **Support Status**: Clearly indicates confirmed vs. expected support

## Future Enhancements

Possible improvements:
- Add filtering/search functionality to the table
- Include SAE J1979 standard parameters
- Add parameter availability statistics
- Support for parameter groups (e.g., battery modules)
- Export functionality (CSV, JSON)
