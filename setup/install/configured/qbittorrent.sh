#!/usr/bin

if [ $(jq '.profile' $HOME/.brunt-dotfiles/config/install.json) -ne "\"home\"" ]; then
    exit 0
fi

add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
apt-get install qbittorrent