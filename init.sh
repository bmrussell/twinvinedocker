#!/usr/bin/env bash

if [ ! -d "./TwinVine" ]; then
  git clone --depth 1 https://github.com/vinefeeder/TwinVine.git
fi

cp *.wvd ./TwinVine/WVDs/
cp versions.sh ./TwinVine/
cp envied.yaml ./TwinVine/packages/envied/src/envied/envied.yaml

if [ ! -d "./mounts" ]; then
  mkdir -p mounts/downloads
  mkdir logs
  mkdir temp
fi
