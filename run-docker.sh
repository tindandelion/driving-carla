#!/bin/bash 
docker run -d --rm \
    -p 4000:4000 \
    --mount type=bind,source="$(pwd)"/docs,target=/app \
    --name driving-carla \
    gh-pages:latest