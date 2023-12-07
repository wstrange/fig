#!/usr/bin/env bash
# Start the first command in the background
envoy -c envoy.yaml &
# Get the process ID of the first command
pid1=$!

# Start the second command in the background
dart bin/run.dart &
# Get the process ID of the second command
pid2=$!

# Trap the SIGINT signal (Ctrl+C)
trap "kill $pid1; kill $pid2; exit" INT

# Wait for both commands to finish
wait $pid1 $pid2
