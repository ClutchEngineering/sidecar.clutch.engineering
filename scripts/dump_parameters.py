#!/usr/bin/env python3
"""
Extract all parameter definitions from OBDb workspace and output as JSON.

This script reads vehicle signal definitions from the workspace and extracts
full parameter metadata (not just connectable mappings) for use in the
parameter support table.
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Dict, Any


def dbgfilter_to_string(dbgfilter: Any) -> str:
    """
    Convert a dbgfilter (which can be a string or dict) to a filter string.

    Args:
        dbgfilter: The dbgfilter value from OBDb JSON (string or dict)

    Returns:
        Filter string in the format expected by Filter.swift
    """
    # If it's already a string, return it
    if isinstance(dbgfilter, str):
        return dbgfilter

    # If it's not a dict, convert to string
    if not isinstance(dbgfilter, dict):
        return str(dbgfilter)

    # Parse dictionary format
    parts = []

    # Handle 'from' field (e.g., "2021<=")
    if "from" in dbgfilter and dbgfilter["from"] is not None:
        parts.append(f"{dbgfilter['from']}<=")

    # Handle 'to' field (e.g., "<=2020")
    if "to" in dbgfilter and dbgfilter["to"] is not None:
        parts.append(f"<={dbgfilter['to']}")

    # Handle 'years' field (e.g., "2015,2016,2017")
    if "years" in dbgfilter and dbgfilter["years"]:
        if isinstance(dbgfilter["years"], list):
            years = [str(y) for y in dbgfilter["years"]]
            parts.extend(years)

    # If no parts, return "ALL"
    if not parts:
        return "ALL"

    # Join parts with comma
    return ",".join(parts)


def process_signal(signal: Dict[str, Any]) -> Dict[str, Any]:
    """
    Extract parameter metadata from a signal definition.

    Args:
        signal: Signal definition from OBDb JSON

    Returns:
        Dictionary with parameter metadata
    """
    parameter = {
        "path": signal.get("path", ""),
        "name": signal.get("name", ""),
    }

    # Add optional fields if present
    if "description" in signal:
        parameter["description"] = signal["description"]

    # Extract unit from fmt if present
    if "fmt" in signal and isinstance(signal["fmt"], dict):
        if "unit" in signal["fmt"]:
            parameter["unit"] = signal["fmt"]["unit"]

    # Add suggestedMetric if present (this maps to Connectables)
    if "suggestedMetric" in signal:
        parameter["suggestedMetric"] = signal["suggestedMetric"]

    return parameter


def process_vehicle_file(filepath: Path) -> Dict[str, Dict[str, Dict[str, Any]]]:
    """
    Process a single vehicle signal definition file.

    Args:
        filepath: Path to the signal definition JSON file

    Returns:
        Dictionary mapping filters to signal ID -> parameter mappings
    """
    try:
        with open(filepath, 'r') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading {filepath}: {e}", file=sys.stderr)
        return {}

    # Extract filter from filename if present
    # e.g., "2015-2020.json" -> "2015<=,<=2020"
    filename = filepath.stem
    if filename == "default":
        filter_key = "ALL"
    else:
        # Try to parse year range from filename
        parts = filename.split("-")
        if len(parts) == 2 and parts[0].isdigit() and parts[1].isdigit():
            filter_key = f"{parts[0]}<=,<={parts[1]}"
        else:
            filter_key = "ALL"

    result = {filter_key: {}}

    # Process commands and extract signals
    if "commands" in data and isinstance(data["commands"], list):
        for command in data["commands"]:
            if "signals" not in command or not isinstance(command["signals"], list):
                continue

            # Check for dbgfilter (year-based filtering in OBDb)
            cmd_filter = filter_key
            if "dbgfilter" in command:
                cmd_filter = dbgfilter_to_string(command["dbgfilter"])

            if cmd_filter not in result:
                result[cmd_filter] = {}

            for signal in command["signals"]:
                if "id" not in signal:
                    continue

                signal_id = signal["id"]
                parameter = process_signal(signal)

                # Only add if we have meaningful data
                if parameter.get("name") or parameter.get("path"):
                    result[cmd_filter][signal_id] = parameter

    return result


def merge_filters(filters1: Dict[str, Dict[str, Any]],
                 filters2: Dict[str, Dict[str, Any]]) -> Dict[str, Dict[str, Any]]:
    """
    Merge two filter dictionaries.

    Args:
        filters1: First filter dictionary
        filters2: Second filter dictionary

    Returns:
        Merged filter dictionary
    """
    result = dict(filters1)

    for filter_key, signals in filters2.items():
        if filter_key not in result:
            result[filter_key] = {}
        result[filter_key].update(signals)

    return result


def process_workspace(workspace_path: Path) -> Dict[str, Dict[str, Dict[str, Any]]]:
    """
    Process all vehicle signal files in the workspace.

    Args:
        workspace_path: Path to the workspace directory

    Returns:
        Dictionary mapping vehicle paths to filter-based parameter mappings
    """
    all_parameters = {}

    # Find all signalsets/v3/*.json files
    for vehicle_dir in workspace_path.iterdir():
        if not vehicle_dir.is_dir():
            continue

        signalsets_dir = vehicle_dir / "signalsets" / "v3"
        if not signalsets_dir.exists():
            continue

        # Get the vehicle path (e.g., "Make-Model/signalsets/v3/default.json")
        vehicle_name = vehicle_dir.name

        for signal_file in signalsets_dir.glob("*.json"):
            # Create path key matching the format used in connectables.json
            path_key = f"{vehicle_name}/signalsets/v3/{signal_file.name}"

            filters = process_vehicle_file(signal_file)

            if filters:
                if path_key not in all_parameters:
                    all_parameters[path_key] = {}
                all_parameters[path_key] = merge_filters(
                    all_parameters[path_key],
                    filters
                )

    return all_parameters


def main():
    parser = argparse.ArgumentParser(
        description="Extract all parameter definitions from OBDb workspace"
    )
    parser.add_argument(
        "workspace",
        type=Path,
        help="Path to the OBDb workspace directory"
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("parameters.json"),
        help="Output JSON file path (default: parameters.json)"
    )

    args = parser.parse_args()

    if not args.workspace.exists():
        print(f"Error: Workspace path does not exist: {args.workspace}",
              file=sys.stderr)
        sys.exit(1)

    print(f"Processing workspace: {args.workspace}")
    parameters = process_workspace(args.workspace)

    print(f"Found {len(parameters)} vehicle parameter sets")

    # Count total parameters
    total_params = sum(
        sum(len(signals) for signals in filters.values())
        for filters in parameters.values()
    )
    print(f"Total parameters: {total_params}")

    # Write output
    print(f"Writing to: {args.output}")
    with open(args.output, 'w') as f:
        json.dump(parameters, f, indent=2, sort_keys=True)

    print("Done!")


if __name__ == "__main__":
    main()
