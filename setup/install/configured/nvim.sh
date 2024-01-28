yes | add-apt-repository ppa:neovim-ppa/unstable
yes | apt-get install neovim

nvim --cmd "source $HOME/.config/nvim/init.lua" --cmd "qall"
nvim --cmd "PackerSync" --cmd "qall"