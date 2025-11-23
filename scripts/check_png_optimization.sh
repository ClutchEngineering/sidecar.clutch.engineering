#!/bin/bash
# Check if PNG files in site/ are optimized without modifying them.
# Uses optipng -simulate -o1 for fast checking (~0.01s per file).
# The check uses -o1 for speed; actual optimization should use -o5.
# Exit code 0 = all optimized, 1 = some need optimization

SITE_DIR="${1:-site}"
UNOPTIMIZED=()

echo "Checking PNG optimization status in $SITE_DIR..."

# Find all PNG files
PNG_FILES=$(find "$SITE_DIR" -name "*.png" -type f 2>/dev/null)
TOTAL=$(echo "$PNG_FILES" | grep -c . || echo 0)

if [ "$TOTAL" -eq 0 ]; then
  echo "No PNG files found in $SITE_DIR"
  exit 0
fi

echo "Found $TOTAL PNG files to check"
echo ""

CHECKED=0
for png in $PNG_FILES; do
  CHECKED=$((CHECKED + 1))

  # Run optipng in simulate mode with -o1 (fastest check)
  # This detects if ANY optimization is possible; actual optimization uses -o5
  OUTPUT=$(optipng -simulate -o1 "$png" 2>&1 || true)

  # Extract input and output IDAT sizes
  INPUT_SIZE=$(echo "$OUTPUT" | grep "Input IDAT size" | sed 's/.*= \([0-9]*\).*/\1/')
  OUTPUT_SIZE=$(echo "$OUTPUT" | grep "IDAT size = " | tail -1 | sed 's/.*IDAT size = \([0-9]*\).*/\1/')

  if [ -n "$INPUT_SIZE" ] && [ -n "$OUTPUT_SIZE" ]; then
    if [ "$INPUT_SIZE" -gt "$OUTPUT_SIZE" ]; then
      SAVINGS=$((INPUT_SIZE - OUTPUT_SIZE))
      PERCENT=$((SAVINGS * 100 / INPUT_SIZE))
      echo "  $png (unoptimized, ~${PERCENT}% savings possible)"
      UNOPTIMIZED+=("$png")
    fi
  fi

  # Progress indicator every 50 files
  if [ $((CHECKED % 50)) -eq 0 ]; then
    echo "  ... checked $CHECKED/$TOTAL files"
  fi
done

echo ""
echo "----------------------------------------"

if [ ${#UNOPTIMIZED[@]} -eq 0 ]; then
  echo "All $TOTAL PNG files are optimized."
  exit 0
else
  echo "Found ${#UNOPTIMIZED[@]} unoptimized PNG file(s)."
  echo ""
  echo "To optimize, run:"
  echo ""
  echo "  optipng -o5 \\"
  for png in "${UNOPTIMIZED[@]}"; do
    echo "    \"$png\" \\"
  done
  echo ""
  exit 1
fi
