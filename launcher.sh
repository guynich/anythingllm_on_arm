#!/usr/bin/env bash

# Launch AnythingLLM docker with name to avoid duplicate containers.
export STORAGE_LOCATION=$HOME/anythingllm && \
mkdir -p "$STORAGE_LOCATION" && touch "$STORAGE_LOCATION/.env" && \
docker run -d -p 3001:3001 --cap-add SYS_ADMIN \
-v "${STORAGE_LOCATION}":/app/server/storage \
-v "${STORAGE_LOCATION}"/.env:/app/server/.env \
-e STORAGE_DIR="/app/server/storage" \
--name anythingllm_on_arm \
mintplexlabs/anythingllm

# Launch Chromium browser with lower priority to mitigate slow LLM rate.
nice -n 10 chromium-browser

exit 0