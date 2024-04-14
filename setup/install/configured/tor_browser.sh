#!/bin/bash

if [[ "$(jq -r '.profile' $HOME/.brunt-dotfiles/config/install.json)" -ne "home" ]] || [ -f /etc/wsl.conf ]; then
    exit 0
fi

if [ -d $HOME/.brunt-dotfiles/install/tor-browser ]; then
    exit 0
fi

tempfile_name="$(pwd)/tor_browser_$(date +%s%N).tar.xz"
install_dir="$HOME/.brunt-dotfiles/install/"

mkdir -p $install_dir

wget -O $tempfile_name https://www.torproject.org/dist/torbrowser/13.0.10/tor-browser-linux-x86_64-13.0.10.tar.xz
tar -xf $tempfile_name -C $install_dir

rm -rf $tempfile_name