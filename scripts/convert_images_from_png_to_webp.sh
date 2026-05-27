#!/bin/bash


# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 input directory of pngs"
  exit 1
fi

# Assign arguments to variables
src_dir="$1"

# Loop over all files in the current directory
for file in "$1"/*.png; do
  # Skip if not a regular file
  [[ -f "$file" ]] || continue

  # Get filename without extension
  filename=$(basename "$file")
  base="${filename%.*}"
  output="$1/${base}.webp"

  # Try to convert the image to PNG
  if magick "$file" -define webp:lossless=true -define webp:method=6 "$output"; then
    echo "Converted: $file → $output"
  else
    echo "Failed to convert: $file (might be corrupt)"
  fi
done
