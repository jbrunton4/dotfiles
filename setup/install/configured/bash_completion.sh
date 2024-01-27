apt install bash-completion

if grep -q "bash_completion" ~/.bashrc
then
    : # pass
else
    echo "" >> ~/.bashrc
    echo "# bash-completion" >> ~/.bashrc
    echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc
fi