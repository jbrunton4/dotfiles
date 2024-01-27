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