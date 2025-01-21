import Foundation

func milesTraveledQuery() -> String {
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
        "breakdown_hide_other_aggregation": null,
        "breakdown_histogram_bin_count": null,
        "breakdown_limit": null,
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
          "custom_name": "Miles traveled",
          "event": "carplay",
          "fixedProperties": null,
          "kind": "EventsNode",
          "limit": null,
          "math": "hogql",
          "math_group_type_index": null,
          "math_hogql": "(sum(IF(toInt(properties.$app_build) <= 286, properties.metersTraveled, properties.metersTraveledWithCarPlayConnected)) / 1000) / 1.609344",
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
              "key": "toInt(properties.$app_build) <= 286 OR (toInt(properties.$app_build) >= 288 AND properties.metersTraveledWithCarPlayConnected > 0)",
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
        "goalLines": null,
        "hiddenLegendIndexes": null,
        "resultCustomizationBy": "value",
        "resultCustomizations": null,
        "showAlertThresholdLines": false,
        "showLabelsOnSeries": null,
        "showLegend": false,
        "showPercentStackView": false,
        "showValuesOnSeries": true,
        "smoothingIntervals": 1,
        "yAxisScaleType": "linear"
      }
    },
    "filename": "export-CarPlay distance traveled (by model)"
  },
  "expires_after": "\(ISO8601DateFormatter().string(from: expiresAfter))"
}
"""
}
