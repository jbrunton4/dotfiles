if [ ! -f /etc/wsl.conf ]; then
    exit 0
fi

cat ../../wsl/wsl.conf > /etc/wsl.conf