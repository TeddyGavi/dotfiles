#!/bin/bash

# Use current directory
src_dir="."

# Loop over all files in the current directory
for file in "$src_dir"/*; do
  # Skip if not a regular file
  [[ -f "$file" ]] || continue

  # Get filename without extension
  filename=$(basename "$file")
  base="${filename%.*}"
  output="$src_dir/${base}.png"

  # Try to convert the image to PNG
  if magick "$file" "$output"; then
    echo "Converted: $file → $output"
    # Optionally delete the original if it's not already .png
    [[ "$file" != "$output" ]] && rm "$file"
  else
    echo "Failed to convert: $file (might be corrupt)"
  fi
done
