if [ ! -f /etc/wsl.conf ]; then
    exit 0
fi

curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/wsl/wsl.conf > /etc/wsl.conf