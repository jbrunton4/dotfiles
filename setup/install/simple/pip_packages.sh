#!/bin/bash

packages=(
    "speedtest-cli"
    "pyinstaller"
)

for package in "${packages[@]}"
do
    echo "===== PIP INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
    python3 -m pip install $package >> $HOME/.brunt-dotfiles/logs/latest
done