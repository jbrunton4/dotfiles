#!/bin/bash

packages=(
    "ascii-image-converter"
    "lazygit"
    "lolcat"
    "code"
)

if [ ! -f /etc/wsl.conf ]; then
    packages+=("firefox")
    packages+=("gimp")
    packages+=("postman")
    packages+=("snap-store")
fi

if command -v snap &> /dev/null
then
    : # pass
else 
    echo -e "\033[0;33mWarning: Snap was not found. The following packages were not installed:"
    for package in "${packages[@]}"; do
        echo $package
    fi
    echo -e "\033[0;0m"
    exit 1
fi

for package in "${packages[@]}"
do
    echo "===== SNAP INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
    snap install $package >> $HOME/.brunt-dotfiles/logs/latest
done