#!/bin/bash

extract_catch_block() {
    local filename="$1"
    local output_file="$2"

    # Extract content inside .catch block and save to temporary file
    local temp_file=$(mktemp)
    awk '/\.catch\(.*\)/, /\}/ {print}' "$filename" > "$temp_file"

    # Check if awk command extracted any content
    if [ -s "$temp_file" ]; then

        echo "Filename: $filename" >> "$output_file"
        sed 's/^/  /' "$temp_file" >> "$output_file"
        echo "" >> "$output_file"
        echo "Extracted .catch block from $filename"
    fi

    # Remove temporary file
    rm "$temp_file"
}

process_files() {
    local input_dir="$1"
    local output_dir="$2"
    local output_file="$output_dir/extracted_blocks.txt"

    # Loop through each file in the directory
    for file in "$input_dir"/*; do
        if [ -d "$file" ]; then
            # If it's a directory, recursively process it
            process_files "$file" "$output_dir"
        elif [ -f "$file" ]; then
            filename=$(basename "$file")
            extract_catch_block "$file" "$output_file"
            echo "Extracted .catch block from $file"
        fi
    done
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: Input directory '$1' not found."
    exit 1
fi

output_dir="extracted_blocks"
mkdir -p "$output_dir"

# Process files recursively
process_files "$1" "$output_dir"

echo "Extraction completed. Extracted blocks are saved in the '$output_dir' directory."
