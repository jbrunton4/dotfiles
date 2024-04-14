#!/bin/bash

sudo apt-get install tmux

touch $HOME/.tmux.conf
curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.tmux.conf > $HOME/.tmux.conf

tmux source $HOME/.tmux.conf