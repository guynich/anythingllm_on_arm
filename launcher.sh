#!/usr/bin/env bash

# Check if the container 'anythingllm_on_arm' is already running or already exists.
if docker ps --filter "name=anythingllm_on_arm" --filter "status=running" | grep -q "anythingllm_on_arm"; then
    echo "Container 'anythingllm_on_arm' is already running. Skipping Docker setup."
elif docker ps -a --filter "name=anythingllm_on_arm" | grep -q "anythingllm_on_arm"; then
    echo "Container 'anythingllm_on_arm' exists but is not running. Restarting the container."
    docker start anythingllm_on_arm
else
    # Launch AnythingLLM docker with name to avoid duplicate containers.
    export STORAGE_LOCATION=$HOME/anythingllm && \
    mkdir -p "$STORAGE_LOCATION" && touch "$STORAGE_LOCATION/.env" && \
    docker run -d -p 3001:3001 --cap-add SYS_ADMIN \
    -v "${STORAGE_LOCATION}":/app/server/storage \
    -v "${STORAGE_LOCATION}"/.env:/app/server/.env \
    -e STORAGE_DIR="/app/server/storage" \
    --name anythingllm_on_arm \
    mintplexlabs/anythingllm
fi

# Launch Chromium browser with lower priority to mitigate slow LLM rate.
nice -n 10 chromium-browser http://localhost:3001

exit 0
