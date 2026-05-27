#!/bin/bash

for file in ./*.{jpg,jpeg,png}; do
  # Skip if no match
  [[ -e "$file" ]] || continue

  ext="${file##*.}"
  filename="${file%.*}"
  output="${filename}_compressed.${ext}"

  if [[ "$ext" =~ ^(jpg|jpeg)$ ]]; then
    # JPEG: compress with quality (1-100)
    magick "$file" -strip -interlace Plane -sampling-factor 4:2:0 -quality 75 "$output"
  elif [[ "$ext" == "png" ]]; then
    # PNG: lossless compress with PNG optimization
    magick "$file" -strip -define png:compression-level=9 "$output"
  fi

  echo "Compressed: $file → $output"
done
