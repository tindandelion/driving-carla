#!/bin/bash 
docker run -it --rm \
    --mount type=bind,source="$(pwd)"/docs,target=/app \
    gh-pages:latest \
    /bin/bash