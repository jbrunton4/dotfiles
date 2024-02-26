#!/bin/bash

if [ ! -f /etc/wsl.conf ]; then
    exit 0
fi

curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/linuxroot/etc/wsl.conf > /etc/wsl.conf