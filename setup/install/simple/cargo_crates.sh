#!/bin/bash

# install sscache first, to skip re-compiling shared dependencies
echo "===== CARGO INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
cargo install sccache >> $HOME/.brunt-dotfiles/logs/latest

packages=(
    "atuin"
    "du-dust"
    "eza"
    "ripgrep"
)

for package in "${packages[@]}"
do
    echo "===== CARGO INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
    cargo install $package >> $HOME/.brunt-dotfiles/logs/latest
done