#!/bin/bash

# Check for directory argument
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

search_dir="$1"

# Find files, skip hidden directories, print top 50 longest with their lengths
find "$search_dir" \
  -type d -name '.*' -prune -o \
  -type f -print |
while IFS= read -r file; do
  length=${#file}
  if [[ "$length" -ge 222 ]]; then
    echo -e "$file\t$length"
  fi
# done | sort -k2 -nr | head -n 50
done | sort -k2 -nr
