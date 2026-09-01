#!/usr/bin/env bash

ocker build --build-arg USER_ID=$UID --build-arg GROUP_ID=$(id -g) --label keep=true -t twinvine .
