# apt install gpg
# mkdir -p /etc/apt/keyrings
# yes | wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
# echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
# chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
apt install eza

if grep -q "alias eza='ls'" ~/.bash_aliases
then
    : # pass
else
    echo "alias eza='ls'" >> ~/.bash_aliases
fi