#!/usr/bin/env bash

# Define the container name
CONTAINER_NAME="anythingllm_on_arm"

# Check if the container is already running or exists
if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
    echo "Container '$CONTAINER_NAME' is already running. Skipping Docker setup."
elif docker ps -a --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
    echo "Container '$CONTAINER_NAME' exists but is not running. Restarting the container."
    docker start "$CONTAINER_NAME"
else
    # Launch AnythingLLM docker with name to avoid duplicate containers.
    export STORAGE_LOCATION=$HOME/anythingllm && \
    mkdir -p "$STORAGE_LOCATION" && touch "$STORAGE_LOCATION/.env" && \
    docker run -d -p 3001:3001 --cap-add SYS_ADMIN \
    -v "${STORAGE_LOCATION}":/app/server/storage \
    -v "${STORAGE_LOCATION}"/.env:/app/server/.env \
    -e STORAGE_DIR="/app/server/storage" \
    --name "$CONTAINER_NAME" \
    mintplexlabs/anythingllm
fi

# Launch Chromium browser with lower priority to mitigate slow LLM rate.
nice -n 10 chromium-browser http://localhost:3001

exit 0
