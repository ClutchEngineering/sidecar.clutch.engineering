import Foundation

public func stigsQuery() -> String {
  let expiresAfter = Calendar.current.date(byAdding: .hour, value: 3, to: Date())!
  return """
{
  "export_format": "text/csv",
  "export_context": {
    "source": {
      "aggregation_group_type_index": null,
      "breakdownFilter": {
        "breakdown": null,
        "breakdown_group_type_index": null,
        "breakdown_hide_other_aggregation": true,
        "breakdown_histogram_bin_count": null,
        "breakdown_limit": 5000,
        "breakdown_normalize_url": null,
        "breakdown_type": "event",
        "breakdowns": [
          {
            "group_type_index": null,
            "histogram_bin_count": null,
            "normalize_url": null,
            "property": "vehicleMake",
            "type": "event"
          }
        ]
      },
      "compareFilter": null,
      "conversionGoal": null,
      "dataColorTheme": null,
      "dateRange": {
        "date_from": "2024-12-03",
        "date_to": null,
        "explicitDate": false
      },
      "filterTestAccounts": true,
      "interval": "day",
      "kind": "TrendsQuery",
      "modifiers": null,
      "properties": {
        "type": "AND",
        "values": []
      },
      "response": null,
      "samplingFactor": null,
      "series": [
        {
          "custom_name": "# of stigs",
          "event": "carplay",
          "fixedProperties": null,
          "kind": "EventsNode",
          "limit": null,
          "math": "dau",
          "math_group_type_index": null,
          "math_hogql": null,
          "math_property": null,
          "math_property_type": null,
          "name": "carplay",
          "orderBy": null,
          "properties": [
            {
              "key": "actionContext",
              "label": null,
              "operator": "exact",
              "type": "event",
              "value": [
                "session"
              ]
            },
            {
              "key": "metersTraveled",
              "label": null,
              "operator": "gt",
              "type": "event",
              "value": "100"
            },
            {
              "key": "vehicleMake",
              "label": null,
              "operator": "is_set",
              "type": "event",
              "value": "is_set"
            },
            {
              "key": "toInt(properties.$app_build) <= 286 OR (toInt(properties.$app_build) >= 288 AND properties.metersTraveled > 0)",
              "label": null,
              "type": "hogql",
              "value": null
            }
          ],
          "response": null
        }
      ],
      "trendsFilter": {
        "aggregationAxisFormat": "numeric",
        "aggregationAxisPostfix": null,
        "aggregationAxisPrefix": null,
        "breakdown_histogram_bin_count": null,
        "decimalPlaces": 0,
        "display": "ActionsTable",
        "formula": null,
        "formulas": null,
        "goalLines": null,
        "hiddenLegendIndexes": null,
        "resultCustomizationBy": "value",
        "resultCustomizations": null,
        "showAlertThresholdLines": false,
        "showLabelsOnSeries": null,
        "showLegend": false,
        "showMultipleYAxes": false,
        "showPercentStackView": false,
        "showValuesOnSeries": true,
        "smoothingIntervals": 1,
        "yAxisScaleType": "linear"
      }
    },
    "filename": "export-CarPlay drivers (by model)"
  },
  "expires_after": "\(ISO8601DateFormatter().string(from: expiresAfter))"
}
"""
}

public func milesTraveledQuery() -> String {
  let expiresAfter = Calendar.current.date(byAdding: .hour, value: 3, to: Date())!
  return """
{
  "export_format": "text/csv",
  "export_context": {
    "source": {
      "aggregation_group_type_index": null,
      "breakdownFilter": {
        "breakdown": null,
        "breakdown_group_type_index": null,
        "breakdown_hide_other_aggregation": true,
        "breakdown_histogram_bin_count": null,
        "breakdown_limit": 5000,
        "breakdown_normalize_url": null,
        "breakdown_type": "event",
        "breakdowns": [
          {
            "group_type_index": null,
            "histogram_bin_count": null,
            "normalize_url": null,
            "property": "vehicleMake",
            "type": "event"
          }
        ]
      },
      "conversionGoal": null,
      "dataColorTheme": null,
      "dateRange": {
        "date_from": "2024-12-03T00:00:00",
        "date_to": null,
        "explicitDate": false
      },
      "filterTestAccounts": true,
      "interval": "day",
      "kind": "TrendsQuery",
      "modifiers": null,
      "properties": {
        "type": "AND",
        "values": []
      },
      "response": null,
      "samplingFactor": null,
      "series": [
        {
          "custom_name": "Miles traveled",
          "event": "carplay",
          "kind": "EventsNode",
          "math": "hogql",
          "math_group_type_index": null,
          "math_hogql": "(sum(IF(toInt(properties.$app_build) <= 286, properties.metersTraveled, properties.metersTraveled)) / 1000) / 1.609344",
          "math_property": null,
          "math_property_type": null,
          "name": "carplay",
          "properties": [
            {
              "key": "actionContext",
              "label": null,
              "operator": "exact",
              "type": "event",
              "value": [
                "session"
              ]
            },
            {
              "key": "metersTraveled",
              "label": null,
              "operator": "gt",
              "type": "event",
              "value": "100"
            },
            {
              "key": "vehicleMake",
              "label": null,
              "operator": "is_set",
              "type": "event",
              "value": "is_set"
            },
            {
              "key": "toInt(properties.$app_build) <= 286 OR (toInt(properties.$app_build) >= 288 AND properties.metersTraveled > 0)",
              "label": null,
              "type": "hogql",
              "value": null
            }
          ]
        }
      ],
      "trendsFilter": {
        "aggregationAxisFormat": "numeric",
        "aggregationAxisPostfix": null,
        "aggregationAxisPrefix": null,
        "breakdown_histogram_bin_count": null,
        "decimalPlaces": 0,
        "display": "ActionsTable",
        "formula": null,
        "formulaNodes": null,
        "formulas": null,
        "goalLines": null,
        "hiddenLegendIndexes": null,
        "resultCustomizationBy": "value",
        "resultCustomizations": null,
        "showAlertThresholdLines": false,
        "showLabelsOnSeries": null,
        "showLegend": false,
        "showMultipleYAxes": false,
        "showPercentStackView": false,
        "showValuesOnSeries": true,
        "yAxisScaleType": "linear"
      }
    },
    "filename": "export-CarPlay distance traveled (by model)"
  },
  "expires_after": "\(ISO8601DateFormatter().string(from: expiresAfter))"
}
"""
}
