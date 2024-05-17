#!/bin/bash

sudo -v

yes "" | sudo pacman -S git base-devel neofetch tmux bat exa \
    python3 python-pip kdiff3 ffmpeg fzf cloc neovim nmap \
    bashtop
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo sh
cargo install atuin ripgrep

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# oh my posh
curl -s https://ohmyposh.dev/install.sh | bash -s