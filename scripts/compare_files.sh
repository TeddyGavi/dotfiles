#!/bin/bash

# Check if two arguments are passed
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <file1> <file2>"
  exit 1
fi

# Assign arguments to variables
file1="$1"
file2="$2"

# Check if both files exist
if [[ ! -f "$file1" ]]; then
  echo "File $file1 does not exist."
  exit 1
fi

if [[ ! -f "$file2" ]]; then
  echo "File $file2 does not exist."
  exit 1
fi

# Compare the files and print differences
diff_output=$(diff "$file1" "$file2")

if [[ -z "$diff_output" ]]; then
  echo "The files are identical."
else
  echo "The files are different. Here are the differences:"
  echo "$diff_output"
fi
