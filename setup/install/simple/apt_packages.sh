packages=(
    "bashtop"
    "bat"
    "cloc"
    "dos2unix"
    "dotnet7"
    "dotnet-sdk-8.0"
    "exa"
    "ffmpeg"
    "fzf"
    "git"
    "gh"
    "kdiff3"
    "nmap"
    "ripgrep"
    "tree"
    "code"
)

for package in "${packages[@]}"
do
    echo "===== APT INSTALL: $package =====" >> $HOME/.brunt-dotfiles/logs/latest
    sudo apt install -y $package >> $HOME/.brunt-dotfiles/logs/latest
done