#!/bin/bash

snap install newsboat 
curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.config/newsboat/urls > $HOME/.config/newsboat/urls