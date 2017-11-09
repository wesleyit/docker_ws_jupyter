#!/bin/bash
export BKP_DIR="$(mktemp -d /tmp/ws_jupyter.tmp.XXXXXX)"
cd "${HOME}/.ws_jupyter/"
mv notebooks "${BKP_DIR}/"
git clean -df
git checkout -- .
git pull origin master
cd "${BKP_DIR}/notebooks"
for folder in */; do
    cd "$folder"
    mkdir -p "${HOME}/.ws_jupyter/notebooks/$folder/"
    \cp -rf * "${HOME}/.ws_jupyter/notebooks/$folder/"
    cd ..
done 
docker pull wesleyit/ws-jupyter:latest

