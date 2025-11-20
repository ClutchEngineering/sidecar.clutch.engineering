# CarPlay Support Data

This directory contains the CarPlay support data extracted from Apple's official compatibility list.

## Files

### `carplay_support.json`

Comprehensive database of vehicles that support Apple CarPlay, organized by manufacturer and model.

**Structure:**
```json
{
  "Manufacturer": [
    {
      "model": "Model Name",
      "years": [2020, 2021, 2022, 2023, 2024],
      "start_year": 2020,
      "end_year": 2024,
      "supports_carkey": true,  // Optional: supports digital car keys
      "wireless": true,          // Optional: wireless CarPlay
      "wired": true             // Optional: wired CarPlay only
    }
  ]
}
```

**Data Source:**
https://www.apple.com/ios/carplay/available-models/

**Last Updated:**
2025-11-19

## Usage

### Swift (Site Generator)

The CarPlay data is loaded and used by the site generator through the `CarPlaySupportDatabase` class:

```swift
import VehicleSupport

let carPlayDB = try CarPlaySupportDatabase(
    jsonURL: URL(fileURLWithPath: "data/carplay_support.json")
)

// Check if a specific vehicle supports CarPlay
if carPlayDB.supportsCarPlay(make: "Ford", model: "Mustang Mach-E", year: 2024) {
    print("This vehicle supports CarPlay")
}

// Get all models for a manufacturer
let fordModels = carPlayDB.models(for: "Ford")

// Find support details for a specific model
if let support = carPlayDB.support(for: "Honda", model: "Accord") {
    print("CarPlay supported from \(support.startYear) to \(support.endYear)")
}
```

### Display in Vehicle Articles

The `CarPlaySupportTable` component automatically displays CarPlay support information on vehicle model pages:

```swift
import Slipstream

CarPlaySupportTable(
    make: "Honda",
    modelName: "Accord",
    carPlaySupport: carPlayDB.support(for: "Honda", model: "Accord")
)
```

## Updating the Data

To update the CarPlay support data:

1. Visit https://www.apple.com/ios/carplay/available-models/
2. Save the HTML content
3. Run the extraction script:
   ```bash
   python3 scripts/extract_carplay_data.py
   ```
4. Review and commit the updated `carplay_support.json`

## Integration with Vehicle Support Matrix

The CarPlay data is designed to complement the existing vehicle support matrix by providing:

- Year-by-year CarPlay compatibility
- Wireless vs. wired connection information
- Digital car key support indicators

This data can be displayed alongside OBD-II parameter support in vehicle articles, giving users a complete picture of their vehicle's connectivity capabilities.
