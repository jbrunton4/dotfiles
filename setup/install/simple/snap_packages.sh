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
fi

if [ $(jq '.profile' $HOME/.brunt-dotfiles/config/install.json) -eq "home" ]; then
    packages+=("discord")
fi

for package in "${packages[@]}"
do
    echo "===== SNAP INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
    snap install $package >> $HOME/.brunt-dotfiles/logs/latest
done