#!/usr/bin/env bash
docker run \
    -v $(pwd)/mounts/logs:/app/Logs:z \
    -v $(pwd)/mounts/temp:/app/Temp:z \
    -v $(pwd)/mounts/downloads:/app/Downloads:z \
    -it twinvine bash -c "uv run envied $@"