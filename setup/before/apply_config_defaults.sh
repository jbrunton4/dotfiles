#!/bin/bash

if [ ! -f "$HOME/.brunt-dotfiles/config/install.json" ]; then 
    curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/config_defaults/install.json > "$HOME/.brunt-dotfiles/config/install.json"
fi

if [ ! -f "$HOME/.brunt-dotfiles/config/logs.json" ]; then 
    curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/config_defaults/logs.json > "$HOME/.brunt-dotfiles/config/logs.json"
fi