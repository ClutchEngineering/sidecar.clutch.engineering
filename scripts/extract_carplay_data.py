#!/usr/bin/env python3
"""
Extract CarPlay data from Apple's official CarPlay page.
This creates a comprehensive JSON file with make/model/year information.
"""

import json
import re
import sys
from urllib.request import urlopen, Request
from html.parser import HTMLParser

CARPLAY_URL = "https://www.apple.com/ios/carplay/available-models/"

class CarPlayHTMLParser(HTMLParser):
    """Parser to extract CarPlay model data from Apple's page."""

    def __init__(self):
        super().__init__()
        self.carplay_data = {}
        self.current_manufacturer = None
        self.in_manufacturer_span = False
        self.in_model_list = False
        self.in_list_item = False
        self.current_attrs = []

    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)

        # Check for manufacturer name span
        if tag == 'span' and attrs_dict.get('class') == 'image-logo-text':
            self.in_manufacturer_span = True

        # Check for models list container
        elif tag == 'div' and 'models-list-container' in attrs_dict.get('class', ''):
            self.in_model_list = True

        # Check for list items within the models list
        elif tag == 'li' and self.in_model_list:
            self.in_list_item = True

    def handle_endtag(self, tag):
        if tag == 'span':
            self.in_manufacturer_span = False
        elif tag == 'div':
            self.in_model_list = False
        elif tag == 'li':
            self.in_list_item = False

    def handle_data(self, data):
        data = data.strip()
        if not data:
            return

        # Capture manufacturer name
        if self.in_manufacturer_span:
            # Convert kebab-case to title case (e.g., "alfa-romeo" -> "Alfa Romeo")
            manufacturer = data.replace('-', ' ').title()
            self.current_manufacturer = manufacturer
            if manufacturer not in self.carplay_data:
                self.carplay_data[manufacturer] = []

        # Capture model data from list items
        elif self.in_list_item and self.current_manufacturer:
            # Pattern: "YYYY - YYYY Model Name" or "YYYY Model Name"
            # Also handle HTML entities like &#x2011; (non-breaking hyphen)
            data = data.replace('\u2011', '-')  # Replace non-breaking hyphen

            model_match = re.match(r'(\d{4})(?:\s*-\s*(\d{4}))?\s+(.+)', data)
            if model_match:
                start_year = int(model_match.group(1))
                end_year = int(model_match.group(2)) if model_match.group(2) else start_year
                model_name = model_match.group(3).strip()

                # Strip manufacturer prefix from model name if present
                # e.g., "Abarth 595" -> "595", "Ford GT" -> "GT"
                manufacturer_words = self.current_manufacturer.lower().split()
                model_words = model_name.split()

                # Check if model starts with manufacturer name
                if model_words and model_words[0].lower() in manufacturer_words:
                    # Remove the first word (manufacturer prefix)
                    model_name = ' '.join(model_words[1:]) if len(model_words) > 1 else model_name

                model_data = {
                    "model": model_name,
                    "years": list(range(start_year, end_year + 1)),
                    "start_year": start_year,
                    "end_year": end_year
                }

                # Avoid duplicates
                if not any(m["model"] == model_name and m["start_year"] == start_year
                          for m in self.carplay_data[self.current_manufacturer]):
                    self.carplay_data[self.current_manufacturer].append(model_data)


def fetch_carplay_data():
    """Fetch and parse CarPlay data from Apple's website."""
    print(f"Fetching data from {CARPLAY_URL}...")

    try:
        # Create request with user agent to avoid blocking
        req = Request(
            CARPLAY_URL,
            headers={'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)'}
        )

        with urlopen(req, timeout=30) as response:
            html_content = response.read().decode('utf-8')

        parser = CarPlayHTMLParser()
        parser.feed(html_content)

        if not parser.carplay_data:
            print("Warning: No data was extracted. The page structure may have changed.")
            print("Falling back to manual data...")
            return get_fallback_data()

        return parser.carplay_data

    except Exception as e:
        print(f"Error fetching data: {e}")
        print("Falling back to manual data...")
        return get_fallback_data()


