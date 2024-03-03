#!/bin/bash
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

mkdir -p $HOME/.config/lvim
curl -sSL https://github.com/jbrunton4/dotfiles/main/userhome/.config/lvim/config.lua > $HOME/.config/lvim/config.lua