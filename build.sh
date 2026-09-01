#!/usr/bin/env bash

if [ -d "./temp/TwinVine" ]; then
    cd ./temp/TwinVine
    git pull
else
    mkdir -p ./temp
    cd ./temp
    git clone https://github.com/vinefeeder/TwinVine.git
    cd ..
fi

docker build --build-arg USER_ID=$UID --build-arg GROUP_ID=$(id -g) --label keep=true -t twinvine .
