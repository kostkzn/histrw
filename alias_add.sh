#!/bin/bash

mkdir -p -v "$HOME/bin"
chmod u+x ./histrw.sh
cp -v ./histrw.sh "$HOME/bin/"
echo 'alias add="history' '|' "$HOME/bin/histrw.sh\"" >> "$HOME"/.bashrc
echo -e "\nPlease run:\n  source ~/.bashrc\n\nor restart your terminal to activate the alias."
