#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 input_file output_file"
  exit 1
fi

# Assign arguments to variables
input_file="$1"
output_file="$2"

ffmpeg -ss 00:00:10 -t 00:00:05 -i "$input_file" -vf "fps=15,scale=320:-1:flags=lanczos,[0]split[a][b];[a]palettegen[p];[b][p]paletteuse" -loop 0 "$output_file"

# Check if ffmpeg command was successful
if [ $? -eq 0 ]; then
  echo "Video compression completed successfully."
else
  echo "An error occurred during video compression."
  exit 1
fi

