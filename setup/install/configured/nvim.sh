#!/bin/bash

yes | add-apt-repository ppa:neovim-ppa/unstable
yes | sudo apt-get install neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

rm -rf $HOME/.config/nvim 
clone_folder_name="./nvim-$(date +%s%N)"
git clone https://github.com/jbrunton4/dotfiles.git --branch main --single-branch --depth 1 $clone_folder_name
mkdir $HOME/.config/nvim
mv $clone_folder_name/nvim/* $HOME/.config/nvim
rm -rf $clone_folder_name

# nvim --cmd "so $HOME/.config/nvim/init.lua" -c "qa"
# nvim --cmd "lua require('packer').sync()" -c "qa"