#!/bin/bash

# Function to extract strings following 'en-US' from a file
extract_strings() {
    local filename="$1"
    local output_file="$2"

    # Print filename
    echo "Filename: $filename" >> "$output_file"

    # Extract strings following 'en-US' and save to output file
    grep -o "'en-US': '[^']*'" "$filename" | sed "s/'en-US': '\([^']*\)'/\1/g" >> "$output_file"
    echo "" >> "$output_file" # Add a newline after each file's keys
}

# Function to process files recursively in a directory
process_files() {
    local input_dir="$1"
    local output_dir="$2"
    local output_file="$output_dir/extracted_strings.txt"

    # Loop through each file in the directory
    for file in "$input_dir"/*; do
        if [ -d "$file" ]; then
            # If it's a directory, recursively process it
            process_files "$file" "$output_dir"
        elif [ -f "$file" ]; then
            # If it's a file, extract strings following 'en-US' and save to output file
            filename=$(basename "$file")
            extract_strings "$file" "$output_file"
            echo "Extracted strings from $file"
        fi
    done
}

# Check if input directory is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

# Check if input directory exists
if [ ! -d "$1" ]; then
    echo "Error: Input directory '$1' not found."
    exit 1
fi

# Create an output directory
output_dir="extracted_strings"
mkdir -p "$output_dir"

# Process files recursively
process_files "$1" "$output_dir"

echo "Extraction completed. Extracted strings are saved in the '$output_dir' directory."
