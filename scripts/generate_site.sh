#!/bin/bash
set -e

# Generate the site
cd generator
export SWIFT_BACKTRACE=enable=yes,color=yes
swift run gensite
cd ..

# Process CSS with Tailwind
npx tailwindcss -i tailwind.css -o ./site/css/main.css --minify
