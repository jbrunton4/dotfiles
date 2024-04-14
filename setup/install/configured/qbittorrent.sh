#!/usr/bin

if [[ "$(jq -r '.profile' $HOME/.brunt-dotfiles/config/install.json)" -ne "home" ]]; then
    exit 0
fi

apt-get install qbittorrent # ppa:qbittorrent-team/qbittorrent-stable