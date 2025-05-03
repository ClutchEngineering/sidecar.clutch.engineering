#!/bin/bash
set -e

# Generate the site
swift run gensite

# Process CSS with Tailwind
npx tailwindcss -i tailwind.css -o ./site/css/main.css --minify
