#!/bin/bash

# Check if required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <url> <timeout_in_seconds>"
    exit 1
fi

url=$1
timeout=$2

echo "Checking $url at random intervals between 1 and 13 minutes with a $timeout second timeout. Press Ctrl+C to stop."

while true; do
    # Generate a random interval between 1 and 13 minutes
    interval=$((RANDOM % 13 + 1))
    interval_seconds=$((interval * 60))

    start_time=$(date +%s)
    response=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout $timeout --max-time $timeout $url)
    end_time=$(date +%s)
    duration=$((end_time - start_time))

    if [ $response -eq 200 ]; then
        echo "$(date): $url is up (HTTP $response, responded in ${duration}s)"
    else
        echo "$(date): $url is down (HTTP $response, timed out after ${duration}s)"
    fi

    echo "Waiting for $interval minutes before next check..."
    sleep $interval_seconds
done