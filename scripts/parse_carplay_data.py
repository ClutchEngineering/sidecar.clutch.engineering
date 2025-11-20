#!/usr/bin/env python3
"""
Parse Apple CarPlay supported models HTML and convert to JSON.
This script extracts make/model/year data from the Apple CarPlay availability page.
"""

import json
import re
from html.parser import HTMLParser
from typing import List, Dict, Any


class CarPlayParser(HTMLParser):
    """Parse the CarPlay models HTML structure."""

    def __init__(self):
        super().__init__()
        self.data = {}
        self.current_make = None
        self.in_logo_container = False
        self.in_list_container = False
        self.in_model_list = False
        self.current_text = []

    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)

        # Detect manufacturer logo section
        if tag == 'div' and 'models-logo-container' in attrs_dict.get('class', ''):
            self.in_logo_container = True

        # Detect manufacturer name
        elif tag == 'span' and self.in_logo_container and 'image-logo-text' in attrs_dict.get('class', ''):
            self.current_text = []

        # Detect model list section
        elif tag == 'div' and 'models-list-container' in attrs_dict.get('class', ''):
            self.in_list_container = True

        # Detect ul in list container
        elif tag == 'ul' and self.in_list_container:
            self.in_model_list = True

        # Detect list items (models)
        elif tag == 'li' and self.in_model_list:
            self.current_text = []

    def handle_endtag(self, tag):
        if tag == 'div':
            if self.in_logo_container:
                self.in_logo_container = False
            if self.in_list_container:
                self.in_list_container = False
                self.in_model_list = False
                self.current_make = None

        elif tag == 'ul' and self.in_model_list:
            self.in_model_list = False

    def handle_data(self, data):
        data = data.strip()
        if not data:
            return

        # Capture manufacturer name
        if self.in_logo_container and not self.current_make:
            self.current_make = data
            if self.current_make not in self.data:
                self.data[self.current_make] = []

        # Capture model entries
        elif self.in_model_list and self.current_make:
            self.current_text.append(data)

    def handle_endtag(self, tag):
        if tag == 'li' and self.in_model_list and self.current_text:
            # Join text fragments and parse the model entry
            entry = ' '.join(self.current_text).strip()
            if entry and self.current_make:
                parsed = self.parse_model_entry(entry)
                if parsed:
                    self.data[self.current_make].append(parsed)
            self.current_text = []

        elif tag == 'div':
            if self.in_logo_container:
                self.in_logo_container = False
            if self.in_list_container:
                self.in_list_container = False
                self.in_model_list = False
                self.current_make = None

        elif tag == 'ul' and self.in_model_list:
            self.in_model_list = False

    def parse_model_entry(self, entry: str) -> Dict[str, Any]:
        """Parse a model entry like '2017 - 2024 Abarth 595' or '2023 Honda Civic'."""
        # Remove "Supports car keys" text if present
        entry = re.sub(r'Supports car keys\s*', '', entry).strip()

        # Pattern: YYYY - YYYY Model Name or YYYY Model Name
        pattern = r'^(\d{4})(?:\s*-\s*(\d{4}))?\s+(.+)$'
        match = re.match(pattern, entry)

        if match:
            start_year = int(match.group(1))
            end_year = int(match.group(2)) if match.group(2) else start_year
            model_name = match.group(3).strip()

            # Check for wireless/wired indicators
            wireless = 'wireless' in entry.lower()
            wired = 'wired' in entry.lower()

            # Expand year range
            years = list(range(start_year, end_year + 1))

            return {
                'model': model_name,
                'years': years,
                'start_year': start_year,
                'end_year': end_year,
                'wireless': wireless,
                'wired': wired,
            }
        return None


def normalize_make_name(make: str) -> str:
    """Normalize manufacturer names for consistency."""
    # Map special cases
    name_map = {
        'alfa-romeo': 'Alfa Romeo',
        'alfa romeo': 'Alfa Romeo',
        'aston-martin': 'Aston Martin',
        'aston martin': 'Aston Martin',
        'honda-motor': 'Honda',
        'indian-motorcycle': 'Indian Motorcycle',
        'land-rover': 'Land Rover',
        'land rover': 'Land Rover',
        'lynk-co': 'Lynk & Co',
        'lynk co': 'Lynk & Co',
        'mercedes': 'Mercedes-Benz',
        'mercedes-benz': 'Mercedes-Benz',
        'polaris-slingshot': 'Polaris Slingshot',
        'rolls-royce': 'Rolls-Royce',
        'rolls royce': 'Rolls-Royce',
        'vw': 'Volkswagen',
    }

    lower_make = make.lower()
    if lower_make in name_map:
        return name_map[lower_make]

    # Title case for others
    return make.title()


def main():
    """Main entry point."""
    # Read the HTML file
    with open('carplay_data.html', 'r', encoding='utf-8') as f:
        html_content = f.read()

    # Parse the HTML
    parser = CarPlayParser()
    parser.feed(html_content)

    # Normalize manufacturer names
    normalized_data = {}
    for make, models in parser.data.items():
        normalized_make = normalize_make_name(make)
        normalized_data[normalized_make] = models

    # Sort by manufacturer name
    sorted_data = dict(sorted(normalized_data.items()))

    # Write to JSON file
    with open('carplay_support.json', 'w', encoding='utf-8') as f:
        json.dump(sorted_data, f, indent=2, ensure_ascii=False)

    print(f"Parsed {len(sorted_data)} manufacturers")
    total_models = sum(len(models) for models in sorted_data.values())
    print(f"Total model entries: {total_models}")
    print("\nSample data:")
    for make in list(sorted_data.keys())[:3]:
        print(f"\n{make}:")
        for model in sorted_data[make][:2]:
            print(f"  - {model}")


if __name__ == '__main__':
    main()
