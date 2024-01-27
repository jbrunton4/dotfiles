apt-get install tmux

if grep -q "tmux kill-session -a" ~/.bashrc
then
    : # pass
else
    echo "" >> ~/.bashrc
    echo "# tmux" >> ~/.bashrc
    echo "tmux" >> ~/.bashrc
    echo "tmux kill-session -a" >> ~/.bashrc
fi

touch $HOME/.tmux.conf
curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/tmux/.tmux.conf > $HOME/.tmux.conf

tmux source $HOME/.tmux.conf