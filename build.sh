#!/bin/bash

IMAGE_NAME=elasticsearch-kibana3

if [ -z $1 ]; then
    echo "[INFO] run -> docker build --no-cache --rm -t exlair/$IMAGE_NAME ."
    docker build --no-cache --rm -t exlair/$IMAGE_NAME .
else
    echo "[INFO] run -> docker build --no-cache --rm -t exlair/$IMAGE_NAME:$1 ."
    docker build --no-cache --rm -t exlair/$IMAGE_NAME:$1 .
fi
