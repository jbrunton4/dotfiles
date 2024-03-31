#!/usr/bin

if [ "$(jq '.profile' $HOME/.brunt-dotfiles/config/install.json)" != "\"home\"" ]; then
    exit 0
fi

apt-get install qbittorrent # ppa:qbittorrent-team/qbittorrent-stable