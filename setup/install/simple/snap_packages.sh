packages=(
    "ascii-image-converter"
    "lazygit"
    "lolcat"
)

for package in "${packages[@]}"
do
    echo "===== SNAP INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
    snap install $package >> $HOME/.brunt-dotfiles/logs/latest
done