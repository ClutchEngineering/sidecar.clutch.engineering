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
import re
import sys
from pathlib import Path
from typing import Dict, Any, Optional

# Add the .schemas/python directory to the path so we can import the modules
script_dir = Path(__file__).parent
repo_root = script_dir.parent
schemas_python_dir = repo_root / ".schemas" / "python"
sys.path.insert(0, str(schemas_python_dir))

from can.repo_utils import extract_make_from_repo_name

try:
    from signalsets.loader import load_signalset
except ImportError:
    print("Error: Could not import signalsets module. Make sure you're running this from the root directory.")
    sys.exit(1)


def _generate_filter_key(filter_data: Optional[Dict]) -> str:
    """
    Generate a filter key string from filter data.

    Args:
        filter_data: Filter dictionary from command

    Returns:
        Filter string in format expected by Filter.swift
    """
    if not filter_data:
        return "ALL"

    key_parts = []
    to_year = filter_data.get('to')
    from_year = filter_data.get('from')
    years = filter_data.get('years')  # Expected to be a list from JSON

    if to_year is not None:
        key_parts.append(f"<={to_year}")

    if from_year is not None:
        key_parts.append(f"{from_year}<=")

    if years and isinstance(years, list):
        try:
            # Ensure years are numbers and sorted for consistent key generation
            num_years = sorted([int(y) for y in years if y is not None])
            if num_years:  # Add only if there are valid years after processing
                key_parts.append(",".join(map(str, num_years)))
        except (ValueError, TypeError):
            # If years contains non-convertible items or is not iterable as expected,
            # silently skip this part of the key.
            pass

    if not key_parts:  # Filter object existed but was empty or yielded no valid parts
        return "ALL"

    return ",".join(key_parts)


def extract_parameters(signalset_data: Dict[str, Any]) -> Dict[str, Dict[str, Any]]:
    """
    Extract all parameter metadata from a signalset, organizing them by filter keys.

    Args:
        signalset_data: The parsed JSON data of the signalset

    Returns:
        A dictionary where keys are filter strings and values are dictionaries
        mapping signal IDs to their parameter metadata.
    """
    parameters_by_filter: Dict[str, Dict[str, Any]] = {}

    # Process individual signals in each command
    if "commands" in signalset_data:
        for command in signalset_data.get("commands", []):
            command_filter_data = command.get("filter")
            filter_key = _generate_filter_key(command_filter_data)

            if filter_key not in parameters_by_filter:
                parameters_by_filter[filter_key] = {}

            current_filter_parameters = parameters_by_filter[filter_key]

            if "signals" in command:
                for signal in command.get("signals", []):
                    if "id" not in signal:
                        continue

                    signal_id = signal["id"]
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

                    # Only add if we have meaningful data
                    if parameter.get("name") or parameter.get("path"):
                        current_filter_parameters[signal_id] = parameter

    # Process signal groups if present
    if "signalGroups" in signalset_data:
        sg_filter_key = "NO_FILTER_APPLICABLE"

        if sg_filter_key not in parameters_by_filter:
            parameters_by_filter[sg_filter_key] = {}

        current_sg_parameters = parameters_by_filter[sg_filter_key]

        for group in signalset_data.get("signalGroups", []):
            if "id" in group:
                signal_id = group["id"]
                parameter = {
                    "path": group.get("path", ""),
                    "name": group.get("name", ""),
                }

                if "description" in group:
                    parameter["description"] = group["description"]

                if "suggestedMetricGroup" in group:
                    parameter["suggestedMetric"] = group["suggestedMetricGroup"]

                if parameter.get("name") or parameter.get("path"):
                    current_sg_parameters[signal_id] = parameter

    return parameters_by_filter


def process_directory(directory_path: str) -> Dict[str, Dict[str, Dict[str, Any]]]:
    """
    Process all JSON files in a directory, extracting parameters from each.

    Args:
        directory_path: Path to the directory to scan for JSON files

    Returns:
        Dictionary mapping relative file paths to their parameters,
        where parameters are organized by filter keys.
    """
    results: Dict[str, Dict[str, Dict[str, Any]]] = {}
    base_dir = Path(directory_path)

    # Regex pattern to match YYYY-YYYY.json (where YYYY is a 4-digit year)
    year_range_pattern = re.compile(r'^\d{4}-\d{4}\.json$', re.IGNORECASE)

    # Walk the directory tree to find all JSON files
    for root, _, files in os.walk(directory_path):
        for file in files:
            # Only include json files that match either default.json or YYYY-YYYY.json
            if file.lower() == 'default.json' or year_range_pattern.match(file):
                file_path = os.path.join(root, file)

                # Get the relative path to use as the key
                rel_path = os.path.relpath(file_path, directory_path)

                try:
                    # Load and process the signalset
                    try:
                        signalset_content = load_signalset(file_path)
                        signalset_data = json.loads(signalset_content)
                    except Exception:
                        # If the signalset loader fails, try loading as a regular JSON file
                        with open(file_path, 'r') as f:
                            signalset_data = json.load(f)

                    if "commands" not in signalset_data and "signalGroups" not in signalset_data:
                        print(f"Skipping {file_path}: no commands or signalGroups found")
                        continue

                    # Fallback logic
                    if not signalset_data.get("commands") and not signalset_data.get("signalGroups"):
                        if "-" not in root:
                            continue
                        make = extract_make_from_repo_name(file_path)
                        print(f"Falling back from {file_path} to the make repo: {make}")
                        try:
                            signalset_content = load_signalset(make + '/signalsets/v3/default.json')
                            signalset_data = json.loads(signalset_content)
                        except Exception:
                            with open(file_path, 'r') as f:
                                signalset_data = json.load(f)

                    # Extract parameters
                    parameters = extract_parameters(signalset_data)

                    # Only include files that have parameters
                    if parameters:
                        results[rel_path] = parameters
                        # Calculate total parameters for this file
                        num_parameters_in_file = sum(len(v) for v in parameters.values())
                        print(f"Processed {rel_path}: found {num_parameters_in_file} parameters across {len(parameters)} filter(s)")
                    else:
                        print(f"No parameters found in {rel_path}")

                except Exception as e:
                    print(f"Error processing {rel_path}: {e}")

    return results


def main():
    parser = argparse.ArgumentParser(
        description="Extract all parameter definitions from OBDb workspace"
    )
    parser.add_argument(
        "path",
        type=Path,
        help="Path to the OBDb workspace directory"
    )
    parser.add_argument(
        "--output", "-o",
        type=Path,
        help="Output JSON file path. If not specified, a default name will be used based on the input directory"
    )

    args = parser.parse_args()

    # Check if the input path exists and is a directory
    if not args.path.exists():
        print(f"Error: Path does not exist: {args.path}")
        sys.exit(1)

    if not args.path.is_dir():
        print(f"Error: Path is not a directory: {args.path}")
        sys.exit(1)

    # Set the output path
    if args.output:
        output_path = args.output
    else:
        # Use the directory name for the output file
        dir_name = args.path.name
        output_path = Path(f"{dir_name}_parameters.json")

    try:
        # Process directory of signalset files
        results = process_directory(str(args.path))

        # Write the combined results
        with open(output_path, 'w') as f:
            json.dump(results, f, indent=2, sort_keys=True)

        total_files = len(results)
        total_parameters = sum(sum(len(v) for v in cv.values()) for cv in results.values())
        print(f"Successfully processed {total_files} JSON files with a total of {total_parameters} parameters")
        print(f"Output saved to {output_path}")

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
