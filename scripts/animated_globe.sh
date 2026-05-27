#!/bin/bash

# Function to run curl command with pv
run_curl_with_pv() {
    # curl -s http://artscene.textfiles.com/vt100/movglobe.vt | pv -q -L 9600
    # curl -s http://artscene.textfiles.com/vt100/frogs.vt | pv -q -L 1200
    # curl -s http://artscene.textfiles.com/vt100/fireworks.vt | pv -q -L 1200
    curl -s http://artscene.textfiles.com/vt100/crash.vt | pv -q -L 500
    # curl -s http://artscene.textfiles.com/vt100/duckpaint.vt | pv -q -L 500
}

# Function to handle Ctrl+C interrupt
cleanup() {
    echo "Exiting..."
    clear
    exit 0
}

# Trap Ctrl+C to call the cleanup function
trap cleanup INT

# Prompt the user for the duration in minutes
echo -n "Enter the duration in minutes: "
read duration_minutes

# Convert minutes to seconds
duration_seconds=$((duration_minutes * 60))

# Start time for measuring duration
start_time=$(date +%s)

# Run curl command with pv repeatedly until the specified duration is reached
while (( $(date +%s) - start_time < duration_seconds )); do
    run_curl_with_pv
done

clear
echo "Duration completed."