def get_fallback_data():
    """Fallback data in case web scraping fails."""
    return {
        "Abarth": [
            {"model": "595", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "695", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "500e", "years": list(range(2023, 2025)), "start_year": 2023, "end_year": 2024}
        ],
        "Acura": [
            {"model": "NSX", "years": list(range(2017, 2024)), "start_year": 2017, "end_year": 2023},
            {"model": "MDX", "years": list(range(2018, 2025)), "start_year": 2018, "end_year": 2024},
            {"model": "TLX", "years": list(range(2018, 2025)), "start_year": 2018, "end_year": 2024},
            {"model": "ILX", "years": list(range(2019, 2023)), "start_year": 2019, "end_year": 2022},
            {"model": "RDX", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Integra", "years": list(range(2023, 2025)), "start_year": 2023, "end_year": 2024},
            {"model": "ZDX", "years": [2024], "start_year": 2024, "end_year": 2024}
        ],
        "Ford": [
            {"model": "C-MAX", "years": list(range(2017, 2020)), "start_year": 2017, "end_year": 2019},
            {"model": "Fiesta", "years": list(range(2017, 2020)), "start_year": 2017, "end_year": 2019},
            {"model": "Flex", "years": list(range(2017, 2020)), "start_year": 2017, "end_year": 2019},
            {"model": "Focus", "years": list(range(2017, 2020)), "start_year": 2017, "end_year": 2019},
            {"model": "Taurus", "years": list(range(2017, 2020)), "start_year": 2017, "end_year": 2019},
            {"model": "Edge", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Escape", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Expedition", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "F-150", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Fusion", "years": list(range(2017, 2021)), "start_year": 2017, "end_year": 2020},
            {"model": "Transit", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Transit Connect", "years": list(range(2017, 2023)), "start_year": 2017, "end_year": 2022},
            {"model": "Mustang", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Super Duty", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Explorer", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "EcoSport", "years": list(range(2018, 2023)), "start_year": 2018, "end_year": 2022},
            {"model": "Ford GT", "years": list(range(2018, 2024)), "start_year": 2018, "end_year": 2023},
            {"model": "Mustang Mach-E", "years": list(range(2021, 2025)), "start_year": 2021, "end_year": 2024},
            {"model": "Bronco", "years": list(range(2021, 2025)), "start_year": 2021, "end_year": 2024},
            {"model": "Bronco Sport", "years": list(range(2021, 2025)), "start_year": 2021, "end_year": 2024},
            {"model": "Evos", "years": list(range(2022, 2025)), "start_year": 2022, "end_year": 2024},
            {"model": "Maverick", "years": list(range(2022, 2025)), "start_year": 2022, "end_year": 2024},
            {"model": "E-Transit", "years": list(range(2023, 2025)), "start_year": 2023, "end_year": 2024}
        ],
        "Honda": [
            {"model": "Accord", "years": list(range(2016, 2025)), "start_year": 2016, "end_year": 2024},
            {"model": "Civic", "years": list(range(2016, 2025)), "start_year": 2016, "end_year": 2024},
            {"model": "Ridgeline", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "CR-V", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Pilot", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Odyssey", "years": list(range(2018, 2025)), "start_year": 2018, "end_year": 2024},
            {"model": "Clarity", "years": list(range(2019, 2023)), "start_year": 2019, "end_year": 2022},
            {"model": "Fit", "years": list(range(2018, 2021)), "start_year": 2018, "end_year": 2020},
            {"model": "HR-V", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Insight", "years": list(range(2019, 2023)), "start_year": 2019, "end_year": 2022},
            {"model": "Passport", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Prologue", "years": [2024], "start_year": 2024, "end_year": 2024}
        ],
        "Hyundai": [
            {"model": "Sonata", "years": list(range(2015, 2025)), "start_year": 2015, "end_year": 2024},
            {"model": "Tucson", "years": list(range(2016, 2025)), "start_year": 2016, "end_year": 2024},
            {"model": "Santa Fe", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Kona", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Elantra", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "Palisade", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "Venue", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "Ioniq 5", "years": list(range(2022, 2025)), "start_year": 2022, "end_year": 2024},
            {"model": "SANTA CRUZ", "years": list(range(2022, 2025)), "start_year": 2022, "end_year": 2024},
            {"model": "IONIQ 6", "years": list(range(2023, 2025)), "start_year": 2023, "end_year": 2024, "supports_carkey": True}
        ],
        "Mazda": [
            {"model": "Mazda6", "years": list(range(2018, 2023)), "start_year": 2018, "end_year": 2022},
            {"model": "CX-5", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "CX-9", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Mazda3", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "CX-30", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "CX-50", "years": list(range(2022, 2025)), "start_year": 2022, "end_year": 2024}
        ],
        "Subaru": [
            {"model": "Impreza", "years": list(range(2017, 2025)), "start_year": 2017, "end_year": 2024},
            {"model": "BRZ", "years": list(range(2018, 2025)), "start_year": 2018, "end_year": 2024},
            {"model": "Crosstrek", "years": list(range(2018, 2025)), "start_year": 2018, "end_year": 2024},
            {"model": "Legacy", "years": list(range(2018, 2025)), "start_year": 2018, "end_year": 2024},
            {"model": "Outback", "years": list(range(2018, 2025)), "start_year": 2018, "end_year": 2024},
            {"model": "Ascent", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Forester", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "WRX", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Solterra", "years": list(range(2023, 2025)), "start_year": 2023, "end_year": 2024}
        ],
        "Toyota": [
            {"model": "Camry", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Corolla", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "RAV4", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Highlander", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "4Runner", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "Tacoma", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "Tundra", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "Sienna", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "Prius", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "Corolla Hatchback", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "C-HR", "years": list(range(2019, 2025)), "start_year": 2019, "end_year": 2024},
            {"model": "GR Supra", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "Sequoia", "years": list(range(2020, 2025)), "start_year": 2020, "end_year": 2024},
            {"model": "bZ4X", "years": list(range(2023, 2025)), "start_year": 2023, "end_year": 2024}
        ]
    }

    return carplay_data


def main():
    """Generate the CarPlay support JSON file."""
    data = fetch_carplay_data()

    output_file = 'data/carplay_support.json'

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"✓ Generated CarPlay support data: {output_file}")
    print(f"  - {len(data)} manufacturers")
    total_models = sum(len(models) for models in data.values())
    print(f"  - {total_models} model entries")

    # Show some examples
    print("\nSample data:")
    for make in ["Ford", "Honda", "Toyota"]:
        if make in data:
            print(f"\n{make}:")
            for model in data[make][:3]:
                year_range = f"{model['start_year']}-{model['end_year']}" if model['start_year'] != model['end_year'] else str(model['start_year'])
                print(f"  - {model['model']}: {year_range}")


if __name__ == '__main__':
    main()
