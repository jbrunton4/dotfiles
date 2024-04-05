#!/bin/bash

curl -sSL "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.gitconfig" > "$HOME/.gitconfig"

if [[ "$(jq -r '.profile' $HOME/.brunt-dotfiles/config/install.json)" -eq "home" ]]; then
    git config --global user.email josh.brunton@proton.me
    git config --global github.user jbrunton4
elif [[ "$(jq -r '.profile' $HOME/.brunt-dotfiles/config/install.json)" -eq "work" ]]; then
    git config --global user.email josh.brunton@binary.ax
fi
