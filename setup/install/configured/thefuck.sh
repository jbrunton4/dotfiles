apt install python3-dev python3-pip python3-setuptools
pip3 install thefuck --user

if grep -q "eval \$(thefuck --alias" ~/.bashrc
    then
        : # pass
    else
        echo "" >> ~/.bashrc
        echo "# the fuck" >> ~/.bashrc
        echo "eval \$(thefuck --alias)" >> ~/.bashrc
        echo "eval \$(thefuck --alias fuck)" >> ~/.bashrc
        echo "eval \$(thefuck --alias FUCK)" >> ~/.bashrc
    fi