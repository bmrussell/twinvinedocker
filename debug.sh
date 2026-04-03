#!/usr/bin/env bash
docker build --build-arg DEBUG=1 --build-arg USER_ID=$UID --build-arg GROUP_ID=$(id -g) -t twinvine .
docker run \
    -v $(pwd)/mounts/logs:/app/Logs:z \
    -v $(pwd)/mounts/temp:/app/Temp:z \
    -v $(pwd)/mounts/downloads:/app/Downloads:z \
    -p 5678:5678 -it twinvine $@