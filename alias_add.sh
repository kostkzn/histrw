#!/bin/bash

mkdir -p -v "$HOME/bin"
cp -v ./histrw.sh "$HOME/bin/"
echo 'alias add="history' '|' "$HOME/bin/histrw.sh\"" >> "$HOME"/.bashrc
# shellcheck source=/dev/null
source "$HOME/.bashrc"
