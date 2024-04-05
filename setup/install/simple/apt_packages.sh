#!/bin/bash

packages=(
    "bash-completion"
    "bashtop"
    "bat"
    "cloc"
    "dos2unix"
    "dotnet7"
    "dotnet-sdk-8.0"
    "ffmpeg"
    "fzf"
    "git"
    "gh"
    "kdiff3"
    "neofetch"
    "nmap"
    "ripgrep"
    "tree"
)

if [[ $(jq -r '.profile' $HOME/.brunt-dotfiles/config/install.json) -eq "home" ]]; then
    packages+=("wireshark")
fi

for package in "${packages[@]}"
do
    echo "===== APT INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
    sudo apt install -y $package >> $HOME/.brunt-dotfiles/logs/latest
done