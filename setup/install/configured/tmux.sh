apt-get install tmux

touch $HOME/.tmux.conf
curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/tmux/.tmux.conf > $HOME/.tmux.conf

tmux source $HOME/.tmux.conf