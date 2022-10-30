#!/bin/sh

# We'll use this script to manage starting and stopping this container gracefully.
# It only takes up about 00.01 CPU % allotted to the container, you can verify
# by running `docker stats` after you start a container that uses this as
# as the CMD.

set -e

shutd () {
    printf "Shutting down the container gracefully..."
    # You can run clean commands here!
    printf "done\n"
}

trap 'shutd' TERM

echo "Starting up..."

# Run non-blocking commands here

# This keeps the container running until it receives a signal to be stopped.
# Also very low CPU usage.
while :; do :; done & kill -STOP $! && wait $!
