#!/usr/bin/env bash
docker run \
    -v $(pwd)/mounts/logs:/app/Logs \
    -v $(pwd)/mounts/temp:/app/Temp \
    -v $(pwd)/mounts/downloads:/app/Downloads \
    -it twinvine bash -c "uv run envied $@"