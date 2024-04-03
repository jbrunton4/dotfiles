if [ ! $(jq '.profile' $HOME/.brunt-dotfiles/config/install.json) -eq "\"home\"" ]; then
    exit 0
fi

apt install libnotify4
apt install libnspr4
apt install libnss3

mkdir -p $HOME/.brunt-dotfiles/install/discord
curl -sSL "https://discord.com/api/download?platform=linux&format=deb" > $HOME/.brunt-dotfiles/install/discord/installer.deb
dpkg -i $HOME/.brunt-dotfiles/install/discord/installer.deb
apt install -f 