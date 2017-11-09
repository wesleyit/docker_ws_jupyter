#!/bin/bash

REPO="https://github.com/wesleyit/docker_ws_jupyter.git"
JUPYTER_SRC="$HOME/.ws_jupyter"
JUPYTER_DIR="$HOME/Jupyter"
git clone "$REPO" "$JUPYTER_SRC"
mkdir -p "$JUPYTER_DIR"

ln -s "$JUPYTER_SRC/init_jupyter_container.sh" "$JUPYTER_DIR/"
ln -s "$JUPYTER_SRC/update_jupyter.sh" "$JUPYTER_DIR/"
ln -s "$JUPYTER_SRC/notebooks" "$JUPYTER_DIR/"
