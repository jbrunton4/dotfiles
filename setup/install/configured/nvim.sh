yes | add-apt-repository ppa:neovim-ppa/unstable
yes | apt-get install neovim

rm -rf $HOME/.config/nvim/* 
clone_folder_name="./nvim-$(date +%s%N)"
git clone https://github.com/jbrunton4/dotfiles.git --branch main --single-branch --depth 1 $clone_folder_name
mkdir $HOME/.config/nvim
mv $clone_folder_name/nvim/* $HOME/.config/nvim
rm -rf $clone_folder_name

nvim --cmd "so $HOME/.config/nvim/init.lua" --cmd "qall"
nvim --headless -c "lua require('packer').sync()" -c "qa"