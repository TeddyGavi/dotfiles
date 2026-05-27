#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 input_file output_file"
  exit 1
fi

# Assign arguments to variables
input_file="$1"
output_file="$2"

# Run ffmpeg command to compress the video
ffmpeg -i "$input_file" -vcodec libx264 -crf 28 "$output_file"

# Check if ffmpeg command was successful
if [ $? -eq 0 ]; then
  echo "Video compression completed successfully."
else
  echo "An error occurred during video compression."
  exit 1
fi

# ffmpeg -i input.mp4 -vcodec libx264 -crf 6 output.mp4
