#!/bin/bash
cd "$HOME" || exit 1

## Disable password and set the default config file
IPYTHON_OPTIONS+=' --config=./jupyter_notebook_config.py '
IPYTHON_OPTIONS+=' --notebook-dir=./notebooks '
IPYTHON_OPTIONS+=' --NotebookApp.password="" '
IPYTHON_OPTIONS+=' --NotebookApp.token="" '

## Enable extensions and start the jupyter daemon
jupyter-contrib-nbextension install --user
jupyter-nbextension enable --py --user widgetsnbextension
jupyter-notebook $IPYTHON_OPTIONS
