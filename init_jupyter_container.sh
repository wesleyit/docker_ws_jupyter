#!/bin/bash

## This is where the git repo has been downloaded and
# the volume will me mounted, allowing the container to
## access the host files. The UID and GID must be 1000.
JUPYTER_DIR="$HOME/Jupyter"
mkdir -p "$JUPYTER_DIR"

## Kill the container if it is already running and start up
# a new instance, using the 8888 port.
docker rm -rf ws-jupyter || true 
docker run -d -it \
    --name ws-jupyter \
    -v "$JUPYTER_DIR/notebooks":/home/jupyter/notebooks \
    -p 8888:8888 \
    wesleyit/ws-jupyter:latest 
