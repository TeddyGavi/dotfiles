#!/bin/bash

# Check if curl and bc (for floating-point arithmetic) are installed
command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but not installed. Aborting."; exit 1; }
command -v bc >/dev/null 2>&1 || { echo >&2 "bc is required but not installed. Aborting."; exit 1; }

# Function to run curl command and measure response time
run_curl() {
    local curl_command="$1"
    local num_runs="$2"
    local total_time=0
    local avg_time=0

    local progress_char="/-\|"
    local progress_idx=0
    # Run the curl command and measure response time
    for ((i=1; i<=$num_runs; i++)); do
        # Measure time taken for each request
        start_time=$(date +%s.%N)
        response=$(eval "$curl_command" >/dev/null 2>&1)
        end_time=$(date +%s.%N)

        # Calculate response time and add to total
        run_time=$(echo "$end_time - $start_time" | bc)
        total_time=$(echo "$total_time + $run_time" | bc)
        avg_time=$(echo "scale=5; $total_time / $i" | bc)

        printf "\033[K\rProgress: [%c] | Run: %d/%d | Total Time: %.3fs | Average Time: %.3fs" "${progress_char:$progress_idx:1}" "$i" "$num_runs" "$total_time" "$avg_time"
        progress_idx=$(( (progress_idx+1) % ${#progress_char} ))

        # Sleep for a short duration to simulate a request delay (optional)
        sleep 0.1
    done

    # Calculate average response time
    avg_time=$(echo "scale=5; $total_time / $num_runs" | bc)

    # Display final results
    echo "Total Runs: $num_runs | Total Time (s): $total_time | Average Time (s): $avg_time"
}

# Check if arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <Curl Command> <Number of Runs>"
    exit 1
fi

# Run the curl command and measure response time
run_curl "$1" "$2"
