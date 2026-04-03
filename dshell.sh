#!/usr/bin/env bash

docker run -it -v $(pwd)/mounts/logs:/app/Logs -v $(pwd)/mounts/temp:/app/Temp -v $(pwd)/mounts/downloads:/app/Downloads twinvine bash 