#!/bin/bash

install_destination="$HOME/.brunt-dotfiles/install/gitext"
rm -rf "$install_destination"
mkdir -p "$install_destination"

wget "https://github.com/gitextensions/gitextensions/releases/download/v2.51.05/GitExtensions-2.51.05-Mono.zip" -O ./temp.zip
unzip ./temp.zip -d "$install_destination"
rm ./temp.zip

rm "$install_destination/GitExtensions/Plugins/Bitbucket.dll"