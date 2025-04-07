#!/usr/bin/env bash
# This script updates the AnythingLLM docker container to the latest version.

# Define the container name used in launcher script.
CONTAINER_NAME="anythingllm_on_arm"

# Get latest AnythingLLM docker.
docker pull mintplexlabs/anythingllm:latest

# Check if the container is already running or exists and remove.
if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
    echo "Container '$CONTAINER_NAME' is running."
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
elif docker ps -a --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
    echo "Container '$CONTAINER_NAME' exists but is not running."
    docker rm "$CONTAINER_NAME"
fi

echo "Run launcher script to use latest AnythingLLM docker container."

exit 0
